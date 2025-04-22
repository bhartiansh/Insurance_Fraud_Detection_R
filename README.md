# Insurance Fraud Detection using Machine Learning in R

This project focuses on detecting fraudulent insurance claims using structured data. Three machine learning models were developed and evaluated: Artificial Neural Network (ANN), Random Forest, and Logistic Regression.

---

## 📁 Project Structure

- `insurance_claims.xlsx`: Original dataset
- `fraud_detection.R`: Main R script containing preprocessing, modeling, and evaluation
- `README.md`: Project documentation
- `requirements.txt`: List of R packages used

---

## 🔍 Problem Statement

The objective is to classify insurance claims as **fraudulent** (`yes`) or **non-fraudulent** (`no`) using customer and claim-related features.

---

## ✅ Steps Performed

1. **Data Preprocessing**
   - Cleaned nulls and inconsistencies
   - Converted categorical variables to factors
   - One-hot encoding for categorical features
   - Normalized numeric variables

2. **Modeling**
   - **Artificial Neural Network (ANN)** using `nnet`
   - **Random Forest** using `randomForest`
   - **Logistic Regression** using `glm`
   - Hyperparameter tuning and 5-fold cross-validation (`caret`)

3. **Evaluation Metrics**
   - Accuracy
   - Confusion Matrix
   - Sensitivity, Specificity
   - ROC and AUC

---

## 📊 Model Performance

| Model               | Accuracy |
|--------------------|----------|
| Random Forest       | **92%**  |
| Artificial Neural Network (ANN) | 85%      |
| Logistic Regression | 77%      |

> Random Forest provided the best accuracy and overall balanced performance.

---

## 📦 Libraries Used

- `caret`
- `nnet`
- `randomForest`
- `dplyr`
- `janitor`
- `readxl`
- `openxlsx`

---

## ▶️ How to Run

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/insurance-fraud-detection.git
   cd insurance-fraud-detection
