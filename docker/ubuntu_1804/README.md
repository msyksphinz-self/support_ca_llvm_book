# Dockerイメージ`ubuntu_1804`

- Ubuntu 18.04の環境を使用し、本書で説明した環境とツールを可能な限り再現しています
- 動作しなくなっている場所が複数あるため、コマンドにいくつか修正を加えています
- 本書では18.10を使用しましたが、LTSではないためサポートが切れており18.04LTSを代わりに使用しています
- ビルド済みのサンプルLLVMリポジトリも含んでいます
- 本書の環境をステップバイステップで追いかけるのではなく、最終的なバイナリのみ必要な方向けです

Dockerイメージは、以下に格納されています。

https://hub.docker.com/repository/docker/msyksphinz/support_llvm

`msyksphinz/support_llvm/ubuntu_1804`が当該Dockerイメージとなります。

## Dockerイメージの概要

- Ubuntu 18.04 LTSを使用しています
- ツールチェインはゲストマシンの`/llvm_book`に展開されます
- RISC-V GNU Toolchainは2021.03.06のものを自動的にダウンロードして展開しています
  -  https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/2021.03.06/
- riscv-toolsは、オリジナルのリポジトリをダウンロードした後で、いくつか改変してコンパイルが通るように修正しています
  - https://github.com/riscv-software-src/riscv-tools.git
- Chipyard RTL実行環境は 1.3.0をダウンロードし、BOOMとRocketをあらかじめビルドしてあります
  - `/llvm_book/chipyard/sims/verilator`に、Chipyardのビルド済みバイナリを格納しています
- LLVM作業用リポジトリは`/llvm_book`にダウンロードし、ビルド済みです
  - バイナリ生成済みですので、すぐにテストやRTLシミュレーションを実行することができます



## 実行手順

1. 作業ディレクトリにおいて、以下のスクリプトをダウンロードします。

```sh
$ cd llvm_work  # ホスト作業環境
$ wget https://raw.githubusercontent.com/msyksphinz-self/support_ca_llvm_book/main/docker/ubuntu_1804/work/run.sh
```

2. `run.sh`を実行します。これにより、Dockerイメージのダウンロードと、Dockerコンテナの立ち上げとログインが行われます。

```sh
$ chmod +x ./run.sh
$ ./run.sh
```

LLVMリポジトリは、ゲストマシン内の`/llvm_book/llvm-project`にダウンロードされており、ビルド済みです。



