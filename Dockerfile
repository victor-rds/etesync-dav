FROM python:3.8-slim
ENV ETESYNC_DATA_DIR "/data"
ENV ETESYNC_SERVER_HOSTS "0.0.0.0:37358,[::]:37358"

COPY . /app

RUN set -eux; \
        apt-get update; \
        export BUILD_DEPS='build-essential libffi-dev libssl-dev cargo'; \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libffi6 ${BUILD_DEPS}; \
        /usr/local/bin/python -m pip install --upgrade pip; \
        pip install --no-cache-dir --progress-bar off -r /app/requirements.txt; \
        pip install --no-cache-dir --progress-bar off /app; \
        apt-get remove --purge -y ${BUILD_DEPS}; \
        apt-get autoremove --purge -y; \
        rm -rf /var/lib/apt/lists/*; \
        useradd etesync ;\
        mkdir -p /data ;\
        chown -R etesync: /data

VOLUME /data
EXPOSE 37358

USER etesync

ENTRYPOINT ["etesync-dav"]
