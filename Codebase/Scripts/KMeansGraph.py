from tkinter import N
import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
from scipy.spatial.distance import cdist
from scipy.optimize import linear_sum_assignment
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn import metrics
from sklearn.decomposition import PCA

data = pd.read_csv('../Datasets/ingredients-and-nutritional-values-corrected.csv')
ingredientNames = data['Common name']
data.drop(['Common name'], axis = 1, inplace = True)

userNutrientInformation = [17.580000000000002, 0.00, 0.00, 8.615, 24.73, 332.0, 1.7, 1.9, 0.020999999999999998, 0.54, 0.18, 10.0, 2.0, 70.0, 3.3150000000000004, 120.0, 0.235, 8.0, 43.0, 0.125, 0.0085, 120.0, 119.0, 7.075, 1.1]

def getEvenClusters(X, cluster_size):
    n_clusters = int(np.ceil(len(X)/cluster_size))
    kmeans = KMeans(n_clusters, random_state = 0)
    kmeans.fit(X)
    centers = kmeans.cluster_centers_
    centers = centers.reshape(-1, 1, X.shape[-1]).repeat(cluster_size, 1).reshape(-1, X.shape[-1])
    distance_matrix = cdist(X, centers)
    clusters = linear_sum_assignment(distance_matrix)[1]//cluster_size
    return clusters, centers


def scaleInputs(data):
    scaler = StandardScaler()
    data = pd.DataFrame(scaler.fit_transform(data))
    return data

if(userNutrientInformation != None):
    data.loc[len(data)] = userNutrientInformation

data = scaleInputs(data)

pca_2 = PCA(n_components=2)
pca_2_result = pca_2.fit_transform(data)

clusterMap = pd.DataFrame()
clusterMap['data_index'] = data.index.values
clusterMap['cluster'], centers = getEvenClusters(data, 10)

def visualizing_results(pca_result, label, centroids_pca):
    """ Visualizing the clusters
    :param pca_result: PCA applied data
    :param label: K Means labels
    :param centroids_pca: PCA format K Means centroids
    """
    # ------------------ Using Matplotlib for plotting-----------------------
    x = pca_result[:, 0]
    y = pca_result[:, 1]

    plt.scatter(x, y, c=label, alpha=0.5, s=200)  # plot different colors per cluster
    plt.title('Ingredients')
    plt.xlabel('PCA 1')
    plt.ylabel('PCA 2')


    plt.show()

# clusterNumber = clusterMap.iloc[len(clusterMap) - 1]['cluster']
# ingredientRows = clusterMap[clusterMap['cluster'] == clusterNumber]['data_index']
# ingredientRows = ingredientRows[:len(ingredientRows) - 1]
# ingredients = ingredientNames.iloc[list(ingredientRows.values)]

visualizing_results(pca_2_result, clusterMap['cluster'], centers)