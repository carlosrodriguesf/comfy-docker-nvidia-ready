#!/bin/bash

if [ ! -d "./comfyui" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI comfyui
fi

cd comfyui || exit

if [ ! -d "./venv" ]; then
  python3 -m venv venv
  ./venv/bin/pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu126
  ./venv/bin/pip install -r requirements.txt
fi

if [ ! -d "./custom_nodes/comfyui-manager" ]; then
  git clone https://github.com/ltdrdata/ComfyUI-Manager custom_nodes/comfyui-manager
fi