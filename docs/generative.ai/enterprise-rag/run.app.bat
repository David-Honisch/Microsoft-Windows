@echo off
REM copy .env.example .env
REM # add OPENAI_API_KEY at minimum
call pip install -r requirements.txt
call uvicorn api.main:app --port 8000 --reload   # terminal 1
call streamlit run frontend/app.py