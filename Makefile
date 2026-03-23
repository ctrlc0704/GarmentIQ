.PHONY: help install install-dev test-import run-notebooks clean

PYTHON ?= python3
PIP    ?= $(PYTHON) -m pip
JUPYTER ?= jupyter

help:
	@echo "GarmentIQ – Development helpers"
	@echo ""
	@echo "  make install       Install the package and all dependencies from source (production)"
	@echo "  make install-dev   Install in editable/development mode (changes to src/ take effect immediately)"
	@echo "  make test-import   Verify that the package imports correctly from the local source"
	@echo "  make run-notebooks Launch Jupyter and open the test notebooks"
	@echo "  make clean         Remove build artifacts"

install:
	$(PIP) install . -q

install-dev:
	$(PIP) install -e . -q

test-import:
	$(PYTHON) -c "import garmentiq as giq; print('garmentiq imported successfully from:', giq.__file__)"

run-notebooks:
	@echo "Starting Jupyter Notebook server – open test/<notebook>.ipynb in your browser."
	@echo "When a notebook cell runs  '!pip install garmentiq -q'  it may reinstall from PyPI."
	@echo "To keep using the local source, skip that cell or run:  pip install -e .  first."
	$(JUPYTER) notebook --notebook-dir=test

clean:
	rm -rf src/*.egg-info build dist
	find . -type d -name __pycache__ -exec rm -rf {} +
