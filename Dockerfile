# Use the official Alpine image
FROM alpine:3.19

# 1. Install system-level dependencies
# python3: The core interpreter
# py3-pip: Python package manager
RUN apk add --no-cache \
    curl \
    git \
    iputils \
    python3 \
    py3-pip

# 2. Create a virtual environment (Best practice for modern Python)
# This avoids "externally-managed-environment" errors in Alpine
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# 3. Upgrade pip and install kafka-python
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir kafka-python==2.2.15 \
    pip install --no-cache-dir cangling-ai==0.1.7

# Set the working directory
WORKDIR /app

CMD ["/bin/sh"]