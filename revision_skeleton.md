- 第4章：「LLVMバックエンドの仕組み」

  - P.123「LLVMのバックエンドを作るための第一歩」「LLVMをビルドして確認する」
      - revision:Initial registration of MYRISCVX
      - `Initial registration of MYRISCVX`
      - ビルド方法は書籍の通り。確認方法(M1 Macでの実行結果)

      ```sh
      $ ./bin/llc --version
      LLVM (http://llvm.org/):
        LLVM version 12.0.1
        DEBUG build with assertions.
        Default target: arm64-apple-darwin21.5.0
        Host CPU: cyclone

        Registered Targets:
          aarch64    - AArch64 (little endian)
          aarch64_32 - AArch64 (little endian ILP32)
          aarch64_be - AArch64 (big endian)
          arm64      - ARM64 (little endian)
          arm64_32   - ARM64 (little endian ILP32)
          myriscvx32 - MYRISCVX (32-bit)
          myriscvx64 - MYRISCVX (64-bit)
          riscv32    - 32-bit RISC-V
          riscv64    - 64-bit RISC-V
      ```


  - P.158「ターゲット記述ファイル(tdファイル)の作成」「LLVMをビルドして確認する」
      - revision:Add MCTargetDesc/MYRISCVXTargetStreamer
      - `Add MCTargetDesc/MYRISCVXTargetStreamer`
      - コンパイル手順

      ```sh
      $ cd chapter04/
      $ make simple_func
      ```

- 第5章：「簡単な関数や演算のサポート」

  - P.194「シンプルな関数をコンパイルできるようにする」「コンパイルと確認」
      - revision:TestPattern: Add zero_return.ll in CodeGen
      - `TestPattern: Add zero_return.ll in CodeGen`
      - コンパイル手順

      ```sh
      $ cd chapter04/
      $ make simple_func	# P.158と同一コマンドですが、アセンブリファイル内にretが出力されているはずです。
      ```

      ```sh
      # LLVMビルドディレクトリ内にて
      $ ./bin/llvm-lit ../llvm/test/CodeGen/MYRISCVX/
      ```



  - P.213「関数が戻り値を返せるようにする」「LLVMのビルドとテスト」
    - revision:TestPattern: Update zero_return.ll
    - `TestPattern: Update zero_return.ll`
    - コンパイル手順

    ```sh
    # constant2.llを使ったテスト
    $ ./bin/llvm-lit ../llvm/test/CodeGen/MYRISCVX/constants2.ll

    # value_return.cのテスト
    $ cd chapter05
    $ make value_return
    ```



  - P.227「関数のプロローグ・エピローグに必要な新規命令の実装」「ロード・ストア命令の生成を確かめる」
    - revision:Implement Memory Access Instructions
    - `Implement Memory Access Instructions`
    - コンパイル手順

    ```sh
    $ cd chapter05
    $ make mem_access
    ```



  - P.243「関数のプロローグ・エピローグの実装」「スタックフレーム生成の様子を観察する」
    - revision:TestPattern: function arguments
    - `TestPattern: function arguments`
    - 注意：このコミットの時点では、`func_arg.c`の`myriscvx64`でのコンパイルは、算術演算命令の定義不足のためコンパイルできません。
    - コンパイル手順

    ```sh
    $ cd chapter05
    $ make func_arg
    ```



  - P.245「引数の受け取りを確認する」
    - revision:TestPattern: function arguments
    - `TestPattern: function arguments`
    - 注意：このコミットの時点では、`func_argument.c`の`myriscvx64`でのコンパイルは、算術演算命令の定義不足のためコンパイルできません。
    - コンパイル手順

    ```sh
    $ cd chapter05
    $ make func_arguments
    ```



- 第6章：「算術演算・グローバル変数・ポインタ・制御構文のサポート」
  - P.269「算術・論理・比較命令の生成」「ここまでの実装をコンパイルしてテストする」
    - revision:Implement Arithmetic Instructions
    - `Implement Arithmetic Instructions`

  - P.274「RV64のみで定義されている算術命令を追加する」「ここまでの実装をコンパイルしてテストする」
    - revision:Add 32-bit instructions for RV64
    - `Add 32-bit instructions for RV64`

    - 注：Clangが生成するLLVM IRが変更され、現在の実装ではADDIW命令を想定通り生成することが出来ません。原因は引数の仕様変更です。
      - 想定していたLLVM IR

      ```
      define dso_local signext i32 @add_int(i32 signext %arg1, signext i32 %arg2) local_unnamed_addr #0 {
      ```

      - Clang-12にて生成されているLLVM IR

      ```
      define dso_local i32 @add_int(i32 %arg1, i32 %arg2) local_unnamed_addr #0 {
      ```

      またClang-14では、引数として`noundef`属性が付けられるようになっており、本書が想定した命令が正しく出力できない状態になっています。

      とりあえずADDIW等の32ビット命令を生成のみを確認したい場合、LLVM IRの引数に`signext`属性を付けてテストしてください。

      テストディレクトリでは、すべて`signext`属性を付加した上で生成を確認しています。

      - `llvm-myriscvx120/llvm/test/CodeGen/MYRISCVX/arith_32bit_rv64.ll`

      ```
      define dso_local signext i32 @add32(i32 signext %a, i32 signext %b) local_unnamed_addr #0 {

      ; MYRVX64I-LABEL: add32:
      ; MYRVX64I:       # %bb.0:
      ; MYRVX64I-NEXT:        addw    x10, x11, x10
      ; MYRVX64I-NEXT:        ret

      entry:
        %add = add nsw i32 %b, %a
        ret i32 %add
      }
      ```



  - P.279：「マイナス値、大きな値のコンパイルテスト」
    - revision:TestPattern: add long_value.ll
    - `TestPattern: add long_value.ll`

  - P.284「比較命令のコンパイルテスト」
    - `TestPattern: Add compare_slt.ll`
    - `TestPattern: Add compare_slt.ll`
    - コンパイル手順
    ```sh
    $ cd program/chapter06
    $ make compare_slt
    ```

  - P.290「ローテート操作をコンパイルする」
    - revision:TestPattern: Add rotate.ll
    - `TestPattern: Add rotate.ll`
    - コンパイル手順

    ```sh
    $ cd program/chapter06
    $ make rotate_test
    ```



  - P.333「グローバル変数のサポート」「LLVMをコンパイルしてテストする」
    - revision:TestPattern: Add global_variable.static.ll & global_variable.pic.ll
    - `TestPattern: Add global_variable.static.ll & global_variable.pic.ll`
    - コンパイル手順

    ```sh
    $ cd program/chapter06
    $ make global_variable
    ```

  - P.339「ポインタを扱う命令のLLVM動作確認」

    - revision:TestPattern: add load_pointer.static.ll & load_pointer.pic.ll
    - `TestPattern: add load_pointer.static.ll & load_pointer.pic.ll`

    - コンパイル手順

    ```sh
    $ cd program/chapter06
    $ make local_pointer
    ```



  - P.341「ポインタ・配列・構造体のサポート」「配列のサポートの確認」

    - revision:TestPattern: add int_array.static.ll & int_array.pic.ll
    - `TestPattern: add int_array.static.ll & int_array.pic.ll`

    - Clangの最適化が進み本書で示しているコードではコンパイルに成功しません(`memcpy`が生成されるようです)

    - `int_array.c`を以下のように置き換えてください(配列をvolatileにして、最適化を防いでいます)

    - ```cpp
      int int_array()
      {
        volatile int array[4] = {100, 200, 300, 400};

        int a = array[0];
        int b = array[1];
        array[2] = 301;

        return 0;
      }
      ```

    - コンパイル手順

    ```sh
    $ cd program/chapter06
    $ make int_array
    # ${BUILD}/bin/clang-12 -O3  int_array.c -c -emit-llvm -o int_array.riscv32.static.bc
    # ${BULID}/bin/llc -march=myriscvx32  \
    #	-disable-tail-calls "--debug" \
    #	-relocation-model=static \
    #	-filetype=asm int_array.riscv32.static.bc \
    #	-o int_array.myriscvx32.static.S     \
    # > int_array.myriscvx32.static.asm.log
    ```



  - P.345「構造体のサポートの確認」

    - revision:TestPattern: add struct_char.static.ll & struct_pattern_match.static.ll
    - `TestPattern: add struct_char.static.ll & struct_pattern_match.static.ll`

    - `if`文が入っており、現在のままではコンパイルに成功しません。
    - また、Clangの最適化が進み本書で示しているコードではコンパイルに成功しません(`memcpy`が生成されるようです)
    - `struct_student.c`を以下のように置き換えてください(配列をvolatileにして、最適化を防いでいます)

    ```cpp
    struct Student
    {
      int no;
      char name[20];
      unsigned int score;
    };


    int update_score (int student_no, int score)
    {
      volatile struct Student taro = {32, "Taro Yamada", 95};
      int no = taro.no; // Dummy code

      taro.score += score; // Update struct.score

      return taro.score;
    }
    ```

    - コンパイル手順

    ```sh
    $ cd program/chapter06
    $ make struct_student
    ```

  - P.369「条件分岐や繰り返しの生成」「LLVMのビルドと確認」

    - revision:Implement Jump and Branch Instructions
    - `Implement Jump and Branch Instructions`

    - コンパイル手順

    ```sh
    $ cd program/chapter06
    $ make cond_if
    ```



  - P.380「条件分岐や繰り返しの生成」「三項演算子をサポートするためのLLVM実装」「LLVMのビルドと確認」

    - revision:Implement Ternary operator
    - `Implement Ternary operator`

    - コンパイル手順

    ```sh
    $ cd program/chapter06
    $ make simple_select_exp
    ```



  - P.383「条件分岐や繰り返しの生成」「switch文のサポート」「LLVMのビルドと確認」

    - revision:Implement Switch operations
    - `Implement Switch operations`

    - コンパイル手順

    ```sh
    $ cd program/chapter06
    $ make switch_table
    ```



  - P.404「関数呼び出しのサポート」「LLVMのビルドと確認」

    - revision:Implement callPtrInfo
    - `Implement callPtrInfo`

    - コンパイル手順

    ```sh
    $ cd program/chapter06
    $ make caller_callee
    ```



- 第7章「オブジェクトファイル・ELFファイルのサポート」
    - P.462「LLVMでオブジェクトファイルを生成する」
      - revision:TestPattern: Update test pattern for split LLA/LA
      - `TestPattern: Update test pattern for split LLA/LA`

      - コンパイル手順

      ```sh
      $ cd program/chapter07
      $ make objeect_sample
      ```

      ここまでのコンパイルでは、以下のコマンドでエラーが出ますが、MCがMYRISCVXをサポートしていないためです。問題はありません。

      ```
      ${BUILD}/bin/llvm-mc --arch=myriscvx32 --debug object_sample.myriscvx32.static.S -o object_sample.myriscvx32.static.mc.o > object_sample.myriscvx32.static.mc.o.log 2>&1
      make: *** [Makefile:79: object_sample.myriscvx32.static.mc.o] Error 1
      ```


    - P.483「アセンブリ命令による確認」

        - revision:Add MYRISCVXAsmParser
        - `Add MYRISCVXAsmParser`

        - コンパイル手順

        ```sh
        $ cd program/chapter07
        $ make assembly_test
        ```


    - P.493「疑似命令の生成確認」
        - revision:TestPattern: add myriscvx32i-valid.s & myriscvx64i-valid.s
        - `TestPattern: add myriscvx32i-valid.s & myriscvx64i-valid.s`

        - コンパイル手順

        ```sh
        $ cd program/chapter07
        $ make pseudo_inst
        ```
    - P.496「インラインアセンブリの動作確認」
        - revision:Add CSR instructions
        - `Add CSR instructions`

        - コンパイル手順

        ```sh
        $ cd program/chapter07
        $ make inline_assembly
        ```
