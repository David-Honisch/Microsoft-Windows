import os
import json
import requests
from google import genai
from google.genai import types

class KeywordFilterAgent:
    def __init__(self, api_url: str, gemini_api_key: str):
        self.api_url = api_url
        # Initialisiert den modernen Gemini-Client
        self.client = genai.Client(api_key=gemini_api_key)

    def fetch_data(self, auth_token: str = None) -> str:
        """Lädt die Rohdaten von der angegebenen URL herunter."""
        headers = {
            "Content-Type": "application/json"
        }
        if auth_token:
            headers["Authorization"] = f"Bearer {auth_token}"
            
        try:
            # Hinweis: Da es sich um eine POST/GET API handelt, passen Sie die Methode ggf. an
            response = requests.get(self.api_url, headers=headers, timeout=10)
            response.raise_for_status()
            return response.text
        except requests.exceptions.RequestException as e:
            print(f"Fehler beim Datenabruf: {e}")
            return ""

    def filter_keywords(self, raw_text: str, context_instruction: str) -> dict:
        """Nutzt Gemini, um relevante Keywords aus dem Text zu filtern."""
        if not raw_text.strip():
            return {"error": "Keine Daten zum Verarbeiten vorhanden."}

        prompt = f"""
        Du bist ein spezialisierter Keyword-Extraktions-Agent. Analysiere den folgenden Text oder die JSON-Antwort.
        Extrahiere die wichtigsten Keywords basierend auf dieser Anweisung: "{context_instruction}".
        
        Gib das Ergebnis ausnahmslos als valides JSON-Format mit folgenden Schlüsseln zurück:
        - "main_keywords": Liste der wichtigsten Kernbegriffe
        - "categories": Kategorien, denen diese Keywords zugeordnet werden können
        - "summary": Eine einteilige Zusammenfassung des Inhalts
        
        Rohdaten:
        {raw_text}
        """

        try:
            # Nutzung des aktuellen gemini-2.5-flash Modells für schnelle Textanalysen
            response = self.client.models.generate_content(
                model='gemini-2.5-flash',
                contents=prompt,
                config=types.GenerateContentConfig(
                    response_mime_type="application/json"
                ),
            )
            return json.loads(response.text)
        except Exception as e:
            print(f"Fehler bei der KI-Verarbeitung: {e}")
            return {"error": "KI-Filterung fehlgeschlagen."}

# --- ANWENDUNGSBEISPIEL ---
if __name__ == "__main__":
    # Konfiguration
    TARGET_URL = "https://bard.googleapis.com/v1/bard"
    GEMINI_KEY = os.environ.get("GEMINI_API_KEY", "IHR_GEMINI_API_KEY")
    BEARER_TOKEN = "IHR_GOOGLE_API_BEARER_TOKEN" # Falls für die URL erforderlich
    
    # Agent initialisieren
    agent = KeywordFilterAgent(api_url=TARGET_URL, gemini_api_key=GEMINI_KEY)
    
    print("1. Rufe Daten von API ab...")
    raw_data = agent.fetch_data(auth_token=BEARER_TOKEN)
    
    # Falls die API noch nicht erreichbar ist, nutzen wir hier Beispieldaten zur Demonstration
    if not raw_data:
        print("Nutze Demo-Daten für die Filterung...")
        raw_data = "{'text': 'Künstliche Intelligenz und Large Language Models revolutionieren die Softwareentwicklung im Jahr 2026. Automatisierung steht im Fokus.'}"

    print("2. Filtere Keywords mithilfe der KI...")
    instruction = "Fokus auf Technologien, Trends und Jahreszahlen."
    filtered_results = agent.filter_keywords(raw_text=raw_data, context_instruction=instruction)
    
    print("\n--- Gefilterte Agenten-Ergebnisse ---")
    print(json.dumps(filtered_results, indent=2, ensure_ascii=False))