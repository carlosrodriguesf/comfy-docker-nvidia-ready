DOCKER_TAG=comfyui-cuda:lastest
DOCKER_PARAMS=-it --rm --runtime nvidia --gpus all -v .:/app -v ./app/tmp:/tmp
COMFYUI_PATH=./app/comfyui

# downloads
download-checkpoints:
	wget -c https://huggingface.co/minaiosu/Copax/resolve/main/copax2DAnime_v4.safetensors -P $(COMFYUI_PATH)/models/checkpoints/sd15

download-upscale-models:
	wget -c https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth -P $(COMFYUI_PATH)/models/upscale_models
	wget -c https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x2.pth -P $(COMFYUI_PATH)/models/upscale_models
	wget -c https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth -P $(COMFYUI_PATH)/models/upscale_models
	wget -c https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x8.pth -P $(COMFYUI_PATH)/models/upscale_models

download-controlnet-models:
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_canny_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_seg_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15
	wget -c https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11u_sd15_tile_fp16.safetensors -P $(COMFYUI_PATH)/models/controlnet/sd15

download-embeddings:
	wget -c https://huggingface.co/gemasai/verybadimagenegative_v1.3/resolve/main/verybadimagenegative_v1.3.pt -P $(COMFYUI_PATH)/models/embeddings
	wget -c https://huggingface.co/datasets/gsdf/EasyNegative/resolve/main/EasyNegative.safetensors -P $(COMFYUI_PATH)/models/embeddings

download-models: download-checkpoints download-upscale-models download-controlnet-models download-embeddings

fix-directory-owner:
	sudo chown -R ${USER}:${USER} ./app

build-docker-image:
	docker build -t $(DOCKER_TAG) .

install: build-docker-image
	docker run $(DOCKER_PARAMS) --entrypoint="/bin/bash" $(DOCKER_TAG) -c "bash ./scripts/install-comfy.sh"

run: build-docker-image
	docker run $(DOCKER_PARAMS) -p 8188:8188 $(DOCKER_TAG)