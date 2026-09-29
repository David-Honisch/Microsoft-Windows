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
import tempfile
from datetime import datetime
from typing import Optional, Union
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
            results = [r for r in ddgs.text(query, max_results=10)]
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
    
# 

@tool
def calculate_invoice(amount: float, tax_rate: float) -> str:
    """Berechnet den Bruttobetrag einer Rechnung (Rechner-Applikation)."""
    print(f"-> [System] Rufe Rechner-App auf ({amount} € mit {tax_rate}% Steuer)...")
    try:
        total = float(amount) * (1 + float(tax_rate) / 100)
        return json.dumps({"brutto_betrag": round(total, 2)})
    except Exception:
        return json.dumps({"fehler": "Ungültiges Zahlenformat"})




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

##
@tool
def save_chat_log(
    user_prompt: Optional[str] = None,
    final_answer: Optional[str] = None,
    log: Optional[Union[dict, list]] = None,
) -> str:
    r"""Speichert das finale Ergebnis des Chatbots als Markdown-Datei im Ordner 'resources\data' ab."""
    print("💾 -> [System] Rufe Speicher-Tool auf...")
    try:
        if log is not None:
            if isinstance(log, dict):
                user_prompt = user_prompt or log.get("Frage") or log.get("user_prompt")
                final_answer = final_answer or log.get("Antwort des Agenten") or log.get("final_answer")
            elif len(log) >= 2:
                user_prompt = user_prompt or str(log[0])
                final_answer = final_answer or str(log[1])
        if user_prompt is None or final_answer is None:
            return json.dumps({"fehler": "Nutzer-Frage und finale Antwort sind erforderlich."}, ensure_ascii=False)

        target_dir = os.path.abspath(
            os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "data")
        )
        os.makedirs(target_dir, exist_ok=True)
        
        now = datetime.now()
        timestamp = now.strftime("%Y%m%d_%H%M%S_%f")
        content = f"# Chat Log - {now.strftime('%Y-%m-%d %H:%M:%S')}\n\n"
        content += f"## 👤 Nutzer-Frage\n{user_prompt}\n\n"
        content += f"## 🤖 Antwort des Agenten\n{final_answer}\n"

        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            prefix=f"{timestamp}-",
            suffix="-chat.md",
            dir=target_dir,
            delete=False,
        ) as log_file:
            log_file.write(content)
            filepath = log_file.name

        print("💾 -> [System] Gespeichert: " + filepath)
            
        return json.dumps({"erfolg": True, "datei": filepath}, ensure_ascii=False)
    except Exception as e:
        return json.dumps({"fehler": f"Datei konnte nicht gespeichert werden: {str(e)}"})

@tool
def save_chat_log2(user_prompt: str, final_answer: str) -> str:
    """Speichert das finale Ergebnis des Chatbots als Markdown-Datei im Ordner 'resources\\data' ab."""
    print("💾 -> [System] Rufe Speicher-Tool auf...")
    try:
        # Ordnerpfad generieren
        target_dir = os.path.join("resources", "data")
        os.makedirs(target_dir, exist_ok=True)
        
        # Zeitstempel für Dateinamen (sicher gegen ungültige Windows-Zeichen wie Doppelpunkte)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{timestamp}-chat.md"
        filepath = os.path.join(target_dir, filename)
        
        # Inhalt strukturieren
        content = f"# Chat Log - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
        content += f"## 👤 Nutzer-Frage\n{user_prompt}\n\n"
        content += f"## 🤖 Antwort des Agenten\n{final_answer}\n"
        print("💾 -> [System] Speichere:"+filepath)
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
            
        return json.dumps({"erfolg": True, "datei": filepath}, ensure_ascii=False)
    except Exception as e:
        return json.dumps({"fehler": f"Datei konnte nicht gespeichert werden: {str(e)}"})
# 
# tools_map
# 

tools_map = {
    "web_search": web_search,
    "check_weather": check_weather,
    "calculate_invoice": calculate_invoice,
}


def invoke_tool(tool_name: str, tool_args: object) -> str:
    """Invoke a registered tool and return a model-readable result or error."""
    selected_tool = tools_map.get(tool_name)
    if selected_tool is None:
        return json.dumps({"error": f"Tool '{tool_name}' was not found."}, ensure_ascii=False)

    if tool_args is None:
        normalized_args = {}
    elif isinstance(tool_args, str):
        try:
            normalized_args = json.loads(tool_args)
        except json.JSONDecodeError as exc:
            return json.dumps({"error": f"Invalid JSON tool arguments: {exc.msg}."}, ensure_ascii=False)
    else:
        normalized_args = tool_args

    if not isinstance(normalized_args, dict):
        return json.dumps({"error": "Tool arguments must be a JSON object."}, ensure_ascii=False)

    try:
        result = selected_tool.invoke(normalized_args)
    except Exception as exc:
        return json.dumps(
            {"error": f"Tool '{tool_name}' failed.", "type": type(exc).__name__, "detail": str(exc)},
            ensure_ascii=False,
        )

    return result if isinstance(result, str) else json.dumps(result, ensure_ascii=False, default=str)


def persist_final_response(user_prompt: str, final_answer: object) -> None:
    answer_text = (
        final_answer
        if isinstance(final_answer, str)
        else json.dumps(final_answer, ensure_ascii=False, default=str)
    )
    result = json.loads(
        save_chat_log.invoke({"user_prompt": user_prompt, "final_answer": answer_text})
    )
    if result.get("erfolg"):
        print(f"💾 [Gespräch gespeichert] {result['datei']}")
    else:
        print(f"❌ [Gespräch konnte nicht gespeichert werden] {result.get('fehler', 'Unbekannter Fehler')}")

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
        "und nenne vorhandene Quell-URLs. Verwende andere Tools passend zur Frage. "
        "Die Anwendung speichert jede finale Antwort zusammen mit der Nutzerfrage automatisch."
    )
    
    # Der unvollständige Teil wurde hier repariert:
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
            
            tool_output = invoke_tool(tool_name, tool_args)
            print(f"⚙️ [Tool Ausführung] {tool_name}({tool_args})")
            messages.append(ToolMessage(content=tool_output, tool_call_id=tool_id))
                
        ai_msg = llm.invoke(messages)
        messages.append(ai_msg)
        
    print(f"🤖 LLAMA AGENT: {ai_msg.content}\n")
    persist_final_response(user_prompt, ai_msg.content)
    
    
def run_agent2(user_prompt: str, system_instruction: str):
    print(f"\n╔═══════════════════════════════════════════════════════════════")
    print(f"║ 👤 NUTZER: {user_prompt}")
    print(f"╚═══════════════════════════════════════════════════════════════")
    
    tool_policy = (
        "Bei Fragen zu aktuellen Ereignissen, Nachrichten oder veränderlichen Fakten "
        "musst du zuerst web_search verwenden. Nutze die Suchergebnisse für die Antwort "
        "und nenne vorhandene Quell-URLs. Verwende andere Tools passend zur Frage. "
        "Die Anwendung speichert jede finale Antwort zusammen mit der Nutzerfrage automatisch."
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
                tool_output = tools_map[tool_name].invoke(tool_args)
                print(f"⚙️ [Tool Ausführung] {tool_name}({tool_args})")
                messages.append(ToolMessage(content=str(tool_output), tool_call_id=tool_id))
            else:
                messages.append(ToolMessage(content="Tool nicht gefunden.", tool_call_id=tool_id))
        
        ai_msg = llm.invoke(messages)
        messages.append(ai_msg)
        
    print(f"🤖 LLAMA AGENT: {ai_msg.content}\n")
    persist_final_response(user_prompt, ai_msg.content)

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