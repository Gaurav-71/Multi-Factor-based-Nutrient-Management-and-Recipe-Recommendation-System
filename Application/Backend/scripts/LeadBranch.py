# %%
#Libraries
import numpy as np
import pandas as pd
import json

import RequiredNutrients
import IngredientsPrediction
import APIForFoodProducts
import ParseAPIResponse
import RankFoodProducts
import YouTubeClient

from datetime import datetime

def main():

    start=datetime.now()
    nutritionalRequirements = RequiredNutrients.getNutritionalRequirements()
    ingredients = list(IngredientsPrediction.getIngredients(nutritionalRequirements))
    while(len(ingredients) < 5):
        ingredients = list(IngredientsPrediction.getIngredients(nutritionalRequirements))
    ingredients = ",+".join(ingredients)
    foodProducts = APIForFoodProducts.getSpoonacular(ingredients)
    foodList = ParseAPIResponse.parseAPIResponse(json.loads(foodProducts))
    rankedFoodList = RankFoodProducts.rankFoodProducts(foodList, nutritionalRequirements)

    YouTubeClient.getVideos(rankedFoodList)

    print("\n\n\n Executed in ",datetime.now()-start)



