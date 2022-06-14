import requests

def getZest(ingredients):
    url = "https://zestful.p.rapidapi.com/parseIngredients"

    payload = {"ingredients": ingredients}
    headers = {
        "content-type": "application/json",
        "X-RapidAPI-Host": "zestful.p.rapidapi.com",
        "X-RapidAPI-Key": "c68b375d1bmsh82341a2bac8438dp1411ffjsncab9ef4d6d9e"
    }

    response = requests.request("POST", url, json=payload, headers=headers)

    return(response.text)

def getEdamam(ingredients):
    url = "https://edamam-recipe-search.p.rapidapi.com/search"

    querystring = {"q": ingredients}

    headers = {
        "X-RapidAPI-Host": "edamam-recipe-search.p.rapidapi.com",
        "X-RapidAPI-Key": "c68b375d1bmsh82341a2bac8438dp1411ffjsncab9ef4d6d9e"
    }

    response = requests.request("GET", url, headers=headers, params=querystring)

    print(response.text)


def getSpoonacular(ingredients):
    url = "https://api.spoonacular.com/recipes/findByIngredients"
    
    querystring = { "apiKey": "cc56bcef6fe84e268a50962283d64349", "ingredients": ingredients, "number": "10"}

    headers = {
        "content-type": "application/json",
    }

    response = requests.request("GET", url, headers=headers, params=querystring)

    return(response.text)


