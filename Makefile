.PHONY: help train-mnist-tf deploy-mnist-tfx predict-mnist-tfx destroy-mnist-tfx train-iris-rf deploy-iris-plumb predict-iris-plumb destroy-iris-plumb
.DEFAULT_GOAL := help

train-mnist-tf: ## trains mnist model and places it in models/mnist_tf
	docker build --target train -t mnistr:latest .
	docker run -v $(CURDIR)/models:/prodr/models mnistr:latest train.R --tf 1 --modeldir ./models

deploy-mnist-tfx: ## deploys mnist locally using tfx; see predict-mnist-tfx, destroy-mnist-tfx also
	docker run -p 8501:8501 --mount type=bind,source=$(CURDIR)/models/mnist_tf,target=/models/mnist/1 -e MODEL_NAME=mnist -d --name="mnist_tfx" tensorflow/serving

predict-mnist-tfx: ## sends a prediction request to mnist served by tfx
	curl --data "@./data/curl_data_tfx.json" -X POST http://localhost:8501/v1/models/mnist:predict

destroy-mnist-tfx: ## destroys mnist local mnist deployment
	docker stop mnist_tfx
	docker rm mnist_tfx

train-iris-rf: ## trains iris model and places it in models/iris_rf
	docker build --target train -t irisr:latest .
	docker run -v $(CURDIR)/models:/prodr/models irisr:latest train.R --tf 0 --modeldir ./models

deploy-iris-plumb: ## deploys iris model locally using plumber; see predict-iris-plumb, destroy-mnist-plum also
	docker build --target deploy -t iris-plumb:latest .
	docker run -p 8080:8080 --mount type=bind,source=$(CURDIR)/models/iris_rf,target=/opt/ml/model/ -d --name="irir_plumb" iris-plumb:latest serve

predict-iris-plumb: ## sends a prediction request to iris served by plumber
	curl --data "@./data/curl_data_plumb.json" --header 'Content-Type: application/json' -X POST http://localhost:8080/invocations

destroy-iris-plumb: ## destroys iris local plumber deployment
	docker stop irir_plumb
	docker rm irir_plumb
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
