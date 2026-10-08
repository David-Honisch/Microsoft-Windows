import os
import yaml
import sumy
from sumy.parsers.plaintext import PlaintextParser
from sumy.nlp.tokenizers import Tokenizer
from sumy.summarizers.lsa import LsaSummarizer
from googletrans import Translator
import ollama

# Initialize Ollama LLM
ollama_client = ollama.Client()

def read_files_recursively(directory):
    """Recursively read all files in a directory and return their content."""
    files_content = {}
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    files_content[file_path] = content
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
    return files_content

def summarize_text(text, language='en'):
    """Summarize the given text using Sumy."""
    parser = PlaintextParser.from_string(text, Tokenizer(language))
    summarizer = LsaSummarizer()
    summary = ''.join(str(sentence) for sentence in summarizer(parser.document, 3))
    return summary

def translate_to_german(text):
    """Translate text to German using Google Translate."""
    translator = Translator()
    translation = translator.translate(text, src='en', dest='de')
    return translation.text

def generate_summary_and_translation(file_path, output_dir="summaries"):
    """Generate summary and translation for a file."""
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Summarize
    summary = summarize_text(content)

    # Translate to German
    german_summary = translate_to_german(summary)

    # Save summary and translation
    summary_file = os.path.join(output_dir, f"{os.path.basename(file_path)}_summary.txt")
    with open(summary_file, 'w', encoding='utf-8') as f:
        f.write(f"Summary:\n{summary}\n\nGerman Summary:\n{german_summary}")

    print(f"Processed: {file_path}")
    print(f"Saved summary to: {summary_file}")

def main(directory):
    """Main function to process all files in the directory."""
    print(f"Processing directory: {directory}")
    files = read_files_recursively(directory)

    for file_path, content in files.items():
        print(f"Processing file: {file_path}")
        generate_summary_and_translation(file_path)

if __name__ == "__main__":
    # Replace with your directory path
    input_directory = ".\\data"
    main(input_directory)
