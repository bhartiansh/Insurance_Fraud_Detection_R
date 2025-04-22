library(readxl)
library(dplyr)
library(janitor)
library(openxlsx)
library(caret)

# Step 1: Load data
df <- read_excel("insurance_claims.xlsx")

# Step 2: Clean column names
df <- janitor::clean_names(df)

# Step 3: Replace problematic strings with NA in character columns
df <- df %>%
  mutate(across(where(is.character), ~ na_if(., "?"))) %>%
  mutate(across(where(is.character), ~ na_if(., "NULL"))) %>%
  mutate(across(where(is.character), ~ na_if(., "NaN"))) %>%
  mutate(across(where(is.character), ~ na_if(., "null")))

# Step 4: Drop rows with >5 missing values
df <- df[rowSums(is.na(df)) <= 5, ]

# Step 5: Remove irrelevant columns
irrelevant_cols <- c(
  "insured_zip", "insured_hobbies", "collision_type",
  "incident_city", "incident_location", "incident_hour_of_the_day",
  "number_of_vehicles_involved", "auto_model", "capital_gains"
)
df <- df %>% select(-any_of(irrelevant_cols))

# Step 6: Drop rows with NA in target column
df <- df %>% filter(!is.na(fraud_reported))

# Step 7: Ensure target column is clean and has both classes
df$fraud_reported <- tolower(df$fraud_reported)
df <- df %>% filter(fraud_reported %in% c("yes", "no"))  # Drop weird entries
df$fraud_reported <- factor(df$fraud_reported, levels = c("no", "yes"))

# Check distribution
print(table(df$fraud_reported))  # Should show both "no" and "yes"

# Step 8: Label encode the target (for XGBoost, if needed)
df$fraud_reported_numeric <- ifelse(df$fraud_reported == "yes", 1, 0)

# Step 9: Convert character predictors to factors (for xgboost to handle internally)
df <- df %>%
  mutate(across(where(is.character), as.factor))

# Step 10: Normalize numeric predictors
num_cols <- df %>% select(where(is.numeric)) %>% select(-fraud_reported_numeric) %>% names()
df[num_cols] <- scale(df[num_cols])

# Step 11: Final check
print(str(df$fraud_reported))
print(table(df$fraud_reported))

