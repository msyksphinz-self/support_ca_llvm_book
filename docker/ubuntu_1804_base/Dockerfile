FROM ubuntu:18.04

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
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2021.03.06/riscv64-elf-ubuntu-18.04-nightly-2021.03.06-nightly.tar.gz   | tar xz
RUN curl -L https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2021.03.06/riscv64-glibc-ubuntu-18.04-nightly-2021.03.06-nightly.tar.gz | tar xz
RUN mv /llvm_book/riscv $RISCV

# ENV PATH            $RISCV/bin:$PATH
# ENV LD_LIBRARY_PATH $RISCV/lib:$LD_LIBRARY_PATH

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
RUN git clone https://github.com/riscv/riscv-tools.git --recurse-submodules --depth 1

WORKDIR /tmp/riscv-tools
RUN sed -i '/check_version automake/s/^/#/g' build.sh
RUN sed -i '/check_version autoconf/s/^/#/g' build.sh
RUN sed -i '/build_project riscv-openocd/s/^/#/g' build.sh
RUN sed -i '/build_project riscv-tests/s/^/#/g' build.sh
RUN  MAKEFLAGS="-j$(nproc)" ./build.sh

# =================================
# Install Chipyard
# =================================
WORKDIR /llvm_book
RUN git clone https://github.com/ucb-bar/chipyard.git -b 1.3.0 --depth 1
WORKDIR /llvm_book/chipyard

# Replace torture/env submodule command
RUN git submodule update --init --recursive generators/rocket-chip; exit 0  # Initially get error --> ignore
RUN sed -i "s/git:/https:/g" generators/rocket-chip/torture/.gitmodules
RUN git submodule sync --recursive
RUN ./scripts/init-submodules-no-riscv-tools.sh
RUN sed -i 's/"${MAKE}" install/"${MAKE}" install\n"${MAKE}" clean/g' ./scripts/build-util.sh
RUN sed -i '/module_all qemu/d' ./scripts/build-toolchains.sh
RUN LD_LIBRARY_PATH="" ./scripts/build-toolchains.sh riscv-tools
Shell ["/bin/bash", "-c"]
RUN . ./env.sh
RUN . ./env-riscv-tools.sh

# =================================
# Option : Make Rocket-Chip / BOOM
# =================================

# Install Verilator
WORKDIR /tmp/
RUN git clone http://git.veripool.org/git/verilator --depth 1 -b v4.034
WORKDIR /tmp/verilator
RUN autoconf && ./configure && make -j$(nproc) && make install

WORKDIR /llvm_book/chipyard/
RUN . ./env.sh && . ./env-riscv-tools.sh && make -C ./sims/verilator CONFIG=RocketConfig
RUN . ./env.sh && . ./env-riscv-tools.sh && make -C ./sims/verilator CONFIG=MediumBoomConfig
