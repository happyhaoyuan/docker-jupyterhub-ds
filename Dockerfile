FROM dclong/jupyterhub-beakerx

RUN pip3 install --no-cache-dir \
findspark \
pyspark-stubs \
plotly \
cufflinks \
click \
tqdm \
loguru \
pyarrow \
fastparquet \
rainbow_logging_handler

RUN apt-get update -y \
    && apt-get install -y \
        cron wamerican wajig \
        proxychains wget \
    && apt-get autoremove \
    && apt-get clean

# proxychains configuration
COPY settings/proxychains.conf /etc/proxychains.conf

EXPOSE 5006
