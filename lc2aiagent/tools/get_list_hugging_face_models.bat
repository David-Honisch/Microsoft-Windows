@echo off
call py list_hugging_face_models.py "automatic-speech-recognition" "openai" "transformers" 100>openai.csv
call py list_hugging_face_models.py "automatic-speech-recognition" "" "transformers" 100>more.csv