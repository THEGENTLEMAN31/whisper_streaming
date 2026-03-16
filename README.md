
```markdown
# whisper_streaming – Dockerized Real‑Time Transcription

[![Docker Pulls](https://img.shields.io/docker/pulls/thegentleman31/whisper-streaming)](https://hub.docker.com/r/thegentleman31/whisper-streaming)
[![GitHub](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

This repository provides a **Docker‑ready** version of [whisper_streaming](https://github.com/ufal/whisper_streaming) by UFAL – a system that turns OpenAI Whisper into a low‑latency, real‑time speech transcription and translation engine.

With this setup you can:
- 🎤 Transcribe audio from a file or directly from a microphone
- 🌍 Translate any language to English on the fly
- 🚀 Leverage GPU acceleration (NVIDIA) with a simple flag
- 🐳 Run everything in a clean, reproducible Docker container

## ✨ Features

- **Live streaming** from microphone via TCP server
- **Offline file transcription** (WAV, 16kHz mono)
- **Voice Activity Control** (`--vac`) for better streaming performance
- **Multi‑language** support (all Whisper languages)
- **Translation** to English (`--task translate`)
- **Multiple Whisper backends** (faster-whisper, whisper_timestamped, openai-api, mlx-whisper) – switch via `--backend`
- **NVIDIA GPU support** out of the box
- **Easy deployment** with Docker Compose

## 📦 Quick Start

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) (with Compose plugin)
- (Optional) [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) for GPU acceleration

### 1. Pull the pre‑built image (recommended)
```bash
docker pull thegentleman31/whisper-streaming:latest
```

### 2. Transcribe a file
Place your 16kHz mono WAV file in a folder (e.g. `./audio`) and run:
```bash
docker run --rm -v ./audio:/audio thegentleman31/whisper-streaming \
  whisper_online.py --model base --language fr --vac /audio/myfile.wav
```

### 3. Run the streaming server (for microphone input)
```bash
docker run -d --name whisper-server -p 43001:43001 \
  -v whisper-cache:/root/.cache/whisper \
  thegentleman31/whisper-streaming \
  whisper_online_server.py --model base --language fr --vac --host 0.0.0.0 --port 43001
```

From another terminal, send audio from your microphone (Linux):
```bash
arecord -f S16_LE -c1 -r 16000 -t raw | nc localhost 43001
```

View the transcribed text in the container logs:
```bash
docker logs -f whisper-server
```

Stop the server:
```bash
docker stop whisper-server
```

## 🐳 Docker Compose (optional)

Create a `docker-compose.yml` file:

```yaml
version: '3.8'
services:
  whisper:
    image: thegentleman31/whisper-streaming
    container_name: whisper
    ports:
      - "43001:43001"
    volumes:
      - ./audio:/audio
      - whisper-cache:/root/.cache/whisper
    command: whisper_online_server.py --model base --language fr --vac --host 0.0.0.0 --port 43001
volumes:
  whisper-cache:
```

Then:
```bash
docker-compose up -d
docker-compose logs -f
```

## 🔧 Advanced Usage

### File transcription with custom options
```bash
docker run --rm -v ./audio:/audio thegentleman31/whisper-streaming \
  whisper_online.py --model large-v3 --language fr --vac --task translate /audio/long_speech.wav
```

### Using a different Whisper backend
```bash
docker run --rm -v ./audio:/audio thegentleman31/whisper-streaming \
  whisper_online.py --backend whisper_timestamped --model base --language fr /audio/file.wav
```

### GPU acceleration
Add `--gpus all` to any `docker run` command:
```bash
docker run --rm --gpus all -v ./audio:/audio thegentleman31/whisper-streaming \
  whisper_online.py --model large-v3 --language fr --vac /audio/file.wav
```

### Building the image locally
If you prefer to build instead of pulling:
```bash
git clone https://github.com/THEGENTLEMAN31/whisper_streaming.git
cd whisper_streaming
docker build -t whisper-streaming .
```

Then use `whisper-streaming` as the image name.

## 📁 Repository structure

- `whisper_online.py` – main transcription script
- `whisper_online_server.py` – TCP server for live streaming
- `silero_vad_iterator.py` – voice activity detection (from Silero)
- `line_packet.py` – helper for packet handling
- `Dockerfile` – multi‑stage build recipe
- `docker-compose.yml` – easy server launch
- `README.md` – this file

## 📚 Original project

This repository is a Dockerised wrapper around the excellent [whisper_streaming](https://github.com/ufal/whisper_streaming) project by Dominik Macháček et al.  
If you use this work academically, please cite their paper:

```bibtex
@inproceedings{machacek-etal-2023-turning,
    title = "Turning Whisper into Real-Time Transcription System",
    author = "Mach{\'a}{\v{c}}ek, Dominik and Dabre, Raj and Bojar, Ond{\v{r}}ej",
    booktitle = "Proceedings of the 13th International Joint Conference on Natural Language Processing and the 3rd Conference of the Asia-Pacific Chapter of the Association for Computational Linguistics: System Demonstrations",
    year = "2023",
    pages = "17--24"
}
```

## 📄 License

MIT (same as the original project).  
Maintainer: [thegentleman31](https://github.com/THEGENTLEMAN31)
```

