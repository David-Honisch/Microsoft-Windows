import sys

# Electron consumes child-process pipes as UTF-8, regardless of the Windows console code page.
for stream in (sys.stdin, sys.stdout, sys.stderr):
    reconfigure = getattr(stream, "reconfigure", None)
    if reconfigure is not None:
        reconfigure(encoding="utf-8", errors="replace")

import os
import json
import re
import argparse
import urllib.request
import urllib.parse
from langchain_ollama import ChatOllama
from langchain_core.tools import tool
from langchain_core.messages import HumanMessage, AIMessage, ToolMessage, SystemMessage
from ddgs import DDGS  # Für die Websuche

# ==========================================
# 1. Definition der Tools / Applikationen
# ==========================================

@tool
def web_search(query: str) -> str:
    """Sucht im Internet nach aktuellen Informationen, Nachrichten oder Ereignissen."""
    print(f"🔍 -> [System] Rufe Websuche auf für: '{query}'...")
    try:
        with DDGS() as ddgs:
            results = [r for r in ddgs.text(query, max_results=4)]
        if results:
            return json.dumps(results, ensure_ascii=False)
        else:
            return json.dumps({"hinweis": "Keine aktuellen Ergebnisse gefunden."})
    except Exception as e:
        return json.dumps({"fehler": f"Fehler bei der Websuche: {str(e)}"})


@tool
def check_weather(location: str) -> str:
    """Ruft die Open-Meteo API auf, um Echtzeit-Wetterdaten für einen bestimmten Ort zu laden."""
    print(f"-> [System] Rufe Wetter-App für '{location}' auf...")
    
    try:
        # 1. Geocoding via OpenStreetMap Nominatim API
        geo_query = urllib.parse.urlencode({"q": location, "format": "jsonv2", "limit": 1})
        geo_url = f"https://nominatim.openstreetmap.org/search?{geo_query}"
        
        req = urllib.request.Request(geo_url, headers={'User-Agent': 'WeatherAgent/1.0'})
        
        with urllib.request.urlopen(req, timeout=10) as response:
            geo_data = json.loads(response.read().decode())
            
        if not geo_data:
            return json.dumps({"error": f"Ort '{location}' konnte nicht gefunden werden."})
            
        lat = geo_data[0]["lat"]
        lon = geo_data[0]["lon"]
        display_name = geo_data[0]["display_name"].split(",")[0]
        
        # 2. Weather data via Open-Meteo Forecast API
        weather_query = urllib.parse.urlencode({
            "latitude": lat,
            "longitude": lon,
            "current": "temperature_2m,wind_speed_10m,weather_code",
        })
        weather_url = f"https://api.open-meteo.com/v1/forecast?{weather_query}"
        
        with urllib.request.urlopen(weather_url, timeout=10) as response:
            weather_data = json.loads(response.read().decode())
            
        current = weather_data.get("current", {})
        if not current:
            return json.dumps({"error": "Keine Wetterdaten für diese Koordinaten verfügbar."})
            
        wmo_codes = {
            0: "Klarer Himmel", 1: "Hauptsächlich klar", 2: "Teilweise bewölkt", 3: "Bedeckt",
            45: "Nebel", 48: "Raureifnebel", 51: "Leichter Nieselregen", 61: "Leichter Regen",
            63: "Mäßiger Regen", 65: "Starker Regen", 71: "Leichter Schneefall", 80: "Leichte Regenschauer"
        }
        weather_code = current.get("weather_code", 0)
        weather_text = wmo_codes.get(weather_code, f"Unbekannter Status (Code {weather_code})")
        
        return json.dumps({
            "ort": display_name,
            "wetter": weather_text,
            "temperatur": f"{current.get('temperature_2m')}°C",
            "windgeschwindigkeit": f"{current.get('wind_speed_10m')} km/h"
        }, ensure_ascii=False)
        
    except Exception as e:
        return json.dumps({"error": f"Fehler bei der API-Abfrage: {str(e)}"})


@tool
def calculate_invoice(amount: float, tax_rate: float) -> str:
    """Berechnet den Bruttobetrag einer Rechnung (Rechner-Applikation)."""
    print(f"-> [System] Rufe Rechner-App auf ({amount} € mit {tax_rate}% Steuer)...")
    try:
        total = float(amount) * (1 + float(tax_rate) / 100)
        return json.dumps({"brutto_betrag": round(total, 2)})
    except Exception:
        return json.dumps({"fehler": "Ungültiges Zahlenformat"})


tools_map = {
    "web_search": web_search,
    "check_weather": check_weather,
    "calculate_invoice": calculate_invoice
}

# ==========================================
# 2. Datei-Parser für Prompts & System-Anweisung
# ==========================================
def load_agent_config(filepath: str = "agents_steps.md"):
    system_prompt = "Du bist ein KI-Agent. Nutze deine Tools, um Fragen präzise zu beantworten."
    user_prompts = []
    config_path = filepath
    if not os.path.isabs(config_path):
        config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), config_path)
    
    if os.path.exists(config_path):
        with open(config_path, "r", encoding="utf-8") as f:
            content = f.read()
        system_match = re.search(r"## System Prompt\n(.*?)(?=\n##|$)", content, re.DOTALL)
        if system_match: 
            system_prompt = system_match.group(1).strip()
        user_section = re.search(
            r"^## User Prompts\s*$([\s\S]*?)(?=^##\s|\Z)",
            content,
            re.MULTILINE,
        )
        if user_section:
            user_prompts = [
                prompt.strip()
                for prompt in re.findall(r"^\s*-\s+(.+?)\s*$", user_section.group(1), re.MULTILINE)
                if prompt.strip()
            ]
    return system_prompt, user_prompts if user_prompts else ["Wie ist das Wetter in Berlin?"]

# ==========================================
# 3. Agenten-Logik (ReAct-Schleife)
# ==========================================
llm = ChatOllama(model="llama3.2", temperature=0).bind_tools(list(tools_map.values()))

def run_agent(user_prompt: str, system_instruction: str):
    print(f"\n╔═══════════════════════════════════════════════════════════════")
    print(f"║ 👤 NUTZER: {user_prompt}")
    print(f"╚═══════════════════════════════════════════════════════════════")
    
    tool_policy = (
        "Bei Fragen zu aktuellen Ereignissen, Nachrichten oder veränderlichen Fakten "
        "musst du zuerst web_search verwenden. Nutze die Suchergebnisse für die Antwort "
        "und nenne vorhandene Quell-URLs. Verwende andere Tools passend zur Frage."
    )
    messages = [
        SystemMessage(content=f"{system_instruction}\n\n{tool_policy}"),
        HumanMessage(content=user_prompt),
    ]
    ai_msg = llm.invoke(messages)
    messages.append(ai_msg)
    
    while ai_msg.tool_calls:
        for tool_call in ai_msg.tool_calls:
            tool_name = tool_call["name"]
            tool_args = tool_call["args"]
            tool_id = tool_call["id"]
            
            if tool_name in tools_map:
                tool_output = tools_map[tool_name].func(**tool_args)
                print(f"⚙️ [Tool Ausführung] {tool_name}({tool_args})")
                messages.append(ToolMessage(content=str(tool_output), tool_call_id=tool_id))
            else:
                messages.append(ToolMessage(content="Tool nicht gefunden.", tool_call_id=tool_id))
        
        ai_msg = llm.invoke(messages)
        messages.append(ai_msg)
        
    print(f"🤖 LLAMA AGENT: {ai_msg.content}\n")

# ==========================================
# 4. CLI Argument Parser & Hauptprogramm
# ==========================================
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="LC2-AGENTEN-STARTER: Llama3.2 + ReAct + Tools")
    parser.add_argument("-c", "--config", type=str, default="agents_steps.md", help="Pfad zur Markdown Konfigurationsdatei")
    parser.add_argument("-s", "--system", type=str, default=None, help="Überschreibt den System Prompt")
    parser.add_argument("-u", "--user", type=str, nargs="+", default=None, help="Überschreibt die User Prompts (Ein oder mehrere Sätze in Anführungszeichen)")
    
    args = parser.parse_args()

    print(f"LC2-AGENTEN-STARTER: Llama3.2 + ReAct + Tools")
    
    # Standard-Konfiguration laden
    system_instruction, prompts_to_run = load_agent_config(args.config)
    
    # CLI Overwrites anwenden falls vorhanden
    if args.system is not None:
        system_instruction = args.system
        print(f"ℹ️ System-Prompt über CLI überschrieben.")
        
    if args.user is not None:
        prompts_to_run = args.user
        print(f"ℹ️ User-Prompts über CLI überschrieben.")

    if not prompts_to_run:
        prompts_to_run = ["Wie ist das Wetter in Berlin?"]

    print(f"INFO: {len(prompts_to_run)} User-Prompt(s) werden ausgeführt.")
    for prompt in prompts_to_run:
        run_agent(prompt, system_instruction)