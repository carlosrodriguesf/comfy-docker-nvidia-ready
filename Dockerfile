FROM nvidia/cuda:12.8.1-cudnn-runtime-ubuntu24.04

RUN apt update
RUN apt install -y python3.12-venv python3.12-dev git g++ make libgl1 libglib2.0-0

WORKDIR /app

CMD [ "/bin/bash", "./scripts/entrypoint.sh" ]