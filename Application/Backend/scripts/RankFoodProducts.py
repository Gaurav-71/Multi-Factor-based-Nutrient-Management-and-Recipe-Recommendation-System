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
def getSummary(driver):
    try:
        textBlock = ""
        summary = driver.find_elements_by_class_name('summary')
        for index, elem in enumerate(summary):
            textBlock = textBlock + elem.text.replace("<b>", "").replace('"', '')


        return textBlock
    except:
        return None

# %%
def getInstructions(driver):
    try:        
        instructions = ""
        instructionElement = driver.find_element_by_class_name('recipeInstructions')
        instructionElementChild = instructionElement.find_element_by_xpath('.//ol').find_elements_by_xpath('.//li')
        for index, elem in enumerate(instructionElementChild):
            instructions = instructions + elem.text

        return instructions
    except:
        return None

# %%
def getIngredientDetails(driver):
    try:
        ingredients = []
        ingredientList = driver.find_elements_by_class_name('spoonacular-ingredient')
        for index, elem in enumerate(ingredientList):
            ingredient = {}
            ingredient["name"] = elem.find_element_by_class_name("spoonacular-name").text
            ingredient["quantity"] = elem.find_element_by_class_name("spoonacular-metric").text
            ingredient["imageUrl"] = elem.find_element_by_class_name("spoonacular-image-wrapper").find_element_by_xpath(".//img").get_attribute("src")
            ingredients.append(ingredient)

        return ingredients
    except:
        return None

# %%
def getNutritionValues(nutrient, value):
    try:
        nutritionInfo = {}
        for i in range(0, len(nutrient)): 
            nutritionInfo[nutrient[i].text] = value[i].text

        return nutritionInfo
    except:
        return None

# %%
def rankFoodProducts(foodProducts, nutritionalRequirements):
    options = Options()
    options.headless = True
    options.add_argument("--window-size=1920,1200")
    nutrientList = {}
    distance = []
    driver = webdriver.Chrome(options=options, executable_path='./chromedriver')
    for i in range(0, len(foodProducts)):
        foodProduct = foodProducts[i]
        
        url = "https://spoonacular.com/recipes/" + str(foodProduct["title"].replace(" ", "-")) + "-" + str(foodProduct["id"])
        driver.get(url)
        

        nutrient = driver.find_elements_by_class_name('spoonacular-nutrient-name')
        value = driver.find_elements_by_class_name('spoonacular-nutrient-value')
        
        foodProduct["summary"] = getSummary(driver)
        foodProduct["instruction"] = getInstructions(driver)
        foodProduct["ingredients"] = getIngredientDetails(driver)
        foodProduct["nutrition"] = getNutritionValues(nutrient, value)
        

        nutrients = []
        values = []
        test = []
        for index,elem in enumerate(nutrient):
            nutrients.append(elem.text.lower().replace(' ', ''))
        for index,elem in enumerate(value):
            test.append(elem.text)
            text = "".join([ c if (c.isnumeric() or c == ".") else "" for c in elem.text ])
            values.append(text.lower())

        distance.append(calculateDistance(nutrients, values, nutritionalRequirements))
        
        foodProducts[i] = foodProduct
    driver.quit()    
    
    distance = np.array(distance)
    foodProducts = np.array(foodProducts)
    inds = distance.argsort()
    sortedFoodProducts = list(foodProducts[inds])
    
    return sortedFoodProducts


