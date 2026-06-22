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

# 3. Create Conda Environment, include 'pip' explicitly, and pull compatible GDAL
# Using modern gdal allows both x86_64 and arm64 architectures to resolve successfully.
ENV CONDA_ENV=myenv
RUN conda create -n $CONDA_ENV -c conda-forge python=3.11 gdal pip -y

# Set path environment variables
ENV PATH=/opt/conda/envs/$CONDA_ENV/bin:$PATH

# 4. Install Pip Dependencies using the isolated path
RUN /opt/conda/envs/$CONDA_ENV/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/conda/envs/$CONDA_ENV/bin/pip install --no-cache-dir \
    kafka-python-ng==2.2.2 \
    loguru==0.7.3

# 5. Install Custom Private/Public Package
RUN /opt/conda/envs/$CONDA_ENV/bin/pip install --no-cache-dir cangling-ai==0.1.21

# 6. CRITICAL K3S SYMLINKS
# This forces external K3s executors to hit your conda environment packages seamlessly
RUN ln -sf /opt/conda/envs/$CONDA_ENV/bin/python /usr/bin/python && \
    ln -sf /opt/conda/envs/$CONDA_ENV/bin/python3 /usr/bin/python3 && \
    ln -sf /opt/conda/envs/$CONDA_ENV/bin/pip /usr/bin/pip && \
    ln -sf /opt/conda/envs/$CONDA_ENV/bin/pip3 /usr/bin/pip3

# 7. Environment Settings
ENV PYTHONUNBUFFERED=1
WORKDIR /app

RUN echo "conda activate $CONDA_ENV" >> ~/.bashrc

# 8. Add Startup Script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]