FROM ubuntu:22.04

ENV ROOT=/app
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR ${ROOT}

RUN unminimize

# パッケージ一覧の更新
RUN apt update

# HTTPS経由でリポジトリを使用できるようにするためのパッケージをインストール
RUN apt -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Docker公式のGPGキーを追加
RUN mkdir -m 0755 -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# リポジトリを設定
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# パッケージ一覧の更新
RUN apt update

# Docker EngineとDocker Composeのインストール
RUN apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# dockerを自動起動
RUN echo "service docker start" >> ~/.bashrc

RUN echo "alias ll='ls -la'" >> ~/.bashrc

CMD ["/bin/bash"]
