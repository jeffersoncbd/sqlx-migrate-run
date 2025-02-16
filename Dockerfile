FROM rust:bullseye

ARG SCCACHE_URL
ARG MINIO_URL
ARG MINIO_BUCKET
ARG MINIO_ACCESS_KEY
ARG MINIO_SECRET_ACCESS_KEY

ARG PROJECT_GIT_URL

RUN apt-get update && apt-get install -y --no-install-recommends tar \
  && rm -rf /var/lib/apt/lists/*

ADD ${SCCACHE_URL} /sccache.tar.gz

RUN tar -xzf sccache.tar.gz \
  && mv ./sccache /usr/local/bin/sccache \
  && chmod +x /usr/local/bin/sccache \
  && rm sccache.tar.gz

ENV RUSTC_WRAPPER=/usr/local/bin/sccache
ENV SCCACHE_REGION=auto
ENV SCCACHE_ENDPOINT=${MINIO_URL}
ENV SCCACHE_BUCKET=${MINIO_BUCKET}
ENV AWS_ACCESS_KEY_ID=${MINIO_ACCESS_KEY}
ENV AWS_SECRET_ACCESS_KEY=${MINIO_SECRET_ACCESS_KEY}

RUN git clone ${PROJECT_GIT_URL} /app

WORKDIR /app

COPY . .

CMD ["/app/run.sh"]
