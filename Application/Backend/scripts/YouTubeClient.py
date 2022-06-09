from googleapiclient.discovery import build
import os


api_key_file = open("./APIKey.txt", "r")
api_key = api_key_file.read()


youtube = build('youtube', 'v3', developerKey=api_key)
def getVideos(rankedFoodProducts):
    videoURLs = []
    for foodProduct in rankedFoodProducts:
        request = youtube.search().list(part = 'id, snippet', order = "viewCount", q = "Recipes for " + foodProduct["title"])
        response = request.execute()
        if(len(response["items"]) > 0):
            videoID = response["items"][0]["id"]["videoId"]
            videoURLs.append("https://www.youtube.com/watch?v=" + videoID)
    
    return videoURLs


