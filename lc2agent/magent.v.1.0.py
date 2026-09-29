import os
import json
import re
from langchain_ollama import ChatOllama
from langchain_core.tools import tool
from langchain_core.messages import HumanMessage, AIMessage, ToolMessage, SystemMessage

# ==========================================
# 1. Definition der Tools / Applikationen
# ==========================================
@tool
def check_weather(location: str) -> str:
    """Ruft die Wetter-Applikation für einen bestimmten Ort auf."""
    print(f"-> [System] Rufe Wetter-App für '{location}' auf...")
    if "berlin" in location.lower():
        return json.dumps({"wetter": "sonnig", "temperatur": "22°C", "regenrisiko": "10%"})
    else:
        return json.dumps({"wetter": "unbekannt", "temperatur": "15°C", "regenrisiko": "50%"})

@tool
def calculate_invoice(amount: float, tax_rate: float) -> str:
    """Berechnet den Bruttobetrag einer Rechnung (Rechner-Applikation)."""
    print(f"-> [System] Rufe Rechner-App auf ({amount} € mit {tax_rate}% Steuer)...")
    try:
        # Sichere Konvertierung, falls Llama Strings liefert
        amount_num = float(amount)
        tax_rate_num = float(tax_rate)
        total = amount_num * (1 + tax_rate_num / 100)
        return json.dumps({"brutto_betrag": round(total, 2)})
    except (ValueError, TypeError) as e:
        return json.dumps({"fehler": f"Ungültige Zahlenformate: {str(e)}"})

# Zuordnung für den dynamischen Aufruf
tools_map = {
    "check_weather": check_weather,
    "calculate_invoice": calculate_invoice
}

# ==========================================
# 2. Datei-Parser für Prompts & System-Anweisung
# ==========================================
def load_agent_config(filepath: str="agents_steps.md"):
    system_prompt = "Du bist ein KI-Agent mit Zugriff auf Tools."
    example_prompts = []
    
    if not os.path.exists(filepath):
        print(f"⚠️ Warnung: '{filepath}' nicht gefunden. Nutze Standardwerte.")
        return system_prompt, ["Wie ist das Wetter in Berlin?"]
        
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
        
    # Extrahiere System Prompt (Alles unter ## System Prompt bis zur nächsten Überschrift)
    system_match = re.search(r"## System Prompt\n(.*?)(?=\n##|$)", content, re.DOTALL)
    if system_match:
        system_prompt = system_match.group(1).strip()
        
    # Extrahiere Beispiel-Prompts (Zeilen, die mit '-' unter ## Example Prompts beginnen)
    example_section = re.search(r"## Example Prompts\n(.*)", content, re.DOTALL)
    if example_section:
        matches = re.findall(r"-\s*(.*)", example_section.group(1))
        example_prompts = [m.strip() for m in matches if m.strip()]
        
    return system_prompt, example_prompts

# ==========================================
# 3. Agenten-Logik (ReAct-Schleife)
# ==========================================
# Llama initialisieren und Tools binden
# llm = ChatOllama(model="llama3.1", temperature=0).bind_tools(list(tools_map.values()))
llm = ChatOllama(model="llama3.2", temperature=0).bind_tools(list(tools_map.values()))

def run_agent(user_prompt: str, system_instruction: str):
    print(f"\n╔═══════════════════════════════════════════════════════════════")
    print(f"║ 👤 NUTZER: {user_prompt}")
    print(f"╚═══════════════════════════════════════════════════════════════")
    
    # Verlauf startet mit der System-Instruktion aus der Markdown-Datei
    messages = [
        SystemMessage(content=system_instruction),
        HumanMessage(content=user_prompt)
    ]
    
    # Erster LLM-Aufruf
    ai_msg = llm.invoke(messages)
    messages.append(ai_msg)
    
    # Dynamische Tool-Ausführungsschleife
    while ai_msg.tool_calls:
        for tool_call in ai_msg.tool_calls:
            tool_name = tool_call["name"]
            tool_args = tool_call["args"]
            tool_id = tool_call["id"]
            
            if tool_name in tools_map:
                # Dynamischer Aufruf über die .func-Referenz mit kwargs-Entpackung (**tool_args)
                tool_output = tools_map[tool_name].func(**tool_args)
                print(f"⚙️ [Tool Ausführung] {tool_name}({tool_args}) -> {tool_output}")
                
                messages.append(ToolMessage(content=str(tool_output), tool_call_id=tool_id))
            else:
                messages.append(ToolMessage(content="Tool nicht gefunden.", tool_call_id=tool_id))
        
        # LLM erneut aufrufen, um Ergebnisse zu füttern
        ai_msg = llm.invoke(messages)
        messages.append(ai_msg)
        
    print(f"🤖 LLAMA AGENT: {ai_msg.content}\n")

# ==========================================
# 4. Hauptprogramm
# ==========================================
if __name__ == "__main__":
    # Prompts und Systemanweisung dynamisch laden
    system_instruction, prompts_to_run = load_agent_config("agents_steps.md")
    
    print(f"ℹ️ System Prompt geladen: '{system_instruction}'")
    print(f"ℹ️ {len(prompts_to_run)} Test-Prompts geladen.")
    
    # Alle Prompts aus der Datei nacheinander ausführen
    for prompt in prompts_to_run:
        run_agent(prompt, system_instruction)
# import json
# from langchain_ollama import ChatOllama
# from langchain_core.tools import tool
# from langchain_core.messages import HumanMessage, AIMessage, ToolMessage

# # 1. Definition der externen Applikationen / Tools
# @tool
# def check_weather(location: str) -> str:
#     """Ruft die Wetter-Applikation für einen bestimmten Ort auf."""
#     # Hier würde der echte API-Aufruf zu z.B. OpenWeatherMap stehen
#     print(f"-> [System] Rufe Wetter-App für '{location}' auf...")
#     if "berlin" in location.lower():
#         return json.dumps({"wetter": "sonnig", "temperatur": "22°C"})
#     else:
#         return json.dumps({"wetter": "unbekannt", "temperatur": "15°C"})

# @tool
# def calculate_invoice(amount: float, tax_rate: float) -> str:
#     """Berechnet den Bruttobetrag einer Rechnung (Rechner-Applikation)."""
#     print(f"-> [System] Rufe Rechner-App auf ({amount} € mit {tax_rate}% Steuer)...")
    
#     # KORREKTUR: Sicherstellen, dass die Werte Zahlen sind (falls Llama Strings liefert)
#     try:
#         amount_num = float(amount)
#         tax_rate_num = float(tax_rate)
        
#         total = amount_num * (1 + tax_rate_num / 100)
#         return json.dumps({"brutto_betrag": round(total, 2)})
#     except (ValueError, TypeError) as e:
#         return json.dumps({"fehler": f"Ungültige Zahlenformate übergeben: {str(e)}"})

# # 3. Initialisierung des Llama-Modells mit Tool-Unterstützung
# # Hinweis: Llama 3.1 (z.B. llama3.1:8b) unterstützt Function Calling nativ
# # Oder falls du Llama 3 (Standard) nutzt:
# # llm = ChatOllama(model="llama3", temperature=0).bind_tools([check_weather, calculate_invoice])
# # llm = ChatOllama(model="llama3.1", temperature=0).bind_tools([check_weather, calculate_invoice])
# # Falls du Llama 3.2 nutzt:
# llm = ChatOllama(model="llama3.2", temperature=0).bind_tools([check_weather, calculate_invoice])

# def run_agent(user_prompt: str):
#     print(f"\n👤 Nutzer: {user_prompt}")
    
#     # Verlauf der Konversation initialisieren
#     messages = [HumanMessage(content=user_prompt)]
    
#     # Erster Aufruf: Llama entscheidet, ob ein Tool gebraucht wird
#     ai_msg = llm.invoke(messages)
#     messages.append(ai_msg)
    
#     # Schleife, falls Llama ein oder mehrere Tools aufrufen möchte
#     while ai_msg.tool_calls:
#         for tool_call in ai_msg.tool_calls:
#             tool_name = tool_call["name"]
#             tool_args = tool_call["args"]
#             tool_id = tool_call["id"]
            
#             # Dynamischer Aufruf der Applikation
#             if tool_name in tools_map:
#                 tool_to_call = tools_map[tool_name]
                
#                 # KORREKTUR: Wir rufen die zugrundeliegende Funktion direkt mit den kwargs auf
#                 tool_output = tool_to_call.func(**tool_args)
                
#                 # Antwort zurück in den Chatverlauf einspeisen
#                 messages.append(ToolMessage(content=str(tool_output), tool_call_id=tool_id))
#             else:
#                 messages.append(ToolMessage(content="Tool nicht gefunden.", tool_call_id=tool_id))
        
#         # Llama die Tool-Ergebnisse zur finalen Verarbeitung übergeben
#         ai_msg = llm.invoke(messages)
#         messages.append(ai_msg)
        
#     print(f"🤖 Llama Agent: {ai_msg.content}")

# # --- Testläufe ---
# if __name__ == "__main__":
#     product_title = "LC2Llama Agent mit Tool-Unterstützung"
#     author = "David Honisch"
#     print(f"{product_title} (c) by {author}")
#     # Test 1: Wetter-Applikation triggern
#     run_agent("Wie ist das Wetter in Siegburg/NRW?")
    
#     # Test 2: Rechner-Applikation triggern
#     run_agent("Berechne den Gesamtbetrag für 150 Euro bei 19 Prozent Mehrwertsteuer.")
