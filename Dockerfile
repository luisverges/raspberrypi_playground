FROM balenalib/raspberry-pi3-debian:jessie

RUN apt-get update && apt-get install -yq \
   python sense-hat raspberrypi-bootloader && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
      build-essential libssl-dev libffi-dev libyaml-dev python3-dev python3-pip && \
    pip3 install -r requirements.txt && \
    apt-get remove \
      build-essential libssl-dev libffi-dev libyaml-dev python3-dev python3-pip \
    && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV INITSYSTEM on

COPY . .
COPY src/* ./
COPY start.sh ./

CMD ["bash", "start.sh"]


CMD modprobe i2c-dev && python src/main.py