# 「作って学ぶコンピュータアーキテクチャ」 サポートページ

こちらは、技術評論社より出版されている「作って学ぶコンピュータアーキテクチャ ー LLVMとRISC-Vによる低レイヤプログラミングの基礎」 のサポートページです。

- 作って学ぶコンピュータアーキテクチャ —— LLVMとRISC-Vによる低レイヤプログラミングの基礎
  - 著者：木村優之
  - 発行：技術評論社 2022年7月1日
  - ISBN：978-4297129149

## 本書の実装を含んだLLVMリポジトリ

書籍の解説ではLLVM実装の一部のみを抜粋して掲載しているため、ビルドおよびテストを行いたい場合、
以下のLLVMブランチで完全なソースコードを参照していただきますよう、お願いいたします。

本書でサポートしているのは以下の`llvm-myriscvx120`ブランチです。

https://github.com/msyksphinz-self/llvm-project/tree/llvm-myriscvx120

### 実行方法

```sh
git clone https://github.com/msyksphinz-self/llvm-project.git -b llvm-myriscvx120
```

LLVM13ベース、LLVM14ベースでもビルド・テストの成功は確認しています。ただし本文で解説しているコードと若干異なる場所があるのでご注意ください。

```sh
## LLVM13ベースでの開発ブランチ
git clone https://github.com/msyksphinz-self/llvm-project.git -b llvm-myriscvx130

## LLVM14ベースでの開発ブランチ
git clone https://github.com/msyksphinz-self/llvm-project.git -b llvm-myriscvx140
```

- [LLVM15をベースとしたブランチについて](llvm15.md)


## 本書のLLVMビルドブランチと対応するプロジェクトのリビジョン

LLVM12で確認を行っています。LLVM13、LLVM14でも同様のコミットメッセージでブランチを構築しています。

[本書で使用しているリポジトリのリビジョン](book_revision.md)

## 本書で使用しているテストプログラムのリポジトリ

本リポジトリを使ったビルドの確認方法は、READMEを参照してください。

https://github.com/msyksphinz-self/llvm-myriscvx-tests

## 本書の環境を含んだDockerコンテナ

[本書の環境を含んだDockerコンテナ](docker/README.md)をリリースします。

## LLVMビルド時の推奨オプション

本文では記載抜けしていましたが、RISC-Vビルドでの各種ライブラリ(`printf()`など)を扱うために`-DDEFAULT_SYSROOT=`オプションを適切に設定することが推奨されます。具体的には、以下のように`-DDEFAULT_SYSROOT`オプションを追加して、P.70にてツールチェインのインストール場所として使用している` ${HOME}/riscv64_github`を適宜読み替えてください。

なお、P.96のx86(ホスト)用にビルドする際は`DEFAULT_SYSROOT`の設定は不要です。

```sh
cmake -G Ninja \
	-DDEFAULT_SYSROOT=${HOME}/riscv_github/riscv64-unknown-elf \	# RISC-V向けビルド時。ここの部分
	-DCMAKE_BUILD_TYPE="Debug" \
	-DLLVM_TARGETS_TO_BUILD="X86;AArch64;RISCV;MYRISCVX" \
	-DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi" \
  ../llvm
```

## 正誤表

[正誤表](errata.md)はこちらに移動しました。

## 付録PDF

- [付録1. 関数呼び出しのバリエーションと高度な機能](appendix/advanced_func.pdf)
- [付録2. 浮動小数点命令](appendix/fpu.pdf)

## 書籍に入り切らなかったあとがき

[あとがき](others.md)

## macOSでのビルド方法補足

macOSにおいてLLVMリポジトリをビルドする際、`SYSROOT`に設定しているCommand Line Tools for Xcodeのインストールが必要です。

```sh
$ xcode-select --install
```

また、本書に記載しているビルドコマンドを、以下のように置き換えることが推奨されます。`DEFAULT_SYSROOT`のオプションはXCodeのインストール先に応じて適宜変更してください。

- ホスト(非RISC-V)向けビルド時 (P.96)のコマンド実行時

```sh
cmake -G Ninja \
	-DCMAKE_OSX_ARCHITECTURES='arm64' \		# M1 Macの場合は本オプションを追加してください
	-DDEFAULT_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/ \
	-DCMAKE_BUILD_TYPE="Debug" \
	-DLLVM_TARGETS_TO_BUILD="host;AArch64;RISCV;MYRISCVX" \	# 本書ではx86としていますが、M1 Macの場合は"host"としてください
	-DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi" \
  ../llvm
```

- RISC-V向けビルド実行時

```sh
cmake -G Ninja \
	-DCMAKE_OSX_ARCHITECTURES='arm64' \		# M1 Macの場合は本オプションを追加してください
	-DDEFAULT_SYSROOT=${HOME}/riscv_github/riscv64-unknown-elf \
	-DCMAKE_BUILD_TYPE="Debug" \
	-DLLVM_TARGETS_TO_BUILD="host;AArch64;RISCV;MYRISCVX" \	# 本書ではx86としていますが、M1 Macの場合は"host"としてください
	-DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi" \
  ../llvm
```
