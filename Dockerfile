# Use the official Alpine image
FROM alpine:3.19

# Install tools and Python
# python3: The core interpreter
# py3-pip: Essential for installing Python packages
RUN apk add --no-cache \
    curl \
    git \
    iputils \
    python3 \
    py3-pip

# Verify the installation
RUN python3 --version && pip3 --version

CMD ["/bin/sh"]