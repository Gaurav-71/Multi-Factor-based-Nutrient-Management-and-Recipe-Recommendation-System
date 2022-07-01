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

app = Flask(__name__)

def actualData():    
    start=datetime.now()
    print("1.started")
    MEN = pd.read_excel('./Datasets/men.xlsx')
    WOMEN = pd.read_excel('./Datasets/women.xlsx')
    data = pd.read_csv('./Datasets/ingredients-and-nutritional-values-corrected.csv')
    ingredientNames = data['Common name']
    data.drop(['Common name'], axis = 1, inplace = True)
    api_key_file = open("./Scripts/APIKey.txt", "r")
    nutritionalRequirements = Scripts.RequiredNutrients.getNutritionalRequirements(MEN, WOMEN)
    print("2.Completed nutritionalRequirements in : ", datetime.now() - start)
    ingredients = list(Scripts.IngredientsPrediction.getIngredients(data,ingredientNames,nutritionalRequirements))
    print("3.Completed ingredients in : ", datetime.now() - start)
    while(len(ingredients) < 5):
        ingredients = list(Scripts.IngredientsPrediction.getIngredients(data,ingredientNames, nutritionalRequirements))
    ingredients = ",+".join(ingredients)
    print("4.Completed ingredients join in : ", datetime.now() - start)
    foodProducts = Scripts.APIForFoodProducts.getSpoonacular(ingredients)
    print("5.Completed foodProducts in : ", datetime.now() - start)
    foodList = Scripts.ParseAPIResponse.parseAPIResponse(json.loads(foodProducts))
    print("6.Completed foodList in : ", datetime.now() - start)
    rankedFoodList = Scripts.RankFoodProducts.rankFoodProducts("./Scripts/chromedriver",foodList, nutritionalRequirements)
    print("7.Completed rankedFoodList in : ", datetime.now() - start)
    apiResult = Scripts.YouTubeClient.getVideos(api_key_file,rankedFoodList)
    print("8.Completed apiResult in : ", datetime.now() - start)
    print("\n\n\n Executed api call in ",datetime.now()-start)
    print(apiResult)
    return apiResult

def mockData():
    with open("./sampleResponse.json") as json_file:
        return json.dumps(json.load(json_file))
        

@app.route('/', methods=["GET"])
def home():
    return mockData()