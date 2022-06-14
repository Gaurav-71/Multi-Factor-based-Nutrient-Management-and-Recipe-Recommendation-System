from flask import Flask, render_template, request, redirect, jsonify

from json import dumps
import numpy as np
import pandas as pd
import json
from datetime import datetime

import Scripts.RequiredNutrients
import Scripts.IngredientsPrediction
import Scripts.APIForFoodProducts
import Scripts.ParseAPIResponse
import Scripts.RankFoodProducts
import Scripts.YouTubeClient

MEN = pd.read_excel('./Datasets/men.xlsx')
WOMEN = pd.read_excel('./Datasets/women.xlsx')
data = pd.read_csv('./Datasets/ingredients-and-nutritional-values-corrected.csv')
ingredientNames = data['Common name']
data.drop(['Common name'], axis = 1, inplace = True)
api_key_file = open("./Scripts/APIKey.txt", "r")

app = Flask(__name__)

def actualData():
    start=datetime.now()
    print("started")
    nutritionalRequirements = Scripts.RequiredNutrients.getNutritionalRequirements(MEN, WOMEN)
    ingredients = list(Scripts.IngredientsPrediction.getIngredients(data,ingredientNames,nutritionalRequirements))
    while(len(ingredients) < 5):
        ingredients = list(Scripts.IngredientsPrediction.getIngredients(data,ingredientNames, nutritionalRequirements))
    ingredients = ",+".join(ingredients)
    foodProducts = Scripts.APIForFoodProducts.getSpoonacular(ingredients)
    foodList = Scripts.ParseAPIResponse.parseAPIResponse(json.loads(foodProducts))
    rankedFoodList = Scripts.RankFoodProducts.rankFoodProducts("./Scripts/chromedriver",foodList, nutritionalRequirements)
    apiResult = Scripts.YouTubeClient.getVideos(api_key_file,rankedFoodList)
    print("\n\n\n Executed in ",datetime.now()-start)
    return apiResult

def mockData():
    with open("./sampleResponse.json") as json_file:
        return json.dumps(json.load(json_file))
        

@app.route('/', methods=["GET"])
def home():
    return mockData()

# from flask import Flask

# app = Flask(__name__)

# @app.route('/', methods=["GET"])
# def hello_world():
#     return "Hello World"