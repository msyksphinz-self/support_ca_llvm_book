FROM msyksphinz/support_llvm:ubuntu_1804_base

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
RUN git clone https://github.com/msyksphinz-self/llvm-project.git -b llvm-myriscvx120 llvm-myriscvx120 --depth 1
WORKDIR /llvm_book/llvm-myriscvx120
# RUN mkdir build
# WORKDIR /llvm_book/llvm-myriscvx120/build
# RUN cmake -G Ninja -DLLVM_PARALLEL_LINK_JOBS=2 -DLLVM_PARALLEL_COMPILE_JOBS=4 -DCMAKE_BUILD_TYPE="Debug" -DLLVM_TARGETS_TO_BUILD="host;RISCV;MYRISCVX" -DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi" ../llvm
# RUN ninja -j1
