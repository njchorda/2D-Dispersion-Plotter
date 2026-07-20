# 2D Dispersion Plotter (Γ–X–M–Γ) from HFSS Eigenmode Simulation

A simple MATLAB script that generates a dispersion diagram along the irreducible Brillouin zone path **Γ → X → M → Γ** for a periodic unit cell, using eigenmode frequency data exported from Ansys HFSS.

## Overview

The script reads a CSV export of eigenmode frequencies swept over two phase variables (`px`, `py`, representing phase delay in the x and y directions of a periodic lattice), reconstructs the three legs of the standard square-lattice Brillouin zone path, and plots frequency vs. phase for a specified number of modes.

## HFSS Setup

The HFSS eigenmode simulation must be configured as follows:

1. Define phase sweep variables `px` and `py`.
2. Create three parametric setups sweeping `px` and `py` from 0° to 180°:
   - **Setup 1 (Γ → X):** `py = 0`, sweep `px` from 0 to 180.
   - **Setup 2 (X → M):** `px = 180`, sweep `py` from 0 to 180.
   - **Setup 3 (M → Γ):** Sweep both `px` and `py` together (linked) from 0 to 180.
3. `px` and `py` must use the same range and step size.
4. Create an Eigenmode results plot with:
   - Primary sweep: `py`
   - All `px` values selected
   - Y-axis: Frequency
   - X-axis: Phase
5. **Export the plot data** with the option **"Use Separate Columns for Curves"** enabled, and save as a `.csv` file.

## Expected CSV Format

- **Column 1:** `py` values (0 to 180), used as the row index.
- **Remaining columns:** Frequency data for each mode, organized in blocks of `numel(py)` columns per mode (one block per `px` value swept within that mode, per the "separate columns for curves" export).

## Script Configuration

Edit these variables at the top of the script before running:

| Variable | Description |
|---|---|
| `modesToPlot` | Number of lowest-order modes to display on the plot (in case the export contains more modes than needed). |
| `fname` | Filename of the exported HFSS CSV data (default: `'PostTest.csv'`). |

## Output

A single figure window showing the band structure: frequency (GHz) on the y-axis vs. the unfolded phase path Γ–X–M–Γ on the x-axis, with high-symmetry points labeled.

## Dependencies

- Uses `readmatrix`, requires R2019a or later.

## Notes / Optional Tweaks

- If your structure's fundamental mode has a cutoff frequency of 0 Hz, you may need to manually zero out the endpoints of `GamToX` and `MtoGam` (commented-out lines are provided in the script for this).
- The `xlim` and `yticks` lines are commented out but can be uncommented to manually control axis limits/ticks.
- The script assumes a **square lattice** (path length is identical for all three segments, each spanning 0–180°). Non-square lattices would require modification.
