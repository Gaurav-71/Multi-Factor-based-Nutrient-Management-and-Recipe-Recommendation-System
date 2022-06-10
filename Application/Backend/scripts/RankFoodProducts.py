# %%
import pandas as pd
import numpy as np
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

# %%
def roundOff(n):
    n = float(n)
    n = round(n, ndigits = 4)
    return n

# %%
def getNutrientValue(term, position, nutrients, values, nutritionalRequirements):
    value = None
    try:
        ind = nutrients.index(term)
        value = values[ind]
    except ValueError:
        value = nutritionalRequirements[position]
    
    return value

# %%
def calculateDistance(nutrients, values, nutritionalRequirements):
    foodVector = []
    
    foodVector.append(getNutrientValue("protein", 0, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("ash", 1, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("fat", 2, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("fiber", 3, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("carbohydrates", 4, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("calories", 5, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("vitaminb1", 6, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("vitaminb2", 7, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("vitaminb3", 8, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("vitaminb5", 9, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("vitaminb6", 10, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("vitaminb7", 11, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("folate", 12, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("vitaminc", 13, nutrients, values, nutritionalRequirements))                      
    foodVector.append(getNutrientValue("aluminium", 14, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("calcium", 15, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("copper", 16, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("iron", 17, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("magnesium", 18, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("manganese", 19, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("nickel", 20, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("phosphorus", 21, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("potassium", 22, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("sodium", 23, nutrients, values, nutritionalRequirements))
    foodVector.append(getNutrientValue("zinc", 24, nutrients, values, nutritionalRequirements))
    
    foodVector = list(map(roundOff, foodVector))
    
    foodVector = np.array(foodVector)
    nutritionalRequirements = np.array(nutritionalRequirements)
    foodVector = np.divide(foodVector, nutritionalRequirements)
    nutritionalRequirements = np.divide(nutritionalRequirements, nutritionalRequirements)
    distance = np.linalg.norm(foodVector - nutritionalRequirements)
    
    return distance

# %%
def rankFoodProducts(foodProducts, nutritionalRequirements):
    options = Options()
    options.headless = True
    options.add_argument("--window-size=1920,1200")
    nutrientList = {}
    distance = []
    driver = webdriver.Chrome(options=options, executable_path='./chromedriver')
    for foodProduct in foodProducts:
        url = "https://spoonacular.com/recipes/" + str(foodProduct["title"].replace(" ", "-")) + "-" + str(foodProduct["id"])
        print(url)
        driver.get(url)
        nutrient = driver.find_elements_by_class_name('spoonacular-nutrient-name')
        value = driver.find_elements_by_class_name('spoonacular-nutrient-value')
        nutrients = []
        values = []
        test = []
        for index,elem in enumerate(nutrient):
            nutrients.append(elem.text.lower().replace(' ', ''))
        for index,elem in enumerate(value):
            test.append(elem.text)
            text = "".join([ c if (c.isnumeric() or c == ".") else "" for c in elem.text ])
            values.append(text.lower())
        # for  i in range(0,len(nutrient)):
        #     nutrientList[nutrient[i]] = value[i]

        # print(nutrientList)

        distance.append(calculateDistance(nutrients, values, nutritionalRequirements))
    
    driver.quit()    
    
    distance = np.array(distance)
    foodProducts = np.array(foodProducts)
    inds = distance.argsort()
    sortedFoodProducts = list(foodProducts[inds])
    
    return sortedFoodProducts


