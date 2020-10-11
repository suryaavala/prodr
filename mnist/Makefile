.PHONY: help train-mnist deploy-mnist-tfx predict-mnist-tfx
.DEFAULT_GOAL := help

train-mnist: ## trains mnist model and places it in models/mnist
	docker build -t mnistr:latest .
	docker run -it -v $(CURDIR)/models:/mnist/models mnistr:latest

deploy-mnist-tfx: ## deploys mnist locally using tfx; see predict-mnist-tfx also
	docker run -p 8501:8501 --mount type=bind,source=$(CURDIR)/models/mnist,target=/models/mnist/1 -e MODEL_NAME=mnist -it tensorflow/serving

#TODO predict-mnist-tfx: ## sends a prediction request to mnist served by tfx

#
# HELP
#
define BROWSER_PYSCRIPT
import os, webbrowser, sys

from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)
