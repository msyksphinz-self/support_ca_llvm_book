FROM ubuntu:18.04

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
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2021.03.06/riscv64-elf-ubuntu-18.04-nightly-2021.03.06-nightly.tar.gz   | tar xz
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2021.03.06/riscv64-glibc-ubuntu-18.04-nightly-2021.03.06-nightly.tar.gz | tar xz
RUN mv /llvm_book/riscv $RISCV

ENV PATH            $RISCV/bin:$PATH
ENV LD_LIBRARY_PATH $RISCV/lib:$LD_LIBRARY_PATH

RUN echo $(ls -lt /llvm_book/)
RUN echo $(ls -lt $RISCV/)

RUN apt install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev

WORKDIR /tmp
RUN git clone https://github.com/riscv/riscv-tools.git --recurse-submodules

WORKDIR /tmp/riscv-tools
RUN sed -i '/check_version automake/s/^/#/g' build.sh
RUN sed -i '/check_version autoconf/s/^/#/g' build.sh
RUN sed -i '/build_project riscv-openocd/s/^/#/g' build.sh
RUN sed -i '/build_project riscv-tests/s/^/#/g' build.sh
RUN  MAKEFLAGS="-j$(nproc)" ./build.sh

#
# Install Chipyard
#
WORKDIR /llvm_book
RUN git clone https://github.com/ucb-bar/chipyard.git -b 1.3.0
WORKDIR /llvm_book/chipyard

# Replace torture/env submodule command
RUN git submodule update --init --recursive generators/rocket-chip; exit 0  # Initially get error --> ignore
RUN sed -i "s/git:/https:/g" generators/rocket-chip/torture/.gitmodules
RUN git submodule sync --recursive
RUN ./scripts/init-submodules-no-riscv-tools.sh
Shell ["/bin/bash", "-c"]
# RUN MAKEFLAGS="-j$(nproc)" ./scripts/build-toolchains.sh riscv-tools
# RUN . ./env.sh
# ENV PATH            $RISCV/bin:$PATH
# ENV LD_LIBRARY_PATH $RISCV/lib:$LD_LIBRARY_PATH
# RUN MAKEFLAGS="-j$(nproc)" ./scripts/build-toolchains.sh ec2fast

# =================================
# Option : Make Rocket-Chip / BOOM
# =================================

# Install Verilator
WORKDIR /tmp/
RUN git clone http://git.veripool.org/git/verilator
WORKDIR /tmp/verilator
RUN git checkout v4.034
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
RUN apt install -y python3.6

WORKDIR /llvm_book/
RUN git clone https://github.com/msyksphinz-self/llvm-project.git -b llvm-myriscvx120 llvm-myriscvx120
WORKDIR /llvm_book/llvm-myriscvx120
RUN mkdir build
WORKDIR /llvm_book/llvm-myriscvx120/build
RUN cmake -G Ninja -DCMAKE_BUILD_TYPE="Debug" -DLLVM_TARGETS_TO_BUILD="host;RISCV;MYRISCVX" -DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi" ../llvm
RUN ninja
