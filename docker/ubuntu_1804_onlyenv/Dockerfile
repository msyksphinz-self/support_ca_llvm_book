FROM msyksphinz/support_llvm:ubuntu_1804_base

WORKDIR /llvm_book

# ======================
# Make Appropriate Owner
# ======================
RUN addgroup --gid 1000 llvm-user && \
    adduser --uid 1000 --ingroup llvm-user --home /home/llvm-user --shell /bin/sh --disabled-password --gecos "" llvm-user

RUN USER=llvm-user && \
    GROUP=llvm-user && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

USER llvm-user:llvm-user
ENTRYPOINT ["fixuid"]
