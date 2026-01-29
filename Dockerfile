# 使用 Alpine 3.19
FROM alpine:3.19

# 1. 安装系统依赖 + 时区工具
RUN apk add --no-cache \
    curl \
    git \
    iputils \
    python3 \
    py3-pip \
    tzdata  # 用于设置时区

# 2. 设置时区为上海
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 3. 创建并激活虚拟环境
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# 4. 安装依赖
# 建议先安装基础依赖，再安装你自己的私有库
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
    kafka-python==2.0.2 \
    loguru==0.7.3

# 5. 安装你自己的库 (0.1.7 版本)
# 如果 cangling-ai 在公有 PyPI 上，直接安装；
# 如果是本地文件，请先 COPY 进去再安装：COPY dist/*.whl /tmp/
RUN pip install --no-cache-dir cangling-ai==0.1.10

# 6. 关键：设置 Python 刷新缓冲区
# 这样 loguru 的日志才能实时显示在 K8S 的 xterm.js 终端中
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# 默认启动 shell，方便调试
CMD ["/bin/sh"]