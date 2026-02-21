from transformers import pipeline
from utils.logger import get_logger

logger = get_logger(__name__)
class ModelPredictor:
    def __init__(self):
        # self.model = pipeline('text-generation', model='gpt-2')
        self.model = pipeline('text-generation', model='openai-community/gpt2')
    def predict(self, input_text):
        logger.info(f"Predicting for input: {input_text}")
        return self.model(input_text, max_length=50)[0]['generated_text']
    
    def predict_ext(self, input_text,model):
        logger.info(f"Predicting for input: {input_text}")
        self.model = pipeline('text-generation', model=model)
        return self.model(input_text, max_length=50)[0]['generated_text']