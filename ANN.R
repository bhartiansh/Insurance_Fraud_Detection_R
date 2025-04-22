# Load required libraries
library(readxl)
library(caret)
library(dplyr)
library(nnet)
library(openxlsx)

# Load cleaned dataset
df <- read.xlsx("cleaned_insurance_claims.xlsx")

# Drop date columns (incompatible with modeling)
df <- df %>% select(-policy_bind_date, -incident_date)

# Ensure target variable is binary factor with two levels
df$fraud_reported <- factor(ifelse(df$fraud_reported == 1, "Y", "N"), levels = c("N", "Y"))

# Check class distribution
print(table(df$fraud_reported))

# Split into train and test
set.seed(123)
split <- createDataPartition(df$fraud_reported, p = 0.8, list = FALSE)
train_data <- df[split, ]
test_data <- df[-split, ]

# Define trainControl
control <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = twoClassSummary,
  savePredictions = "final"
)

# Hyperparameter grid
tune_grid <- expand.grid(
  size = c(3, 5, 7),
  decay = c(0.1, 0.01, 0.001)
)

# Train ANN
set.seed(123)
ann_model <- train(
  fraud_reported ~ .,
  data = train_data,
  method = "nnet",
  metric = "Accuracy",
  preProcess = c("center", "scale"),
  trControl = control,
  tuneGrid = tune_grid,
  trace = FALSE,
  maxit = 200
)

# Predict on test data
pred_class <- predict(ann_model, test_data)

# Evaluate
conf_mat <- confusionMatrix(pred_class, test_data$fraud_reported)
print(ann_model$bestTune)
print(conf_mat)
cat("✅ Test Accuracy:", round(conf_mat$overall["Accuracy"] * 100, 2), "%\n")