FROM ubuntu:20.04
RUN echo 'root:jupyter' | chpasswd
# Working Directory
WORKDIR /jupyter
# Install Python
RUN apt update
RUN apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev wget libbz2-dev
RUN wget https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tgz
RUN tar -xf Python-3.7.10.tgz
WORKDIR /jupyter/Python-3.7.10
# RUN ./configure --enable-optimizations
RUN make install
# Install Jupyter
WORKDIR /jupyter
RUN python3 -m venv venv
RUN . venv/bin/activate
RUN pip3 install jupyter jupyterlab
ENV HOME="/root"
ENV PATH="${HOME}/.local/bin:${PATH}"
# Disable interactive interface
RUN export DEBIAN_FRONTEND=noninteractive
# Install DotNet
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt-get update; apt-get install -y apt-transport-https && apt-get update && apt-get install -y dotnet-sdk-5.0
# Install DotNet in Jupyter
RUN dotnet tool install --global Microsoft.dotnet-interactive
ENV PATH="${PATH}:${HOME}/.dotnet/tools"
RUN dotnet interactive jupyter install
# Setting config file
RUN jupyter lab --generate-config
RUN echo 'c.NotebookApp.password = u"argon2:$argon2id$v=19$m=10240,t=10,p=8$RZcwK0nNL4dyJDkEQ8gG9A$COV2ju8zmfuf/FX/dQ0JvA"' >> /root/.jupyter/jupyter_lab_config.py
# Run the server
EXPOSE 8888
CMD jupyter lab --no-browser --port=8888 --ip=0.0.0.0 --allow-root