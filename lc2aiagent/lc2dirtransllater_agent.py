import os
import zipfile
import rarfile
import patoolib
from sumy.parsers.plaintext import PlaintextParser
from sumy.nlp.tokenizers import Tokenizer
from sumy.summarizers.lsa import LsaSummarizer
from googletrans import Translator
import ollama

logo_text = """
.____     ______________________________________________________                
|    |    \_   _____/\__    ___/\____    /\__    ___/\_   _____/                
|    |     |    __)_   |    |     /     /   |    |    |    __)_                 
|    |___  |        \  |    |    /     /_   |    |    |        \                
|_______ \/_______  /  |____|   /_______ \  |____|   /_______  /                
        \/        \/                    \/                   \/                 
_________   ________   _____    _______  _________ ___________                 
\_   ___ \ /   |   \  /  _  \   \      \ \_   ___ \\_   _____/                 
/    \  \//    ~    \/  /_\  \  /   |   \/    \  \/ |    __)_                  
\     \___\    Y    /    |    \/    |    \     \____|        \                 
 \______  /\___|_  /\____|__  /\____|__  /\______  /_______  /                 
        \/       \/         \/         \/        \/        \/                  
    ________ __________  ________
    \_____  \\______   \/  _____/
     /   |   \|       _/   \  ___
    /    |    \    |   \    \_\  \
 /\ \_______  /____|_  /\______  /
 \/         \/       \/        \/
____________________ ________   ____ ___________    ___________________    
\______   \______   \\_____  \ |    |   \______ \   \__    ___/\_____  \   
 |     ___/|       _/ /   |   \|    |   /|    |  \    |    |    /   |   \  
 |    |    |    |   \/    |    \    |  / |    `   \   |    |   /    |    \ 
 |____|    |____|_  /\_______  /______/ /_______  /   |____|   \_______  / 
                  \/         \/                 \/                     \/  
_______________________________ ____________________ _______   __   
\______   \______   \_   _____//   _____/\_   _____/ \      \_/  |_ 
 |     ___/|       _/|    __)_ \_____  \  |    __)_  /   |   \   __\
 |    |    |    |   \|        \/        \ |        \/    |    \  |  
 |____|    |____|_  /_______  /_______  //_______  /\____|__  /__|  
                  \/        \/        \/         \/         \/
LETZECHANCE.ORG PROUD TO PRESENT:
"""

# Initialize Ollama LLM
ollama_client = ollama.Client()

def read_files_from_archive(archive_path, output_dir="extracted"):
    """Extract files from ZIP or RAR archive and return content."""
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    if archive_path.endswith('.zip'):
        with zipfile.ZipFile(archive_path, 'r') as zip_ref:
            zip_ref.extractall(output_dir)
    elif archive_path.endswith('.rar'):
        patoolib.extract_archive(archive_path, output_dir)
    else:
        print(f"Unsupported archive type: {archive_path}")
        return []

    # Return list of extracted files
    extracted_files = [os.path.join(output_dir, f) for f in os.listdir(output_dir) if os.path.isfile(os.path.join(output_dir, f))]
    return extracted_files

def read_files_recursively(directory):
    """Recursively read all files in a directory and return their content."""
    files_content = {}
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
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
    try:
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)

        with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
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
    except Exception as e:
        print(f"Error processing {file_path}: {e}")

def main(directory):
    """Main function to process all files in the directory, including archives."""
    print(f"Processing directory: {directory}")
    files = read_files_recursively(directory)

    # Process all files, including those inside ZIP and RAR archives
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if file_path.endswith(('.zip', '.rar')):
                print(f"Processing archive: {file_path}")
                extracted_files = read_files_from_archive(file_path)
                for extracted_file in extracted_files:
                    generate_summary_and_translation(extracted_file)
            else:
                generate_summary_and_translation(file_path)

# if __name__ == "__main__":
#     # Replace with your directory path
#     input_directory = "your_directory_path_here"
#     main(input_directory)


if __name__ == "__main__":
    print(logo_text)
    # Replace with your directory path
    input_directory = "K:\\Leaked_Data_of_corrupt_officials"
    main(input_directory)
