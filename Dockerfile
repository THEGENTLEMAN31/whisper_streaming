FROM python:3.11-slim

WORKDIR /app

# Installation des dépendances système minimales
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Copie des scripts
COPY whisper_online.py .
COPY whisper_online_server.py .
COPY silero_vad_iterator.py .
COPY line_packet.py .

# Installation des dépendances Python
RUN pip install --no-cache-dir \
    faster-whisper \
    torch \
    torchaudio \
    librosa \
    soundfile

# Port pour le serveur
EXPOSE 43001

# Par défaut, aide
CMD ["python", "whisper_online.py", "--help"]
