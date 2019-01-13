FROM balenalib/raspberrypi3-ubuntu:trusty

RUN apt-get update && apt-get install -yq \
   python sense-hat raspberrypi-bootloader && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
      build-essential libssl-dev libffi-dev libyaml-dev python3-dev python3-pip python3-gi && \
    pip3 install -r requirements.txt && \
    apt-get remove \
      build-essential libssl-dev libffi-dev libyaml-dev python3-dev python3-pip \
    && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
	
COPY src ./src
COPY start.sh ./

ENV INITSYSTEM on

CMD ["bash", "start.sh"]
