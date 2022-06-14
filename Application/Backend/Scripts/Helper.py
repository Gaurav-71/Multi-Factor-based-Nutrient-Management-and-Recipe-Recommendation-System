import numpy as np
import pandas as pd


ingredientsAndNutritionalValues = pd.read_excel('../Datasets/ingredients-and-nutritional-values.xlsx')


def splitInput(name):
    split = name.split("-")[0].strip()
    return split

headers = ingredientsAndNutritionalValues.columns.values.tolist()
headers = headers[:1] + headers[2:]
corrected_df = pd.DataFrame(columns = headers)
ingredientsAndNutritionalValues['Common name'] = ingredientsAndNutritionalValues['Common name'].apply(splitInput)
unique = np.unique(ingredientsAndNutritionalValues.iloc[:,0:1])
for ingredient in unique:
    rows = ingredientsAndNutritionalValues.loc[ingredientsAndNutritionalValues['Common name'] == ingredient]
    mean = rows.mean()
    mean = list(np.around(np.array(mean),3))
    insertingRow = [ingredient] + mean 
    if(len(insertingRow) == 26):
        corrected_df.loc[len(corrected_df)] = insertingRow


corrected_df.to_csv('../Datasets/ingredients-and-nutritional-values-corrected.csv', index = False)





