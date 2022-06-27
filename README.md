# 「作って学ぶコンピュータアーキテクチャ」 サポートページ

こちらは、技術評論社より出版されている「作って学ぶコンピュータアーキテクチャ ー LLVMとRISC-Vによる低レイヤプログラミングの基礎」 のサポートページです。

- 作って学ぶコンピュータアーキテクチャ —— LLVMとRISC-Vによる低レイヤプログラミングの基礎
  - 著者：木村優之
  - 発行：技術評論社 2022年7月1日
  - ISBN：978-4297129149


## 本書の実装を含んだLLVMリポジトリ

https://github.com/msyksphinz-self/llvm-project

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

## 本書のLLVMビルドブランチと対応するプロジェクトのリビジョン

LLVM12で確認を行っています。LLVM13、LLVM14でも同様のコミットメッセージでブランチを構築しています。

[本書で使用しているリポジトリのリビジョン](book_revision.md)

## 本書で使用しているテストプログラムのリポジトリ

本リポジトリを使ったビルドの確認方法は、READMEを参照してください。

https://github.com/msyksphinz-self/llvm-myriscvx-tests

## 付録PDF

- [付録1. 関数呼び出しのバリエーションと高度な機能(工事中)](advaced_func)
- [付録2. 浮動小数点命令(工事中)](fpu)

## 書籍に入り切らなかったあとがき

[あとがき](others.md)

## macOSでのビルド方法補足

macOSにおいてLLVMリポジトリをビルドする際、`SYSROOT`に設定しているCommand Line Tools for Xcodeのインストールが必要です。

```sh
$ xcode-select --install
```

また、本書に記載しているビルドコマンドを、以下のように置き換えることが推奨されます。`DEFAULT_SYSROOT`のオプションはXCodeのインストール先に応じて適宜変更してください。

```sh
cmake -G Ninja \
	-DCMAKE_OSX_ARCHITECTURES='arm64' \		# M1 Macの場合は本オプションを追加してください
	-DDEFAULT_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/ \
	-DCMAKE_BUILD_TYPE="Debug" \
	-DLLVM_TARGETS_TO_BUILD="host;AArch64;RISCV;MYRISCVX" \	# 本書ではx86としていますが、M1 Macの場合は"host"としてください
	-DLLVM_ENABLE_PROJECTS="clang;libcxx;libcxxabi" \
  ../llvm
```

