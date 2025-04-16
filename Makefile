DOCKER_TAG=comfyui-cuda:lastest
DOCKER_PARAMS=-it --rm --runtime "nvidia" --gpus "all" -v ".:/app" -v "./.tmp:/tmp"

SOURCES_PATH=./sources
COMFYUI_PATH=./comfyui
SCRIPTS_PATH=./scripts

## downloads
download-models-controlnet-sd15:
	bash $(SCRIPTS_PATH)/download.sh $(SOURCES_PATH)/models-controlnet-sd15 $(COMFYUI_PATH)/models/controlnet/sd15

download-models-checkpoints-sd15:
	bash $(SCRIPTS_PATH)/download.sh $(SOURCES_PATH)/models-checkpoints-sd15 $(COMFYUI_PATH)/models/checkpoints/sd15

download-models-checkpoints: download-models-checkpoints-sd15
download-models-controlnet: download-models-controlnet-sd15

download-models-upscale:
	bash $(SCRIPTS_PATH)/download.sh $(SOURCES_PATH)/models-upscale $(COMFYUI_PATH)/models/upscale_models

download-embeddings:
	bash $(SCRIPTS_PATH)/download.sh $(SOURCES_PATH)/models-embeddings $(COMFYUI_PATH)/models/embeddings

download-models: download-models-checkpoints download-models-upscale download-models-controlnet download-embeddings

## utils
fix-directory-owner:
	sudo chown -R ${USER}:${USER} ./comfyui

build-docker-image:
	docker build -t $(DOCKER_TAG) .

install: build-docker-image
	docker run $(DOCKER_PARAMS) --entrypoint="/bin/bash" $(DOCKER_TAG) -c "bash ./scripts/install-comfy.sh"

bash: build-docker-image
	docker run $(DOCKER_PARAMS) --entrypoint="/bin/bash" $(DOCKER_TAG)

run: build-docker-image
	docker run $(DOCKER_PARAMS) -p 8188:8188 $(DOCKER_TAG)