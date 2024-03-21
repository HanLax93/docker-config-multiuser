# 使用官方的 cuda 11.3.1 on Ubuntu 20.04 作为基础镜像
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# 设置默认时区
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 更换软件源
COPY ./scripts/sources.list /etc/apt/sources.list

# 安装基础依赖
RUN rm /etc/apt/sources.list.d/cuda.list \
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
    iputils-ping

# 设置 终端颜色和 ssh
COPY ./scripts/extra /tmp/extra
RUN cat /tmp/extra >> /etc/bash.bashrc \
  && echo "\
ListenAddress 0.0.0.0\n\
PermitRootLogin yes\n" >> /etc/ssh/sshd_config

# 设置Anaconda环境
ENV ANACONDA_VERSION 2023.07-0
# COPY ./scripts/Anaconda3-2023.07-0-Linux-x86_64.sh /Anaconda3-2023.07-0-Linux-x86_64.sh
RUN wget https://mirrors.njupt.edu.cn/anaconda/archive/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh && \
  bash Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -b -p /opt/anaconda && \
  rm Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh
ENV PATH /opt/anaconda/bin:$PATH

# 替换 conda 源和 pip 源
COPY ./scripts/.condarc /home/stu/.condarc
COPY ./scripts/.bashrc /home/stu/.bashrc
COPY ./scripts/.profile /home/stu/.profile
RUN conda init bash && pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 设置用户 stu
RUN useradd --create-home --no-log-init --shell /bin/bash stu \
	&& adduser stu sudo \
	&& echo 'stu:000000' | chpasswd

# 启动 vnc 以及 ssh
COPY ./scripts/xstartup /home/stu/.vnc/xstartup
COPY ./scripts/passwd /home/stu/.vnc/passwd

# 其他设置
ENV PATH /usr/local/cuda/bin:$PATH
COPY ./scripts/motd /etc/motd
COPY ./scripts/script.sh /usr/script.sh
RUN chmod +x /usr/script.sh /home/stu/.vnc/xstartup

# 设置用户 uid 以及 gid
COPY ./scripts/fixuid-0.6.0-linux-amd64.tar.gz /home/stu/fixuid.tar.gz
RUN USER=stu && \
	GROUP=sudo && \
	tar xzf /home/stu/fixuid.tar.gz -C /usr/local/bin && \
  rm /home/stu/fixuid.tar.gz && \
	chown root:root /usr/local/bin/fixuid && \
	chmod 4755 /usr/local/bin/fixuid && \
	mkdir -p /etc/fixuid && \
	printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml && \
  #  设置文件夹
  chown -R stu:sudo /home/stu

USER stu
# ENV PATH /opt/anaconda/bin:$PATH
CMD ["sh", "/usr/script.sh"]
ENTRYPOINT ["fixuid"]
WORKDIR /home/stu/workspace
