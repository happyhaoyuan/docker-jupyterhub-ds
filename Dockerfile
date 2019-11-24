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

#install zsh
# RUN sudo apt-get install zsh
# RUN chsh -s $(which zsh)

#install r
RUN apt install r-base
RUN apt-get install libzmq3-dev libcurl4-openssl-dev libssl-dev jupyter-core jupyter-client
#sudo R |install.packages(c('repr', 'IRdisplay', 'IRkernel'), type = 'source') | IRkernel::installspec(user = FALSE) | quit()

RUN apt-get update -y \
    && apt-get install -y \
        cron wamerican wajig \
        proxychains wget \
    && apt-get autoremove \
    && apt-get clean

# proxychains configuration
COPY settings/proxychains.conf /etc/proxychains.conf

EXPOSE 5006
