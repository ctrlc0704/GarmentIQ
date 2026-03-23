# Running GarmentIQ from Source

This guide explains how to run the entire GarmentIQ project from the local source code **without modifying any existing files**.

---

## Prerequisites

| Requirement | Version |
|-------------|---------|
| Python      | ≥ 3.11  |
| pip         | ≥ 23    |
| (optional) Jupyter | any recent release |

---

## 1. Clone the repository

```bash
git clone https://github.com/ctrlc0704/GarmentIQ.git
cd GarmentIQ
```

---

## 2. (Recommended) Create a virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate        # Linux / macOS
# .venv\Scripts\activate         # Windows PowerShell
```

---

## 3. Install the package in editable (development) mode

This installs all required dependencies **and** makes `import garmentiq` resolve directly from the `src/` directory.  
No existing source files are modified.

```bash
pip install -e .
```

Or with the Makefile shortcut:

```bash
make install-dev
```

---

## 4. Verify the installation

```bash
python -c "import garmentiq as giq; print('OK –', giq.__file__)"
# Expected: OK – .../src/garmentiq/__init__.py
```

Or:

```bash
make test-import
```

---

## 5. Run the notebooks

The `test/` directory contains eight Jupyter notebooks that cover every component of the pipeline:

| Notebook | What it covers |
|----------|---------------|
| `tailor_quick_start.ipynb` | End-to-end pipeline (classification → segmentation → landmark → measurement) |
| `classification_quick_start.ipynb` | Garment image classification |
| `segmentation_quick_start.ipynb` | Background removal / segmentation |
| `landmark_detection_quick_start.ipynb` | Landmark detection |
| `landmark_refinement_and_derivation_quick_start.ipynb` | Landmark refinement & derivation |
| `custom_measurement_instruction_advanced_usage.ipynb` | Custom measurement instructions |
| `classification_model_training_evaluation_advanced_usage.ipynb` | Training & evaluation |
| `classification_model_fine_tuning_advanced_usage.ipynb` | Fine-tuning a classifier |

### 5a. Launch Jupyter

```bash
jupyter notebook --notebook-dir=test
```

Or with the Makefile:

```bash
make run-notebooks
```

### 5b. Skip (or replace) the PyPI install cell

Each notebook starts with:

```python
!pip install garmentiq -q
```

Because you have already installed the package from source (step 3), you can:

- **Skip that cell** – select it and press `Ctrl+Enter` without running, or go to *Cell → Run All Below* after moving past it, **or**
- **Replace it** with the no-op comment `# already installed from source` in your own copy.

> ⚠️ Running `!pip install garmentiq -q` while the editable install is active may overwrite it with the PyPI release.  
> Re-run `pip install -e .` afterwards to restore the source link.

---

## 6. Run all notebooks non-interactively (CI / batch)

Install `nbconvert` and execute every notebook in sequence:

```bash
pip install nbconvert
for nb in test/*.ipynb; do
    jupyter nbconvert --to notebook --execute "$nb" --output "$(basename $nb .ipynb)_executed.ipynb"
done
```

---

## Project layout

```
GarmentIQ/
├── pyproject.toml          # build configuration (pip install -e . reads this)
├── Makefile                # developer shortcuts
├── DEVELOPMENT.md          # this file
├── src/
│   ├── requirements.txt    # dependency list (same as pyproject.toml dependencies)
│   └── garmentiq/          # the Python package
│       ├── __init__.py
│       ├── tailor.py
│       ├── garment_classes.py
│       ├── classification/
│       ├── segmentation/
│       ├── landmark/
│       ├── instruction/    # JSON measurement schemas
│       └── utils/
└── test/                   # Jupyter notebooks
```

---

## Useful Makefile targets

```bash
make help          # show all available targets
make install-dev   # editable install (recommended for development)
make install       # regular install from source
make test-import   # quick smoke-test that the package loads
make run-notebooks # start Jupyter pointing at test/
make clean         # remove build artefacts
```
