import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
from scipy.spatial.distance import cdist
from scipy.optimize import linear_sum_assignment
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn import metrics

#Elbow method


# distortions = []
# inertias = []
# mapping1 = {}
# mapping2 = {}
# K = range(1, 40)

# for k in K:
#     # Building and fitting the model
#     kmedoids = KMedoids(n_clusters=k, random_state=0).fit(data)
#     distortions.append(sum(np.min(cdist(data, kmedoids.cluster_centers_,
#                                         'euclidean'), axis=1)) / data.shape[0])
#     inertias.append(kmedoids.inertia_)
 
#     mapping1[k] = sum(np.min(cdist(data, kmedoids.cluster_centers_,
#                                    'euclidean'), axis=1)) / data.shape[0]
#     mapping2[k] = kmedoids.inertia_


# plt.plot(K, distortions, 'bx-')
# plt.xlabel('Values of K')
# plt.ylabel('Distortion')
# plt.title('The Elbow Method using Distortion')
# plt.show()


def getIngredients(data,ingredientNames,userNutrientInformation = [17.580000000000002, 0.00, 0.00, 8.615, 24.73, 332.0, 1.7, 1.9, 0.020999999999999998, 0.54, 0.18, 10.0, 2.0, 70.0, 3.3150000000000004, 120.0, 0.235, 8.0, 43.0, 0.125, 0.0085, 120.0, 119.0, 7.075, 1.1]):    
    
    def getEvenClusters(X, cluster_size):
        n_clusters = int(np.ceil(len(X)/cluster_size))
        kmeans = KMeans(n_clusters, random_state = 0)
        kmeans.fit(X)
        centers = kmeans.cluster_centers_
        centers = centers.reshape(-1, 1, X.shape[-1]).repeat(cluster_size, 1).reshape(-1, X.shape[-1])
        distance_matrix = cdist(X, centers)
        clusters = linear_sum_assignment(distance_matrix)[1]//cluster_size
        return clusters


    def scaleInputs(data):
        scaler = StandardScaler()
        data = pd.DataFrame(scaler.fit_transform(data))
        return data
    
    if(userNutrientInformation != None):
        data.loc[len(data)] = userNutrientInformation

    data = scaleInputs(data)
    clusterMap = pd.DataFrame()
    clusterMap['data_index'] = data.index.values
    clusterMap['cluster'] = getEvenClusters(data, 10)
    
    clusterNumber = clusterMap.iloc[len(clusterMap) - 1]['cluster']
    ingredientRows = clusterMap[clusterMap['cluster'] == clusterNumber]['data_index']
    ingredientRows = ingredientRows[:len(ingredientRows) - 1]
    ingredients = ingredientNames.iloc[list(ingredientRows.values)]
    print(ingredients)
    
#     unique = np.unique(list(clusterMap['cluster']))
#     for cluster in unique:
#         subset = clusterMap[clusterMap['cluster'] == cluster]
#         print(len(subset))
        
    return ingredients.values








