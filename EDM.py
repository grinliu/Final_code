import pandas as pd
from sklearn.model_selection import cross_validate, StratifiedKFold
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.neural_network import MLPClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.naive_bayes import GaussianNB

# Read the data from the Excel file
file_name = "edm_cluster1.xlsx"
sheet_name = "Sheet1"
df = pd.read_excel(file_name, sheet_name=sheet_name)

# Encode categorical features
le = LabelEncoder()
for col in df.columns:
    if df[col].dtype == 'object':
        df[col] = le.fit_transform(df[col])

# Select features and target
X = df.drop(['Class'], axis=1).values
y = df['Class'].values

# Scale input features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Create classifiers
ann_classifier = MLPClassifier(hidden_layer_sizes=(100,100), max_iter=1000)
dt_classifier = DecisionTreeClassifier()
nb_classifier = GaussianNB()

# Initialize 10-fold cross-validation
cv = StratifiedKFold(n_splits=10)

# Cross-validate metrics
def cross_val_metrics(model, X, y, cv, scoring_metrics, n_jobs=-1):
    scores = cross_validate(model, X, y, cv=cv, scoring=scoring_metrics, n_jobs=n_jobs)
    return {metric: scores[f"test_{metric}"].mean() for metric in scoring_metrics}

scoring_metrics = ['accuracy', 'precision_macro', 'recall_macro', 'f1_macro']

# Calculate cross-validated metrics for each classifier
ann_eval_metrics = cross_val_metrics(ann_classifier, X_scaled, y, cv, scoring_metrics)
dt_eval_metrics = cross_val_metrics(dt_classifier, X, y, cv, scoring_metrics)
nb_eval_metrics = cross_val_metrics(nb_classifier, X, y, cv, scoring_metrics)

print("ANN evaluation metrics with 10-Fold CV:")
for metric, mean_value in ann_eval_metrics.items():
    print(f"{metric}: {mean_value}")
print()

print("DT evaluation metrics with 10-Fold CV:")
for metric, mean_value in dt_eval_metrics.items():
    print(f"{metric}: {mean_value}")
print()

print("NB evaluation metrics with 10-Fold CV:")
for metric, mean_value in nb_eval_metrics.items():
    print(f"{metric}: {mean_value}")
print()