# Dockerイメージ`ubuntu_2204_onlyenv`

- Ubuntu 22.04の環境を使用し、新しいRISC-Vツールを使用したDocker環境です
- 本書で説明している実行コマンド列と大きく異なっている場所があります
- LLVMリポジトリは、Docker外部にダウンロードして、内部の環境と共有します
- 本書の環境をステップバイステップで追いかける方向けです

Dockerイメージは、以下に格納されています。

https://hub.docker.com/repository/docker/msyksphinz/support_llvm

`msyksphinz/support_llvm/ubuntu_onlyenv`が当該Dockerイメージとなります。

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
- LLVM作業用リポジトリはゲストマシンの外部にダウンロードし、共有しています
  - これにより、LLVMリポジトリでの作業内容やビルドバイナリはホストマシンから確認することができます



## 実行手順

1. 作業ディレクトリにおいて、以下のスクリプトをダウンロードします。

```sh
$ cd llvm_work  # ホスト作業環境
$ wget https://raw.githubusercontent.com/msyksphinz-self/support_ca_llvm_book/main/docker/ubuntu_2204_onlyenv/work/make_env.sh
$ wget https://raw.githubusercontent.com/msyksphinz-self/support_ca_llvm_book/main/docker/ubuntu_2204_onlyenv/work/run.sh
```

2. 最初にDockerイメージを立ち上げる前に一度だけ、`make_env.sh`を実行します。

```sh
$ chmod +x ./make_env.sh
$ ./make_env.sh    # .envが作られる
```

3. `run.sh`を実行します。これにより、Dockerイメージのダウンロードと(初回にのみ)LLVMリポジトリのダウンロードが行われ、Dockerコンテナの立ち上げとログインが行われます。

```sh
$ chmod +x ./run.sh
$ ./run.sh
```

`llvm-project`ディレクトリはホストマシンの同じ場所にダウンロードされ、ゲストマシンの`/llvm-project`にマウントされます。これにより、ゲストマシンの`/llvm-project/`で行われた作業やビルドはホストマシンの`llvm-project`から参照可能となります。

