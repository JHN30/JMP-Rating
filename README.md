# 🏀 JMP Rating

**JMP Rating** is a custom basketball performance and prediction system designed to evaluate and forecast team and player strength in **Euroleague** competition. It combines statistical modeling, recency weighting, and advanced data transformations within a multi-layered SQL and MERN architecture to produce realistic, dynamic basketball ratings.

---

## Rating 2.1 — Unified Euroleague & EuroCup System

**Rating 2.1** now **includes EuroCup player data**, merging both competitions into a single analytical system.  
By integrating EuroCup performance into the core JEI (JMP Efficiency Index) calculations, team and player strength estimates now reflect the **true continental landscape** of European basketball.

Key improvements:
- 🧩 **Unified player dataset** covering both Euroleague and EuroCup players.
- 🧠 **Cross-competition weighting**, balancing JEI values between leagues for realistic integration.
- ⚖️ **Recency decay** applied to maintain fairness between active Euroleague and EuroCup players.
- 🏅 **Combined JEI metrics** now drive team ratings and predictions more accurately than ever.

---

## Rating 2.0 — Precision and Depth Overhaul

**Rating 2.0** was a major overhaul of the original JMP Rating system — a full redesign focused on **depth, accuracy, and context**.

It introduced:
- 📈 **JEI (JMP Efficiency Index)** — a player metric that aggregates five performance dimensions:  
  scoring, rebounding, playmaking, defense, and impact.
- 🧮 **Recency weighting** using an exponential decay model:  
  `EXP(-λ * Δyears)` ensuring that recent performances influence ratings more.
- ⚡ **Weighted team depth model**, applying `EXP(-β * (rank - 1))` to reduce star bias while valuing bench impact.
- 🎯 **Improved initial team ratings** that serve as more realistic baselines for predictive models.

**Result:** More stable, data-driven predictions that adapt to lineup changes, player form, and team composition.

---

## Rating 1.0 — The Foundation

**Rating 1.0** established the core concept behind JMP Rating.  
It used a **base team rating of 1000** and applied a **modified ELO system** to evolve ratings throughout the season.

Features:
- 🏠 **Home advantage multiplier**
- 🔥 **Form adjustment** for recent matches
- 🔄 **Match-to-match ELO updates** using expected score probabilities

---

## 📚 Tech Stack & Architecture

- **Backend:** Node.js + Express  
- **Frontend:** React (MERN stack)  
- **Database:** SQL Server (ETL + analytics), MongoDB (frontend persistence)  

---

> ⚠️ *JMP Rating continues to evolve — future versions will refine JEI, and expand to domestic leagues*

---

