
.PHONY: test lint build publish publish-test init-env clean

ifeq ($(OS),Windows_NT)
  python := .venv/Scripts/python.exe
else
  python := .venv/bin/python
endif

pip = $(python) -m pip
poetry := $(python) -m poetry
flake8 := $(poetry) run flake8
mypy := $(poetry) run mypy

test:
	$(python) -m pytest -s

lint:
	$(flake8) --max-line-length 120 --ignore E231 --exclude .venv
	$(mypy) -m claude-cache-savings --ignore-missing-imports

build:
	$(poetry) build --format wheel

publish:
	$(poetry) config repositories.pypi https://upload.pypi.org/legacy/
	@$(poetry) config pypi-token.pypi $(PYPI_TOKEN)
	$(poetry) publish

publish-test:
	$(poetry) config repositories.pypi-test https://test.pypi.org/legacy/
	@$(poetry) config pypi-token.testpypi $(PYPI_TOKEN_TEST)
	$(poetry) publish

init-env:
	test -d .venv || python -m venv .venv && $(pip) install poetry==2.1.3
	$(poetry) install

clean:
	rm -rf dist
