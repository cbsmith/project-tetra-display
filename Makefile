VENV_NAME:=venv
VENV_BINDIR:=$(VENV_NAME)/bin
VENV_TOUCHFILE:=$(VENV_NAME).touch
PIP:=$(VENV_BINDIR)/pip3
PYTHON:=$(VENV_BINDIR)/python
BEHAVE:=$(VENV_BINDIR)/behave
SCRIPT_DIR=Scripts
TEST_DIR=Tests


.PHONY: all check test test_behave test_unittest clean

all: $(VENV_TOUCHFILE)

$(PIP):
	python3 -m venv $(VENV_NAME) && $(PIP) install -U pip

$(VENV_TOUCHFILE): $(PIP) requirements.txt
	$(PIP) install -r requirements.txt && touch $@

check: test

test: test_unittest test_behave

test_behave: $(VENV_TOUCHFILE)
	$(BEHAVE)

test_unittest: $(VENV_TOUCHFILE)
	$(PYTHON) -m unittest

clean:
	rm -rf $(VENV_NAME) __pycache__ $(SCRIPT_DIR)/__pycache__ $(TEST_DIR)/__pycache__
	python3 -Bc "import pathlib; [p.unlink() for p in pathlib.Path('.').rglob('*.py[co]')]"
