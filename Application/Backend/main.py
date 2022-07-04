from crypt import methods
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

@app.route('/', methods=["GET"])
def home():
    return render_template('index.html')

@app.route('/mock-personalised-recipes', methods=["GET"])
def mockData():
    with open("./sampleResponse.json") as json_file:        
        return json.dumps(json.load(json_file))

@app.route('/personalised-recipes', methods=["GET"])
def personalisedRecipes():
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

@app.route('/all-ingredients', methods=["GET"])
def allIngredients():
    data = pd.read_csv('./Datasets/ingredients-and-nutritional-values-corrected.csv')
    ingredientNames = data['Common name']
    ingredientNamesAsList = ingredientNames.values.tolist()
    print(ingredientNamesAsList)
    print(type(ingredientNamesAsList))
    return str(ingredientNamesAsList)

@app.route('/veg-ingredients', methods=["GET"])
def vegIngredients():
    veg = [
    "Agathi leaves",
    "Allathi",
    "Almond",
    "Aluva",
    "Amaranth leaves",
    "Amaranth seed",
    "Amaranth spinosus",
    "Anchovy",
    "Apple",
    "Apricot",
    "Arecanut",
    "Asafoetida",
    "Ash gourd",
    "Avocado fruit",
    "Bael fruit",
    "Bajra",
    "Bamboo shoot",
    "Banana",
    "Barley",
    "Basella leaves",
    "Bathua leaves",
    "Bean scarlet",
    "Beet greens",
    "Beet root",
    "Bengal gram",
    "Betel leaves",
    "Bitter gourd",
    "Black berry",
    "Black gram",
    "Bottle gourd",
    "Brinjal",
    "Broad beans",
    "Brussels sprouts",
    "Button mushroom",
    "Cabbage",
    "Capsicum",
    "Cardamom",
    "Carrot",
    "Cashew nut",
    "Cauliflower",
    "Cauliflower leaves",
    "Celery stalk",
    "Cherries",
    "Chicken mushroom",
    "Chillies",
    "Cho",
    "Cloves",
    "Cluster beans",
    "Coconut",
    "Coconut Water",
    "Colocasia",
    "Colocasia leaves",
    "Coriander leaves",
    "Coriander seeds",
    "Corn",
    "Cucumber",
    "Cumin seeds",
    "Currants",
    "Curry leaves",
    "Custard apple",
    "Dates",
    "Drumstick",
    "Drumstick leaves",
    "Fenugreek leaves",
    "Fenugreek seeds",
    "Field bean",
    "Field beans",
    "Fig",
    "French beans",
    "Garden cress",
    "Garlic",
    "Gingelly seeds",
    "Ginger",
    "Gobro",
    "Gogu leaves",
    "Goosberry",
    "Grapes",
    "Green gram",
    "Ground nut",
    "Guava",
    "Horse gram",
    "Jack fruit",
    "Jaggery",
    "Jallal",
    "Jambu fruit",
    "Jowar",
    "Kadal bral",
    "Kadali",
    "Kalava",
    "Kanamayya",
    "Karnagawala",
    "Karonda fruit",
    "Kayrai",
    "Khoa",
    "Knol",
    "Korka",
    "Kovai",
    "Ladies finger",
    "Lemon",
    "Lentil dal",
    "Lentil whole",
    "Lettuce",
    "Lime",
    "Linseeds",
    "Litchi",
    "Lotus root",
    "Mace",
    "Maize",
    "Mango",
    "Mango ginger",
    "Mangosteen",
    "Manila tamarind",
    "Milk",
    "Mint leaves",
    "Mithun",
    "Moth bean",
    "Mud crab",
    "Mullet",
    "Musk melon",
    "Mustard leaves",
    "Mustard seeds",
    "Niger seeds",
    "Nutmeg",
    "Omum",
    "Onion",
    "Orange",
    "Oyster mushroom",
    "Paarai",
    "Padayappa",
    "Pak Choi leaves",
    "Palm fruit",
    "Pambada",
    "Pandukopa",
    "Paneer",
    "Pangas",
    "Papaya",
    "Parava",
    "Parcus",
    "Parsley",
    "Parwar",
    "Peach",
    "Pear",
    "Peas",
    "Pepper",
    "Phalsa",
    "Phopat",
    "Pine seed",
    "Pineapple",
    "Pippali",
    "Pistachio nuts",
    "Plantain",
    "Plum",
    "Pomegranate",
    "Ponnaganni",
    "Poppy seeds",
    "Potato",
    "Pummelo",
    "Pumpkin",
    "Pumpkin leaves",
    "Quinoa",
    "Radish",
    "Radish leaves",
    "Ragi",
    "Raisins",
    "Rajmah",
    "Rambutan",
    "Rani",
    "Red gram",
    "Rice",
    "Rice flakes",
    "Rice puffed",
    "Ricebean",
    "Ridge gourd",
    "Rumex leaves",
    "Sadaya",
    "Safflower seeds",
    "Samai",
    "Sangada",
    "Sankata paarai",
    "Sapota",
    "Shiitake mushroom",
    "Snake gourd",
    "Soursop",
    "Soybean",
    "Spinach",
    "Star fruit",
    "Strawberry",
    "Sugarcane",
    "Sunflower seeds",
    "Sweet potato",
    "Tamarind",
    "Tamarind leaves",
    "Tapioca",
    "Tarlava",
    "Tholam",
    "Tinda",
    "Tomato",
    "Turmeric powder",
    "Varagu",
    "Vora",
    "Walnut",
    "Water Chestnut",
    "Water melon",
    "Wheat",
    "Wheat flour",
    "Wood Apple",
    "Yam",
    "Zizyphus",
    "Zucchini",
    ];
    return str(veg)

@app.route('/non-veg-ingredients', methods=["GET"])
def nonVegIngredients():
    nonveg = [
    "Ari fish",
    "Beef",
    "Betki",
    "Xiphinis",
    "Whale shark",
    "Vela meen",
    "Vanjaram",
    "Tuna",
    "Turkey",
    "Tiger prawns",
    "Tilapia",
    "Stingray",
    "Squid",
    "Sole fish",
    "Silk fish",
    "Silver carp",
    "Silan",
    "Shelavu",
    "Sardine",
    "Shark",
    "Sheep",
    "Salmon",
    "Rohu",
    "Red snapper",
    "Ray fish",
    "Rabbit",
    "Raai fish",
    "Raai vanthu",
    "Quail",
    "Queen fish",
    "Poultry, chicken",
    "Pranel",
    "Prawns",
    "Pulli paarai",
    "Pork",
    "Pomfret",
    "Piranha",
    "Perinkilichai",
    "Parrot fish",
    "Pali kora",
    "Oyster",
    "Octopus",
    "Myil meen",
    "Nalla bontha",
    "Narba",
    "Mural",
    "Moon fish",
    "Milk fish",
    "Matha",
    "Manda clathi",
    "Mackerel",
    "Maagaa",
    "Lobster",
    "Kulam paarai",
    "Kite fish",
    "Kiriyan",
    "Kannadi paarai",
    "Karimeen",
    "Kalamaara",
    "Jathi vela meen",
    "Hare",
    "Hilsa",
    "Guinea fowl",
    "Guitar fish",
    "Gold fish",
    "Goat",
    "Freshwater Eel",
    "Duck",
    "Egg, country hen",
    "Egg, duck",
    "Egg, poultry",
    "Egg, quial",
    "Eggs",
    "Emu",
    "Eri meen",
    "Country hen",
    "Crab",
    "Clam",
    "Chicken, poultry",
    "Chakla",
    "Chelu",
    "Chembali",
    "Cat fish",
    "Catla",
    "Calf",
    "Bommuralu",
    "Black snapper",
    "Bombay duck",
    ];
    return str(nonveg)

