# Multinomial Logistic Regression in R: Transport Mode Choice Prediction

This project demonstrates how to build and interpret a **multinomial logistic regression (MNL)** model using R, focusing on the transport mode choice behavior of individuals. It simulates real-world decision-making processes among alternatives such as **car**, **bus**, and **bike**, considering travel time, cost, and personal income.


---

## 📌 Objectives

- Simulate a dataset representing transport choices.
- Convert data to `mlogit`-compatible format.
- Build a predictive multinomial logistic regression model.
- Interpret coefficients and make probabilistic predictions.

---

## Dataset Overview

| Variable      | Description                                     |
|---------------|-------------------------------------------------|
| person_id     | Unique identifier for individuals               |
| alt           | Transport alternative (`car`, `bus`, `bike`)    |
| choice        | Indicator (1 if chosen, 0 otherwise)            |
| travel_time   | Time to reach destination (in minutes)          |
| travel_cost   | Cost incurred for the trip (in EUR)             |
| income        | Monthly income of individual (in EUR)           |

 Simulated for **200 individuals** × **3 alternatives** = **600 rows**

---

##  Requirements

Ensure you have the following R packages installed:

```r
install.packages(c("mlogit", "tidyverse", "readr"))
