# %%
import numpy as np
import pandas as pd

# %%
def parseAPIResponse(response):
    foodProducts = []
    for food in response:
        obj = {}
        ingredientList = []
        obj["id"] = food["id"]
        obj["title"] = food["title"]
        obj["imageUrl"] = food["image"]
        for missedIngredients in food["missedIngredients"]:
            name = missedIngredients["name"]
            ingredientList.append(name)
        for usedIngredients in food["usedIngredients"]:
            name = usedIngredients["name"]
            ingredientList.append(name)
        ingredientList = ", ".join(ingredientList)
        obj["ingedients"] = ingredientList
        
        foodProducts.append(obj)
    
    return foodProducts

# %%
def parseAPIResponseForNutrient(response):
    foodProducts = []
    for food in response:
        obj = {}
        ingredientList = []
        obj["id"] = food["id"]
        obj["title"] = food["title"]
        obj["imageUrl"] = food["image"]
        foodProducts.append(obj)

    return foodProducts


