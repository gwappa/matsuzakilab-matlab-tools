# Matsuzaki lab MATLAB tools

[![DOI](https://zenodo.org/badge/1024612487.svg)](https://doi.org/10.5281/zenodo.16350164)

A set of MATLAB functions that may be useful for physiology data analysis.

## Install

1. Download this repository (in whatever way you prefer)
2. Add the `code` directory to your MATLAB PATH:
   you don't need to 'add subdirectories'.

## Available modules and functions

- `csvio`: reads tabular data from comma-separated values (CSV)-like text data.
  - `csvio.read_dlc`: for reading from DeepLabCut output CSV files.
  - `csvio.read_lvm`: for reading from LabVIEW output `.lvm` files.
- `block1d`: extracts blocks of periods from a 1-d binary array
  (i.e. consisting of blocks of `true`'s and `false`'s)
  - `block1d.compute`: is the main function that does the operation
  - `block1d.detect_pulses`: to be used when blocks with `true`'s are of interest
- `ndPETH`: computes peri-event time histograms (PETHs).
  - `ndPETH.compute`: the main method. The first dimension must correspond to the time base.
  - `ndPETH.options`: for pre-computing PETH-generation options.

## Reporting problem(s)

Please contact the maintainer.

## License

The MIT License
