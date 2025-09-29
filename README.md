# 📡 Frequency‑Domain Sensing — DFT Exploration & FMCW Radar FFT on TI TMS320 (Project Showcase)

> A compact project that demonstrates **how the Discrete Fourier Transform (DFT) reveals frequency content** in time‑signals and how an **FFT on a TI TMS320‑class DSP** extracts target **range** from an FMCW radar’s **dechirped** signal.

---

## 🚗 Overview

This project is a **showcase** of two connected ideas:

1. **DFT & Resolution.** What the DFT is, how **bin spacing** works, and why **zero‑padding** refines the plotted spectrum without inventing content.  
2. **FMCW Radar on DSP.** How **dechirp → FFT** reveals the **beat frequency** and turns it into **range** on a TMS320‑class processor.

The aim is understanding — not replication — so the explanations emphasize *why* each piece behaves the way it does.

---

## 🔬 Part A — DFT, resolution, and zero‑padding

**DFT definition (what the FFT computes):**

$$
X[k] = \sum_{n=0}^{N-1} x[n]\,e^{-j2\pi kn/N},\qquad k=0,\dots,N-1.
$$

**Bin locations and spacing.** With sampling rate $F_s$, bin $k$ represents $f_k = k\,\dfrac{F_s}{N}$, so the spacing is

$$
\Delta f = \frac{F_s}{N}.
$$

**Why $N$ matters.** A larger $N$ gives smaller $\Delta f$, so nearby tones land in separate bins instead of blending.  
**Zero‑padding** increases $N$ by appending zeros; it *samples the same spectrum more finely* (smoother curves, clearer peaks) but does **not** add new frequency content.

---

## 🗣️ Part B — Resolution on a real signal (vowel “/A/”)

The synthesized vowel shows a natural period. Taking the DFT of **1 → 5 periods** and then zero‑padding to a fixed length makes the effect easy to see: **longer windows** narrow the main lobe and reduce leakage; **zero‑padding** refines the frequency grid used to plot the spectrum.

<div align="center">
  <img width="667" height="506" alt="SCR-20250929-mejs" src="https://github.com/user-attachments/assets/6d4211c3-e62d-4be7-8115-1462d40ddb5f" />
  <br/>
  <sub><b>Fig 7 — Zero‑padded spectra for one to five natural periods.</b> Longer records → finer resolution; zero‑padding refines the grid.</sub>
</div>

---

## 📶 Part C — FMCW radar on TMS320: dechirp → FFT → range

**Dechirp (plain language).** The transmitter emits a **linear chirp** (frequency ramps linearly). The echo is a **delayed** copy. Multiplying the transmit chirp by the **conjugate** of the received chirp (“dechirp”) turns that delay into a **single tone** at the **beat frequency** $f_b$. A longer delay makes a higher $f_b$. The FFT on the DSP then locates the tone as a spectral **peak**.

**Relationships used.** For bandwidth $B$ swept over $t_{\text{sweep}}$ (chirp slope $S=B/t_{\text{sweep}}$):

$$
f_b = S\,\delta t \quad\Rightarrow\quad \delta t = \frac{f_b\,t_{\text{sweep}}}{B}.
$$

Range follows from the round‑trip delay $r = \tfrac{c\,\delta t}{2}$. With an $N_{\text{FFT}}$‑point FFT and ADC rate $F_s$, the peak at bin $n_{\text{peak}}$ corresponds to

$$
r = \frac{c\,t_{\text{sweep}}}{2B}\;\frac{F_s\,n_{\text{peak}}}{N_{\text{FFT}}},
$$

where $c$ is the speed of light.

<div align="center">
  <img width="563" height="232" alt="SCR-20250929-meei" src="https://github.com/user-attachments/assets/48f41f44-0720-4f33-8844-3846e5216daa" />
  <br/>
  <sub><b>Fig 1 — Transmit vs. delayed receive chirps.</b> The offset creates a constant beat after dechirp.</sub>
</div>

<div align="center">
  <img width="442" height="329" alt="SCR-20250929-meda" src="https://github.com/user-attachments/assets/0286b4df-1357-4258-9ec0-9881fd12124a" />
  <br/>
  <sub><b>Fig 2 — Dechirped signal has a dominant tone at the beat frequency $f_b$.</b></sub>
</div>

**Implementation note.** On the TMS320, the vendor’s **DSP FFT** kernel reaches the same peak location with fewer cycles than a naïve C FFT, illustrating the value of optimized library routines on this platform.

<div align="center">
  <img width="594" height="341" alt="SCR-20250929-mehs" src="https://github.com/user-attachments/assets/8e1581ed-664a-450a-9746-935a0843ee58" />
  <br/>
  <sub><b>Fig 8 — FFT of the dechirped signal (C FFT).</b></sub>
</div>

<div align="center">
  <img width="593" height="337" alt="SCR-20250929-megx" src="https://github.com/user-attachments/assets/a56ef542-53f1-4545-9ad9-d651114c6916" />
  <br/>
  <sub><b>Fig 9 — FFT of the dechirped signal (DSP library).</b> Same target peak in fewer cycles.</sub>
</div>

---

## 🧠 Why this works (short intuition)

- **DFT bins act like frequency measuring cups.** A longer record creates more, smaller cups (narrower $\Delta f$), so close tones separate instead of blending.  
- **Zero‑padding changes the ruler, not the song.** It interpolates the same spectrum to make peaks and sidelobes look smooth.  
- **Dechirp turns distance into a tone.** Delay $\delta t$ ↦ beat $f_b$ ↦ FFT peak ↦ range $r$; a DSP’s optimized FFT makes this fast and power‑efficient.

---

## 📘 Glossary

- **DFT/FFT** — Discrete Fourier Transform and its fast algorithm.  
- **Zero‑padding** — Appending zeros to increase $N$ so the plotted spectrum is sampled more finely.  
- **Window length** — Number of original samples used; longer windows improve true resolution and reduce leakage.  
- **FMCW** — Frequency‑modulated continuous‑wave radar; distance maps to dechirped tone frequency.  
- **Beat frequency $f_b$** — Difference between transmit and delayed receive chirps after dechirp.  
- **$n_{\text{peak}}$** — FFT bin index of the detected peak.

---

## License

MIT — see `LICENSE`.
