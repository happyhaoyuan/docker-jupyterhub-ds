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
#RUN apt install r-base
#RUN apt-get install libzmq3-dev libcurl4-openssl-dev libssl-dev jupyter-core jupyter-client
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

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y \
        r-base-dev \
    && apt-get autoremove \
    && apt-get autoclean

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libxml2-dev \
        libcairo2-dev \
        libzmq3-dev \
        libssl-dev \
        jupyter-core \
        jupyter-client \
        libcurl4-openssl-dev \
        openjdk-8-jdk r-cran-rjava \
    && apt-get autoremove \
    && apt-get autoclean
    
COPY settings/install_r.R /scripts/
RUN Rscript /scripts/install_r.R

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && rstudio_version=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
    && rstudio_version_sub=${rstudio_version%-*} \
    && wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-${rstudio_version_sub}-amd64.deb -O /rstudio-server.deb \
    && apt-get install -y --no-install-recommends /rstudio-server.deb \
    && rm /rstudio-server.deb 

EXPOSE 8787

COPY settings/Rprofile.site /usr/local/lib/R/etc/
