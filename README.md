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

## 本書のLLVMビルドブランチと対応するプロジェクトのリビジョン

LLVM12で確認を行っています。LLVM13、LLVM14でも同様のコミットメッセージでブランチを構築しています。

[本書で使用しているリポジトリのリビジョン](book_revision.md)

## 本書で使用しているテストプログラムのリポジトリ

本リポジトリを使ったビルドの確認方法は、READMEを参照してください。

https://github.com/msyksphinz-self/llvm-myriscvx-tests

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

- P.33 「メモリストア命令」
  - 誤: 「それぞれ32ビット、8ビット、16ビットのデータを読み出す例です」
  - 正: 「それぞれ32ビット、8ビット、16ビットのデータをメモリに書き込む例です」
  
- P.68 2段落目
  - 誤: Calle Saved
  - 正: Callee Saved
  
- P.71 riscv-toolsのビルド (https://github.com/msyksphinz-self/support_ca_llvm_book/issues/6)
  - 本書の確認した環境以外で、riscv-toolsがビルドに失敗することがあります。
  - riscv-toolsリポジトリ自体が古くなっており、個別にツール群をビルドする必要があります。
  - riscv-toolsからsubmoduleでリンクされているツールセットはdeprecatedされているようであり、各ツール群を個別にダウンロードしてビルドする必要があるようです。
    - riscv-isa-sim : https://github.com/riscv-software-src/riscv-isa-sim
    - riscv-tests : https://github.com/riscv-software-src/riscv-tests
    - riscv-pk : https://github.com/riscv-software-src/riscv-pk
  
- P.82 コマンド内:
  - 誤: `  -fno-builtin-printf -nostdlib -nostartfiles -lm -lgcc -T link.ld \`
  - 正: `  -fno-builtin-printf -nostdlib -nostartfiles -lm -lgcc -T test.ld \`
  
- P.102-P.103
  - LLVMビルド+アセンブリ生成がうまく行かない。
  - Issue: https://github.com/msyksphinz-self/support_ca_llvm_book/issues/1
  - ビルドオプションの変更が必要です。 https://github.com/msyksphinz-self/support_ca_llvm_book/issues/1 を参照ください。具体的には、以下のコマンドフローとなります。
    ```sh
    $ ${BUILD}/bin/clang-12 riscv_test.c -emit-llvm -c --target=riscv64-unknown-elf
    $ ${BUILD/build/bin/llc riscv_test.bc -march=riscv64 --float-abi=hard -mattr="+d,+f" -filetype=asm
    $ riscv64-unknown-elf-gcc riscv_test.s -march=rv64gc -lc -o riscv_test
    ```
  - これでも解決しない場合、`clang`のオプションに`--sysroot=`を追加して試行してください(https://github.com/msyksphinz-self/support_ca_llvm_book/issues/1#issuecomment-1186797222 にてご指摘いただきました。ありがとうございます)。
    ```sh
    $ ${BUILD}/bin/clang -emit-llvm -c riscv_test.c --target=riscv64-unknown-linux-gnu --sysroot=${HOME}/riscv64_github/sysroot
    $ ${BUILD}/bin/llc riscv_test.bc -march=riscv64 -mattr="+d,+f" -filetype=asm
    $ riscv64-unknown-linux-gnu-gcc riscv_test.s -lc -static -o riscv_test
    $ spike pk riscv_test
    ```

- P.195
  - 誤: `simple_test.ll`というファイルを作成します
  - 正: `simple_func.ll`というファイルを作成します
  - 誤: ソースコードのパス`llvm/test/CodeGen/MYRISCVX/simple_test.ll`
  - 正: ソースコードのパス`llvm/test/CodeGen/MYRISCVX/simple_func.ll`
  
- P.325

  - 誤: `R_MYRISCVX_LO12_I` / `R_MYRISCVX_LO12_`S / `R_MYRISCVX_PCREL_LO12_I` / `R_MYRISCVX_PCREL_LO12_S` の説明欄がすべて「上位12ビット」となっている
  - 正: 「下位12ビット」
  - 誤: `R_MYRISCVX_PCREL_LO12_I`と`R_MYRISCVX_PCREL_LO12_S`の説明欄が「絶対アドレスの上位12ビット」となっている
  - 正: 「PC相対アドレスの下位12ビット」
  
- P.333

  - 誤: `static`ポリシかつ`medlow`コードモデルの際、LLVMで出力したものをgccの結果と比較する際に`objdump`したコードが、`static`ポリシかつ`medany`のものになっています。

    - `auipc`命令などが使用されていますが、これは`medany`コードモデルのものです。

  - 正しくは以下のようになります。

  - ```
    0000000000000000 <update_global>:
       0:   00000537                lui     a0,0x0
                            0: R_RISCV_HI20 global_val
                            0: R_RISCV_RELAX        *ABS*
       4:   00050513                mv      a0,a0
                            4: R_RISCV_LO12_I       global_val
                            4: R_RISCV_RELAX        *ABS*
       8:   00052583                lw      a1,0(a0) # 0 <update_global>
       c:   00158593                addi    a1,a1,1
      10:   00b52023                sw      a1,0(a0)
      14:   00008067                ret
    ```

- P.513
  - 誤: ソースコードのパス`llvm-myriscvx120/test/CodeGen/RISCV`
  - 正: ソースコードのパス`llvm-myriscvx120/llvm/test/CodeGen/RISCV`



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
