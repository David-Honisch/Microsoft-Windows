import argparse
from flask import Flask, request, jsonify, render_template
from models.model_predictor import ModelPredictor
from utils.logger import get_logger
import os
from os import listdir
def compile_javascript():
    # Defining the path to the folder where the JS files are saved
    path = 'static/javascript'
    # Getting all the files from that folder
    files = [f for f in listdir(path) if isfile(join(path, f))]
    # Setting an iterator
    i = 0
    # Looping through the files in the first folder
    for file in files:
        # Building a file name
        file_name = "javascript/" + file
        # Creating a URL and saving it to a list
        all_js_files_1[i] = url_for('static', filename = file_name)
        # Updating list index before moving on to next file
        i +=1
    return(all_js_files)
app = Flask(__name__)
logger = get_logger(__name__)
model_predictor = ModelPredictor()

@app.route("/")
def index():
    logger.info(f"HOME")
    sites = ['twitter', 'facebook', 'instagram', 'whatsapp']
    return render_template("index.html", title="LC2AI Agent Home", index="index.html", home="home.html",sites=sites)

@app.route("/home.html")
def home():
    logger.info(f"HOME")
    sites = ['twitter', 'facebook', 'instagram', 'whatsapp']
    return render_template("index.html", title="LC2AI Agent Home", index="index.html", home="home.html",sites=sites)

@app.route("/fileindex" , methods = ['GET','POST'])
def fileindex():
    all_js_files = compile_javascript()
    return render_template('index.html', 
                        title = 'Home',
                        js_files = all_js_files)

@app.route("/predict", methods=["POST"])
def predict():
    data = request.json
    input_text = data.get("input", "")
    logger.info(f"Received input: {input_text}")
    prediction = model_predictor.predict(input_text)
    return jsonify({"prediction": prediction})

@app.route("/predict_ext", methods=["POST"])
def predict_ext():
    data = request.json
    input_text = data.get("input", "")
    logger.info(f"Received input: {input_text}")
    input_model = data.get("model", "")
    logger.info(f"Received model: {input_model}")
    prediction = model_predictor.predict_ext(input_text,input_model)
    return jsonify({"prediction": prediction})

if __name__ == "__main__":
    print("Starting LC2AI Agent - (c)by David Honisch")
    parser = argparse.ArgumentParser(
                    prog='app.py',
                    description='LC2AI Agent',
                    epilog='LC2AI Agent - (c)by David Honisch')
    parser.add_argument("port", help="port number", type=int)
    # parser = argparse.ArgumentParser("model")
    parser.add_argument("model", help="model type e.g. openai-community/gpt2", type=str)
    args = parser.parse_args()
    print(args.port)
    app.run(host="0.0.0.0", port=args.port)
