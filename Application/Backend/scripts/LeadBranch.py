#Libraries
import numpy as np
import pandas as pd
import json


#Processor Files
# import import_ipynb
import RequiredNutrients
import IngredientsPrediction
import APIForFoodProducts
import ParseAPIResponse
import RankFoodProducts
import YouTubeClient


nutritionalRequirements = RequiredNutrients.getNutritionalRequirements()
ingredients = list(IngredientsPrediction.getIngredients(nutritionalRequirements))
while(len(ingredients) < 5):
    ingredients = list(IngredientsPrediction.getIngredients(nutritionalRequirements))
ingredients = ",+".join(ingredients)
foodProducts = APIForFoodProducts.getSpoonacular(ingredients)
foodList = ParseAPIResponse.parseAPIResponse(json.loads(foodProducts))
rankedFoodList = RankFoodProducts.rankFoodProducts(foodList, nutritionalRequirements)
print(rankedFoodList)


videoLinks = YouTubeClient.getVideos(rankedFoodList)

print(videoLinks)





