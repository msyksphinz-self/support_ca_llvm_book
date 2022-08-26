FROM ubuntu:22.04

RUN apt update
RUN apt install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

RUN apt install -y git

ENV RISCV /llvm_book/riscv64_github

# WORKDIR /tmp
# RUN git clone https://github.com/riscv/riscv-gnu-toolchain --depth 1 -b 2021.01.26
# WORKDIR /tmp/riscv-gnu-toolchain
# RUN mkdir build
# WORKDIR /tmp/riscv-gnu-toolchain/build
# RUN ../configure --prefix=$RISCV
# RUN make -j$(nproc)

WORKDIR /llvm_book/
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2022.08.08/riscv64-elf-ubuntu-20.04-nightly-2022.08.08-nightly.tar.gz   | tar xz
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2022.08.08/riscv64-glibc-ubuntu-20.04-nightly-2022.08.08-nightly.tar.gz | tar xz
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2022.08.08/riscv64-musl-ubuntu-20.04-nightly-2022.08.08-nightly.tar.gz  | tar xz
RUN mv /llvm_book/riscv $RISCV

ENV PATH            $RISCV/bin:$PATH
ENV LD_LIBRARY_PATH $RISCV/lib:$LD_LIBRARY_PATH

RUN apt install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev

WORKDIR /tmp
RUN git clone https://github.com/riscv-software-src/riscv-isa-sim.git --recurse-submodules && \
    cd riscv-isa-sim && \
    ./configure --prefix=$RISCV && \
    make -j$(nproc) && \
    make install

RUN git clone https://github.com/riscv-software-src/riscv-pk.git --recurse-submodules && \
    cd riscv-pk && \
    mkdir -p build && \
    cd build && \
    ../configure --prefix=$RISCV --host riscv64-unknown-elf && \
    make -j$(nproc) && \
    make install

# =================================
# Install Chipyard
# =================================
WORKDIR /llvm_book
RUN git clone https://github.com/ucb-bar/chipyard.git -b 1.7.1
WORKDIR /llvm_book/chipyard

RUN ./scripts/init-submodules-no-riscv-tools.sh
Shell ["/bin/bash", "-c"]
RUN . ./env.sh
# ENV PATH            $RISCV/bin:$PATH
# ENV LD_LIBRARY_PATH $RISCV/lib:$LD_LIBRARY_PATH
# RUN git config --global http.postBuffer 10485760000
# RUN apt install -y git perl python3
# RUN MAKEFLAGS="-j$(nproc)" ./scripts/build-toolchains.sh riscv-tools

# =================================
# Option : Make Rocket-Chip / BOOM
# =================================

RUN apt install -y git perl python3 make autoconf g++ flex bison ccache
RUN apt install -y libgoogle-perftools-dev numactl perl-doc
RUN apt install -y libfl2  # Ubuntu only (ignore if gives error)
RUN apt install -y libfl-dev  # Ubuntu only (ignore if gives error)

# Install Verilator
WORKDIR /tmp/
RUN git clone http://git.veripool.org/git/verilator
WORKDIR /tmp/verilator
RUN git checkout v4.224
RUN autoconf && ./configure && make -j$(nproc) && make install

RUN apt install -y libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev vim default-jdk default-jre

# install sbt: https://www.scala-sbt.org/release/docs/Installing-sbt-on-Linux.html#Ubuntu+and+other+Debian-based+distributions
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt update

RUN apt install -y sbt
RUN apt install -y texinfo gengetopt
RUN apt install -y libexpat1-dev libusb-dev libncurses5-dev cmake
WORKDIR /llvm_book/chipyard/sims/verilator
RUN make CONFIG=RocketConfig
RUN make CONFIG=MediumBoomConfig

# =================================
# Download and Build LLVM
# =================================

# CMake Latest version install
# Install newer CMake manually
WORKDIR /llvm_book/
RUN curl -L https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0.tar.gz | tar xz
WORKDIR /llvm_book/cmake-3.24.0
RUN ./bootstrap -- -DCMAKE_USE_OPENSSL=OFF && make -j$(nproc)
RUN make install
ENV PATH /llvm_book/cmake-3.24.0/bin/:$PATH

RUN apt install -y ninja-build

WORKDIR /llvm_book/
RUN git clone https://github.com/msyksphinz-self/llvm-project.git -b llvm-myriscvx120 llvm-myriscvx120
WORKDIR /llvm_book/llvm-myriscvx120
RUN mkdir build
WORKDIR /llvm_book/llvm-myriscvx120/build
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE="Debug" -DLLVM_TARGETS_TO_BUILD="host;RISCV;MYRISCVX" -DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi" ../llvm
RUN ninja
