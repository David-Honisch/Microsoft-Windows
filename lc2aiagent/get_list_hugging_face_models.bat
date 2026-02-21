@echo off
call py tools\list_hugging_face_models.py "automatic-speech-recognition" "openai" "transformers" 100>openai.csv
call py tools\list_hugging_face_models.py "automatic-speech-recognition" "" "transformers" 100>more.csv