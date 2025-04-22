# Assume df is already preprocessed from previous steps

# 1. Ensure target variable is factor
df$fraud_reported <- as.factor(df$fraud_reported)

# 2. Remove target and numeric variables temporarily for one-hot encoding
target <- "fraud_reported"
numeric_vars <- df %>% select(where(is.numeric)) %>% colnames()

# 3. One-Hot Encode categorical variables using caret’s dummyVars
cat_vars <- setdiff(colnames(df), c(numeric_vars, target))

dummies <- dummyVars(~ ., data = df[, cat_vars])
df_cat_encoded <- predict(dummies, newdata = df[, cat_vars]) %>% as.data.frame()

# 4. Combine encoded categorical + numeric + target
df_model <- bind_cols(df_cat_encoded, df[, numeric_vars], df[target])

# 5. Split dataset into Train/Test
set.seed(123)
train_index <- createDataPartition(df_model$fraud_reported, p = 0.8, list = FALSE)
train_data <- df_model[train_index, ]
test_data  <- df_model[-train_index, ]

# 6. Train Random Forest
train_data <- na.omit(train_data)
rf_model <- randomForest(fraud_reported ~ ., data = train_data, ntree = 200, importance = TRUE)

# 7. Evaluate
preds <- predict(rf_model, newdata = test_data)

conf_matrix <- confusionMatrix(preds, test_data$fraud_reported)

# 8. Output accuracy and feature importance
print(conf_matrix)

# Feature Importance Plot
varImpPlot(rf_model)

