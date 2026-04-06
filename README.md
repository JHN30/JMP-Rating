# JMP Rating

**JMP Rating** is a custom basketball performance and prediction system designed to evaluate and forecast team and player strength in **Euroleague** competition. It combines statistical modeling, recency weighting, and advanced data transformations within a multi-layered SQL and MERN architecture to produce realistic, dynamic basketball ratings.

---

## Rating 2.2

JMP Rating 2.2 currently delivers roughly a **15%** improvement over the previous version of the model. The improvement comes mainly from using better inputs and rebalancing core constants.

The biggest upgrade in JMP Rating 2.2 is the quality of the data being used. Instead of depending too heavily on short-term form, the model now works with a broader and more stable set of signals, including:

- round-by-round points scored
- round-by-round points allowed
- pre-round average scoring margin
- actual game margin for rating updates

Another improvement was rebalancing the home advantage constant to have more weight. At the same time, the old form logic was deleted. While recent form can still be useful, throughout my testing it consistently gave the model worse results.

### NOTE

At the moment of writing this, I have not yet uploaded the main Python script that I used for calculating ratings and testing the model's accuracy. However, a very similar version of the prediction logic used in the main project is already available here:

- [frontend/src/utils/calculateExpectedScore.js](https://github.com/JHN30/JMP-Euroleague/blob/main/frontend/src/utils/calculateExpectedScore.js)

This file reflects the same general direction and logic used in Rating 2.2 for predicting upcoming games.

---

## Rating 2.1

**Rating 2.1** now **includes EuroCup player data**, merging both competitions into a single analytical system.  
By integrating EuroCup performance into the core JEI (JMP Efficiency Index) calculations, team and player strength estimates now reflect the **true continental landscape** of European basketball.

Key improvements:
-  **Unified player dataset** covering both Euroleague and EuroCup players.
-  **Cross-competition weighting**, balancing JEI values between leagues for realistic integration.
-  **Recency decay** applied to maintain fairness between active Euroleague and EuroCup players.
-  **Combined JEI metrics** now drive team ratings and predictions more accurately than ever.

---

## Rating 2.0

**Rating 2.0** was a major overhaul of the original JMP Rating system — a full redesign focused on **depth, accuracy, and context**.

It introduced:
-  **JEI (JMP Efficiency Index)** — a player metric that aggregates five performance dimensions:  
  scoring, rebounding, playmaking, defense, and impact.
-  **Recency weighting** using an exponential decay model:  
  `EXP(-λ * Δyears)` ensuring that recent performances influence ratings more.
-  **Weighted team depth model**, applying `EXP(-β * (rank - 1))` to reduce star bias while valuing bench impact.
-  **Improved initial team ratings** that serve as more realistic baselines for predictive models.

**Result:** More stable, data-driven predictions that adapt to lineup changes, player form, and team composition.

---

## Rating 1.0

**Rating 1.0** established the core concept behind JMP Rating.  
It used a **base team rating of 1000** and applied a **modified ELO system** to evolve ratings throughout the season.

Features:
-  **Home advantage multiplier**
-  **Form adjustment** for recent matches
-  **Match-to-match ELO updates** using expected score probabilities

---

##  Tech Stack & Architecture
  
-  **SQL Server**
-  **MongoDB**
-  **Python**  

---

>  *JMP Rating continues to evolve — future versions will refine JEI, and expand to domestic leagues*

---

