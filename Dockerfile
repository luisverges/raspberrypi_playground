FROM balenalib/raspberrypi3-ubuntu:trusty


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



FROM balenalib/raspberrypi3-ubuntu:trusty-build

# remove several traces of debian python
RUN apt-get purge -y python.*

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# key 63C7CC90: public key "Simon McVittie <smcv@pseudorandom.co.uk>" imported
# key 3372DCFA: public key "Donald Stufft (dstufft) <donald@stufft.io>" imported
RUN gpg --keyserver keyring.debian.org --recv-keys 4DE8FF2A63C7CC90 \
	&& gpg --keyserver keyserver.ubuntu.com --recv-key 6E3CBCE93372DCFA \
	&& gpg --keyserver keyserver.ubuntu.com --recv-keys 0x52a43a1e4b77b059

ENV PYTHON_VERSION 3.6.6

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 10.0.1

ENV SETUPTOOLS_VERSION 39.1.0

RUN set -x \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/python/v$PYTHON_VERSION/Python-$PYTHON_VERSION.linux-armv7hf.tar.gz" \
	&& echo "e2130fa5f0b5c889fd4b75c25c7eb5eb89fec9ef427932a5cff67a554888de2b  Python-$PYTHON_VERSION.linux-armv7hf.tar.gz" | sha256sum -c - \
	&& tar -xzf "Python-$PYTHON_VERSION.linux-armv7hf.tar.gz" --strip-components=1 \
	&& rm -rf "Python-$PYTHON_VERSION.linux-armv7hf.tar.gz" \
	&& ldconfig \
	&& if [ ! -e /usr/local/bin/pip3 ]; then : \
		&& curl -SLO "https://raw.githubusercontent.com/pypa/get-pip/430ba37776ae2ad89f794c7a43b90dc23bac334c/get-pip.py" \
		&& echo "19dae841a150c86e2a09d475b5eb0602861f2a5b7761ec268049a662dbd2bd0c  get-pip.py" | sha256sum -c - \
		&& python3 get-pip.py \
		&& rm get-pip.py \
	; fi \
	&& pip3 install --no-cache-dir --upgrade --force-reinstall pip=="$PYTHON_PIP_VERSION" setuptools=="$SETUPTOOLS_VERSION" \
	&& find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
	&& cd / \
	&& rm -rf /usr/src/python ~/.cache

ENV PYTHON_DBUS_VERSION 1.2.4

# install dbus-python dependencies 
RUN apt-get update && apt-get install -y --no-install-recommends \
		libdbus-1-dev \
		libdbus-glib-1-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get -y autoremove

# install dbus-python
RUN set -x \
	&& mkdir -p /usr/src/dbus-python \
	&& curl -SL "http://dbus.freedesktop.org/releases/dbus-python/dbus-python-$PYTHON_DBUS_VERSION.tar.gz" -o dbus-python.tar.gz \
	&& curl -SL "http://dbus.freedesktop.org/releases/dbus-python/dbus-python-$PYTHON_DBUS_VERSION.tar.gz.asc" -o dbus-python.tar.gz.asc \
	&& gpg --verify dbus-python.tar.gz.asc \
	&& tar -xzC /usr/src/dbus-python --strip-components=1 -f dbus-python.tar.gz \
	&& rm dbus-python.tar.gz* \
	&& cd /usr/src/dbus-python \
	&& PYTHON=python$(expr match "$PYTHON_VERSION" '\([0-9]*\.[0-9]*\)') ./configure \
	&& make -j$(nproc) \
	&& make install -j$(nproc) \
	&& cd / \
	&& rm -rf /usr/src/dbus-python

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
	&& ln -sf pip3 pip \
	&& { [ -e easy_install ] || ln -s easy_install-* easy_install; } \
	&& ln -sf idle3 idle \
	&& ln -sf pydoc3 pydoc \
	&& ln -sf python3 python \
	&& ln -sf python3-config python-config

# set PYTHONPATH to point to dist-packages
ENV PYTHONPATH /usr/lib/python3/dist-packages:$PYTHONPATH

WORKDIR /usr/src/app

#install raspberrypi modules
RUN apt-get update && apt-get install -yq \
   sense-hat raspberrypi-bootloader && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

#install requirements
COPY requirements.txt ./
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
      build-essential libssl-dev libffi-dev libyaml-dev libjpeg-dev zlib1g-dev python3-dev python3-pip python3-gi && \
    pip3 install -r requirements.txt && \
    apt-get remove \
      build-essential libssl-dev libffi-dev libyaml-dev python3-dev python3-pip \
    && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
	
COPY src ./src
COPY start.sh ./

ENV INITSYSTEM on

CMD ["bash", "start.sh"]
