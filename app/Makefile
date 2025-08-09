# Makefile

# Specify the Python version
PYTHON_VERSION := python3.12
LAMBDA_VENV := .lambda_venv
PACKAGE_NAME := lambda_package.zip
LAMBDA_FUNCTION := lambda_function.py # Add other files separated by spaces if necessary
SITE_PACKAGES := $(LAMBDA_VENV)/lib/$(PYTHON_VERSION)/site-packages

# Default target executed when no arguments are given to make.
default: clean package

# Setup a virtual environment
venv:
	$(PYTHON_VERSION) -m venv $(LAMBDA_VENV)
	$(LAMBDA_VENV)/bin/pip install -U pip

# Install dependencies into the virtual environment
dependencies: venv
	$(LAMBDA_VENV)/bin/pip install -r requirements.txt

# Package the virtual environment libraries and your lambda function into a zip
package: dependencies
	@echo "Packaging site-packages..."
	cd $(SITE_PACKAGES) && zip -r9 "$(CURDIR)/$(PACKAGE_NAME)" .
	@echo "Adding Lambda function..."
	zip -g "$(PACKAGE_NAME)" $(LAMBDA_FUNCTION)

# Clean up the environment
clean:
	@echo "Limpando ambiente..."
	@if [ -d "$(LAMBDA_VENV)" ]; then \
		echo "Removendo $(LAMBDA_VENV)"; \
		rm -rf $(LAMBDA_VENV); \
	else \
		echo "Pasta $(LAMBDA_VENV) não existe"; \
	fi
	@if [ -f "$(PACKAGE_NAME)" ]; then \
		echo "Removendo $(PACKAGE_NAME)"; \
		rm -f $(PACKAGE_NAME); \
	else \
		echo "Arquivo $(PACKAGE_NAME) não existe"; \
	fi

.PHONY: default venv dependencies package