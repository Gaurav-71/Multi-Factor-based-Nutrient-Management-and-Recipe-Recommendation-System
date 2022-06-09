# %%
import numpy as np
import pandas as pd
from scipy.spatial.distance import cdist

# %%
MEN = pd.read_excel('../Datasets/men.xlsx')
WOMEN = pd.read_excel('../Datasets/women.xlsx')

# %%
#Returns nutritional requirements for a given user (Mock data for testing)
def getNutritionalRequirements(user = pd.Series(["19-24",23.98,2.995,0.38,8.675,24.69,250,1.3,1.5,0.017,0.94,0.185,10,2,50,1.545,120,0.075,12,27,0.105,0.0005,120,289,5.235,1.5]), gender = 'male'):
    def roundOff(n):
        n = round(n, ndigits = 4)
        return n
       
    def forceZero(n):
        if(n < 0):
            n = 0
        return n
    
    def invert(n):
        return -1*n

    if(gender == 'male'):
        data = MEN
    else:
        data = WOMEN
    
    distance = None
    for index, row in data.iterrows():
        if(row['AGE'] == user[0]):
            userNutritionalValues = user.values[1:]
            rowNutritionalValues = row.values[1:]
            distance = userNutritionalValues - rowNutritionalValues
            distance = list(map(invert, distance))
            distance = rowNutritionalValues + distance
#             distance = list(map(forceZero, distance))
            distance = list(map(roundOff, distance))
    return distance

# %%



