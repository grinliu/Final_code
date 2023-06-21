import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.neural_network import MLPClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import accuracy_score, classification_report

# Read the data from the Excel file
file_name = "/Users/liujiahua/Library/CloudStorage/OneDrive-Personal/文档/edm_cluster1.xlsx"
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

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Scale input features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Create and train classifiers
ann_classifier = MLPClassifier(hidden_layer_sizes=(100,100), max_iter=1000)
ann_classifier.fit(X_train_scaled, y_train)

dt_classifier = DecisionTreeClassifier()
dt_classifier.fit(X_train, y_train)

nb_classifier = GaussianNB()
nb_classifier.fit(X_train, y_train)

# Predictions
y_pred_ann = ann_classifier.predict(X_test_scaled)
y_pred_dt = dt_classifier.predict(X_test)
y_pred_nb = nb_classifier.predict(X_test)

# Classification Reports
ann_report = classification_report(y_test, y_pred_ann)
dt_report = classification_report(y_test, y_pred_dt)
nb_report = classification_report(y_test, y_pred_nb)

print("ANN Classification Report:\n", ann_report)
print("DT Classification Report:\n", dt_report)
print("NB Classification Report:\n", nb_report)