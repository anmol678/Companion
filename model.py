import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
from pylab import rcParams
from sklearn import tree
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

def plot_correlation(data):
    rcParams['figure.figsize'] = 10, 10
    fig = plt.figure()
    sns.heatmap(data.corr(), annot=True, fmt=".1f")
    fig.savefig('correlation_coefficient.png')

df = pd.read_csv('heart.csv')

df.columns = ["age","sex","BP","cholestrol","heart disease"]

plot_correlation(df)

df_x = df[["age","sex","BP","cholestrol"]]
df_y = df[["heart disease"]]

X_train, X_test, y_train, y_test = train_test_split(df_x, df_y, test_size = 0.2, random_state = 0)

clf = tree.DecisionTreeClassifier(random_state = 0,max_depth = 8)

clf = clf.fit(X_train, y_train)

y_pred = clf.predict(X_test)

print(accuracy_score(y_test, y_pred))

import coremltools as cml

model = cml.converters.sklearn.convert(clf, ["age","sex","BP","cholestrol"], "heart disease")

model.short_description = "Predicts if patient should visit doctor to get check for heart disease"

model.output_description["heart disease"] = "likelihood of heart disease"

model.save('heart.mlmodel')
