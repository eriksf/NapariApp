APPID ?= eriksf-napari-0.0.1
IMAGE_VERSION ?= 0.4.17
ts := $(shell /bin/date "+%Y-%m-%d-%H%M%S")

build:
	docker build -t eriksf/napari:${IMAGE_VERSION} .
	docker tag eriksf/napari:${IMAGE_VERSION} eriksf/napari:latest

push:
	docker push eriksf/napari:${IMAGE_VERSION} && docker push eriksf/napari:latest

list:
	tapis apps search --id start eriksf

deploy:
	tapis apps deploy -W . -F app.json --ini project.ini --no-build --no-push

update:
	tapis apps update -F app.json --ini project.ini ${APPID}

jobinit:
	tapis jobs init --all ${APPID} >test-${ts}.json
