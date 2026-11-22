ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION} AS dev

ARG GCC_VERSION=12
ARG CLANG_VERSION=12

ENV LANG=C.UTF-8 \
	LC_ALL=C.UTF-8

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	ca-certificates \
	curl \
	wget \
	git \
	zsh \
	vim \
	nano \
	less \
	file \
	tree \
	iproute2 \
	build-essential \
	"gcc-${GCC_VERSION}" \
	"g++-${GCC_VERSION}" \
	"clang-${CLANG_VERSION}" \
	cmake \
	pkg-config \
	libreadline-dev \
	libncurses-dev \
	gdb \
	valgrind \
	strace \
	python3 \
	python3-venv \
	jq \
	unzip \
	zip \
	&& rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install \
	/usr/bin/gcc gcc "/usr/bin/gcc-${GCC_VERSION}" 120 \
	&& update-alternatives --install \
	/usr/bin/g++ g++ "/usr/bin/g++-${GCC_VERSION}" 120

COPY install-norminette.sh /tmp/install-norminette.sh

ARG NORMINETTE_VERSION=3.3.60
RUN bash /tmp/install-norminette.sh "${NORMINETTE_VERSION}" \
	&& rm /tmp/install-norminette.sh

WORKDIR /workspace

CMD ["/bin/bash"]

FROM dev AS codex

ARG NODE_MAJOR=22
ARG CODEX_VERSION=0.171.0

RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash - \
	&& apt-get install -y --no-install-recommends nodejs \
	&& npm install -g "@openai/codex@${CODEX_VERSION}" \
	&& rm -rf /var/lib/apt/lists/*
