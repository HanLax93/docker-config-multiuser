# 使用官方的 cuda 11.3.1 on Ubuntu 20.04 作为基础镜像
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# 设置默认时区
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 更换软件源
COPY ./scripts/sources.list /etc/apt/sources.list
COPY ./scripts/dependencies.tar.gz /tmp/
COPY ./scripts/script.sh /usr/

# 安装基础依赖
RUN chmod +x /usr/script.sh \
    && rm /etc/apt/sources.list.d/cuda.list \
    && apt-key del 7fa2af80 \
    && apt-key adv --fetch-keys https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub \
    && chmod 777 /tmp && chmod +t /tmp \
    && apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    build-essential \
    openssh-server \
    vim \
    firefox \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    sudo \
    iputils-ping \
    xfce4-screensaver \
    xfce4-power-manager \
    && apt remove light-locker

# 设置环境变量
ENV ANACONDA_VERSION 2023.07-0
ENV PATH /opt/anaconda/bin:/usr/local/cuda/bin:$PATH
COPY ./scripts/Anaconda3-2023.07-0-Linux-x86_64.sh /Anaconda3-2023.07-0-Linux-x86_64.sh
RUN bash Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -b -p /opt/anaconda \
    && rm Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh

CMD ["sh", "/usr/script.sh"]
