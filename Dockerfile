FROM perl:5.38-threaded

RUN apt-get update && \
    apt-get install -y --no-install-recommends default-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY source/LBEEP.pl ./LBEEP
COPY dependency/ ./dependency/
COPY model/ ./model/
RUN mkdir -p ./temp

RUN chmod +x ./LBEEP

ENTRYPOINT ["perl", "LBEEP"]
