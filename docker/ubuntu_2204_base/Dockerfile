FROM ubuntu:22.04

# -----------------------------
# Ubuntu Package Update
# -----------------------------
RUN apt update
RUN apt install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
RUN apt install -y git perl python3 make autoconf g++ flex bison ccache gengetopt device-tree-compiler
RUN apt install -y libgoogle-perftools-dev numactl perl-doc
RUN apt install -y libfl2  # Ubuntu only (ignore if gives error)
RUN apt install -y libfl-dev  # Ubuntu only (ignore if gives error)
RUN apt install -y libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev vim default-jdk default-jre
RUN apt install -y libexpat1-dev libusb-dev libusb-1.0-0-dev libncurses5-dev
RUN apt install -y ninja-build

# install sbt: https://www.scala-sbt.org/release/docs/Installing-sbt-on-Linux.html#Ubuntu+and+other+Debian-based+distributions
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt update
RUN apt install -y sbt

ENV RISCV /llvm_book/riscv64_github

# -----------------------------
# RISC-V GNUTools Install
# -----------------------------
WORKDIR /llvm_book/
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2022.08.08/riscv64-elf-ubuntu-20.04-nightly-2022.08.08-nightly.tar.gz   | tar xz
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2022.08.08/riscv64-glibc-ubuntu-20.04-nightly-2022.08.08-nightly.tar.gz | tar xz
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2022.08.08/riscv64-musl-ubuntu-20.04-nightly-2022.08.08-nightly.tar.gz  | tar xz
RUN mv /llvm_book/riscv $RISCV

ENV PATH            $RISCV/bin:$PATH
ENV LD_LIBRARY_PATH $RISCV/lib:$LD_LIBRARY_PATH

# -----------------------------
# CMake Latest version install
# Install newer CMake manually
# -----------------------------
WORKDIR /llvm_book/
RUN curl -L https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0.tar.gz | tar xz
WORKDIR /llvm_book/cmake-3.24.0
RUN ./bootstrap -- -DCMAKE_USE_OPENSSL=OFF && make -j$(nproc)
RUN make install
ENV PATH /llvm_book/cmake-3.24.0/bin/:$PATH

# ---------------------------------
# RISC-V tools (spike / pk) install
# ---------------------------------
WORKDIR /tmp
RUN git clone https://github.com/riscv-software-src/riscv-isa-sim.git --recurse-submodules --depth 1 && \
    cd riscv-isa-sim && \
    ./configure --prefix=$RISCV && \
    make -j$(nproc) && \
    make install

RUN git clone https://github.com/riscv-software-src/riscv-pk.git --recurse-submodules --depth 1 && \
    cd riscv-pk && \
    mkdir -p build && \
    cd build && \
    ../configure --prefix=$RISCV --host riscv64-unknown-elf && \
    make -j$(nproc) && \
    make install

RUN git clone https://github.com/riscv-software-src/riscv-tests.git --recurse-submodules --depth 1 && \
    cd riscv-tests && \
    mkdir -p build && \
    cd build && \
    ../configure --prefix=$RISCV && \
    make -j$(nproc) && \
    make install

# =================================
# Install Chipyard
# =================================
WORKDIR /llvm_book
RUN git clone https://github.com/ucb-bar/chipyard.git -b 1.7.1 --depth 1
WORKDIR /llvm_book/chipyard

RUN ./scripts/init-submodules-no-riscv-tools.sh
RUN sed -i '/riscv-isa-sim\/build\/libfesvr.a/d' ./scripts/build-toolchains.sh
RUN LD_LIBRARY_PATH="" ./scripts/build-toolchains.sh riscv-tools --ignore-qemu --clean-after-install
Shell ["/bin/bash", "-c"]
RUN . ./env.sh

# =================================
# Option : Make Rocket-Chip / BOOM
# =================================

# Install Verilator
WORKDIR /tmp/
RUN git clone http://git.veripool.org/git/verilator -b v4.224 --depth 1
WORKDIR /tmp/verilator
RUN autoconf && ./configure && make -j$(nproc) && make install

WORKDIR /llvm_book/chipyard/
RUN . ./env.sh && . ./env-riscv-tools.sh && make -C ./sims/verilator CONFIG=RocketConfig
RUN . ./env.sh && . ./env-riscv-tools.sh && make -C ./sims/verilator CONFIG=MediumBoomConfig

RUN rm -rf /tmp/*
