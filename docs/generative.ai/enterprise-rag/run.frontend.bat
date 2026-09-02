@echo off
REM copy .env.example .env
REM # add OPENAI_API_KEY at minimum
call pip install -r requirements.txt
REM call uvicorn api.main:app --port 8000 --reload   # terminal 1
REM call uvicorn api.main:app --port 8000 --reload
call python -m uvicorn api.main:app --reload --port 8000
call python -m streamlit run frontend/app.py