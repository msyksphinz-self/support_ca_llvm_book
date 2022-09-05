# Dockerイメージ`ubuntu_2204`

- Ubuntu 22.04の環境を使用し、新しいRISC-Vツールを使用したDocker環境です
- 本書で説明している実行コマンド列と大きく異なっている場所があります
- ビルド済みのサンプルLLVMリポジトリも含んでいます
- 本書の環境をステップバイステップで追いかけるのではなく、最終的なバイナリのみ必要な方向けです

Dockerイメージは、以下に格納されています。

https://hub.docker.com/repository/docker/msyksphinz/support_llvm

`msyksphinz/support_llvm/ubuntu_2204`が当該Dockerイメージとなります。

## Dockerイメージの概要

- Ubuntu 22.04 LTSを使用しています
- ツールチェインはゲストマシンの`/llvm_book`に展開されます
- RISC-V GNU Toolchainは2022.08.08のものを自動的にダウンロードして展開しています
  - https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2022.08.08/
- riscv-toolsは、以下のサブリポジトリを、個々のGitHubリポジトリから最新版を取得してビルドしています
  - https://github.com/riscv-software-src/riscv-isa-sim.git
  - https://github.com/riscv-software-src/riscv-pk.git
  - https://github.com/riscv-software-src/riscv-tests.git
- Chipyard RTL実行環境は 1.7.1をダウンロードし、BOOMとRocketをあらかじめビルドしてあります
  - `/llvm_book/chipyard/sims/verilator`に、Chipyardのビルド済みバイナリを格納しています
- LLVM作業用リポジトリは`/llvm_book`にダウンロードし、ビルド済みです
  - バイナリ生成済みですので、すぐにテストやRTLシミュレーションを実行することができます




## 実行手順

1. 作業ディレクトリにおいて、以下のスクリプトをダウンロードします。

```sh
$ cd llvm_work  # ホスト作業環境
$ wget https://raw.githubusercontent.com/msyksphinz-self/support_ca_llvm_book/main/docker/ubuntu_2204/work/run.sh
```

2. `run.sh`を実行します。これにより、Dockerイメージのダウンロードと、Dockerコンテナの立ち上げとログインが行われます。

```sh
$ chmod +x ./run.sh
$ ./run.sh
```

LLVMリポジトリは、ゲストマシン内の`/llvm_book/llvm-project`にダウンロードされています。コンテナ容量削減のためビルドは行っていませんが、本書に記載している手順でビルド可能です。



