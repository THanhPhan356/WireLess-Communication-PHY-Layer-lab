# Wireless Communication Lab

**What makes a wireless link reliable when the channel keeps changing?**

This project investigates how propagation, noise, and receiver design affect the performance of wireless communication systems. Starting with a single link, it will use mathematical models and simulation to study which physical-layer techniques help, under what conditions, and at what cost.

## Research questions

| Topic | Question | How to investigate it |
|---|---|---|
| Propagation and fading · Ch. 2–3 | How do distance, obstructions, and reflections change the signal at the receiver? | Compare free-space and two-ray propagation, then model how shadowing and fading cause the received power to vary. |
| Channel capacity · Ch. 4 | How much data can a link carry reliably under a given power and bandwidth budget? | Compare theoretical rate limits in AWGN and fading channels under stated assumptions about channel knowledge. |
| Modulation and detection · Ch. 5–6 | How much energy per bit does a receiver need to reach a target error rate? | Use BPSK over AWGN as a baseline. Compare simulated bit error rates with theory before changing the modulation or channel. |
| Diversity, coding, and adaptation · Ch. 7–9 | How can a link stay reliable as channel quality changes? | Compare the gains from combining signals, adding coding redundancy, and adapting the transmission rate. |
| MIMO, equalization, and OFDM · Ch. 10–12 | How can a link handle multipath and make use of multiple antennas? | Measure how equalization and OFDM handle delayed copies of the signal, then compare MIMO techniques for reliability and throughput. |

Each experiment will state the question and assumptions, describe the proposed approach, and test it against an analytical result or baseline. The write-up will explain what the results support and what remains unresolved.

## Materials

- **Available:** Chapter 1 — Overview of Wireless Communications ([PDF](slides/chapter-01-overview.pdf) · [PowerPoint](slides/chapter-01-overview.pptx))
- **Planned first experiment:** Free-space path loss (§2.3). Test how doubling the distance changes received power and use the result as a baseline for more realistic propagation models.

**Reference:** Andrea J. Goldsmith, *Wireless Communications*, Second Edition.
