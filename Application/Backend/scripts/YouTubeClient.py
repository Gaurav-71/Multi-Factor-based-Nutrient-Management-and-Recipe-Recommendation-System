# %%
from googleapiclient.discovery import build
import os
import json

# %%
api_key_file = open("./APIKey.txt", "r")
api_key = api_key_file.read()

# %%
youtube = build('youtube', 'v3', developerKey=api_key)
def getVideos(rankedFoodProducts):
    for i in range(0, len(rankedFoodProducts)):
        foodProduct = rankedFoodProducts[i]
        request = youtube.search().list(part = 'id, snippet', order = "viewCount", q = "Recipes for " + foodProduct["title"])
        response = request.execute()
        if(len(response["items"]) > 0):
            videoID = response["items"][0]["id"]["videoId"]
            foodProduct["videoUrl"] = "https://www.youtube.com/watch?v=" + videoID
    
        rankedFoodProducts[i] = foodProduct
    json_resp = json.dumps(rankedFoodProducts)
    print(json_resp)
    return json_resp


