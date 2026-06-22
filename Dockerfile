# 1. Use the official Miniconda3 base image
FROM continuumio/miniconda3:latest

# 2. Set Timezone and Install System Dependencies
ENV TZ=Asia/Shanghai
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    iputils-ping \
    tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Create Conda Environment and Install GDAL
ENV CONDA_ENV=myenv
RUN conda create -n $CONDA_ENV -c conda-forge python=3.11 gdal -y

# Set path environment variables
ENV PATH /opt/conda/envs/$CONDA_ENV/bin:$PATH

# 4. Install Pip Dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    kafka-python==2.0.2 \
    loguru==0.7.3

# 5. Install Custom Private/Public Package
RUN pip install --no-cache-dir cangling-ai==0.1.15

# CRITICAL FIX FOR K3S/K8S:
# Overwrite/Symlink system paths to force usage of your conda environment everywhere
RUN ln -sf /opt/conda/envs/$CONDA_ENV/bin/python /usr/bin/python && \
    ln -sf /opt/conda/envs/$CONDA_ENV/bin/python3 /usr/bin/python3 && \
    ln -sf /opt/conda/envs/$CONDA_ENV/bin/pip /usr/bin/pip && \
    ln -sf /opt/conda/envs/$CONDA_ENV/bin/pip3 /usr/bin/pip3

# 6. Environment Settings
ENV PYTHONUNBUFFERED=1
WORKDIR /app

RUN echo "conda activate $CONDA_ENV" >> ~/.bashrc

# 7. Add Startup Script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]