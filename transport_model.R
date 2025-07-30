install.packages("rsconnect")
library(rsconnect)

rsconnect::setAccountInfo(name='your_account_name',
                          token='your_token',
                          secret='your_secret')

library(tidyverse)
library(mlogit)

# ---------------------------
# 2. Load dataset
# ---------------------------
df <- read_csv("transport_data.csv")

# Preview dataset
glimpse(df)

# ---------------------------
# 3. Convert to mlogit format
# ---------------------------
# The dataset is in wide format, so we convert it
mlogit_df <- mlogit.data(df,
                         choice = "choice",
                         shape = "wide",
                         varying = 3:8,     # car_time to bike_cost
                         sep = "_",
                         id.var = "person_id")

# ---------------------------
# 4. Fit the Multinomial Logit Model
# ---------------------------
# Independent variables:
#   - time and cost (alternative-specific)
#   - income (individual-specific)
model <- mlogit(choice ~ time + cost | income, data = mlogit_df)

# ---------------------------
# 5. Model summary
# ---------------------------
summary(model)

# ---------------------------
# 6. Predict choice probabilities
# ---------------------------
predicted_probs <- fitted(model, type = "probabilities")
head(predicted_probs)

# Add most likely predicted choice
predicted_choice <- apply(predicted_probs, 1, function(row) names(row)[which.max(row)])
actual_choice <- df$choice

# ---------------------------
# 7. Evaluate Model Accuracy
# ---------------------------
results <- tibble(
  actual = actual_choice,
  predicted = predicted_choice
)

conf_mat <- table(results$actual, results$predicted)
print("Confusion Matrix:")
print(conf_mat)

accuracy <- mean(results$actual == results$predicted)
cat("\nModel Accuracy:", round(accuracy * 100, 2), "%\n")

# ---------------------------
# 8. Plot predicted probabilities (optional)
# ---------------------------
# Mean predicted probabilities across modes
mean_probs <- colMeans(predicted_probs)
mean_probs_df <- enframe(mean_probs, name = "mode", value = "mean_probability")

ggplot(mean_probs_df, aes(x = mode, y = mean_probability, fill = mode)) +
  geom_col(width = 0.6) +
  labs(title = "Average Predicted Probabilities by Mode",
       x = "Transport Mode",
       y = "Mean Probability") +
  theme_minimal()
