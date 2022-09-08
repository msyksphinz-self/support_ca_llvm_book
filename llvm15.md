# LLVM15をベースとしたブランチについて

```sh
git clone https://github.com/msyksphinz-self/llvm-project.git -b llvm-myriscvx150
```

こちらでまだ詳細は未確認なのですが、`-DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi"`を適用した場合にビルドが失敗します。
`-DLLVM_ENABLE_RUNTIMES`を無効にして`cmake`オプションを構成すると、ビルドが成功することを確認しました。


- ビルドオプション

```sh
cmake -G Ninja \
      -DDEFAULT_SYSROOT=${HOME}/riscv_github/riscv64-unknown-elf \
      -DCMAKE_BUILD_TYPE="Debug" \
      -DLLVM_TARGETS_TO_BUILD="host;MYRISCVX" \
      -DLLVM_ENABLE_PROJECTS="clang" ../llvm
ninja
```


## LLVM15向けの修正項目の詳細

- `MYRISCVX.h`に`PassRegistry`のクラス宣言を追加する必要があります。

```diff
diff --git a/llvm/lib/Target/MYRISCVX/MYRISCVX.h b/llvm/lib/Target/MYRISCVX/MYRISCVX.h
index 01622196e0ad..10ca2b7cf8c6 100644
--- a/llvm/lib/Target/MYRISCVX/MYRISCVX.h
+++ b/llvm/lib/Target/MYRISCVX/MYRISCVX.h
@@ -21,6 +21,7 @@
 namespace llvm {
   class MYRISCVXTargetMachine;
   class FunctionPass;
+  class PassRegistry;

 FunctionPass *createMYRISCVXExpandPseudoPass();
 void initializeMYRISCVXExpandPseudoPass(PassRegistry &);
```

- `MCCodeEmitter()`の仕様が変わっています。

```diff
diff --git a/llvm/lib/Target/MYRISCVX/MCTargetDesc/MYRISCVXMCCodeEmitter.cpp b/llvm/lib/Target/MYRISCVX/MCTargetDesc/MYRISCVXMCCodeEmitter.cpp
index 45ae5a5e51e0..74293050a6db 100644
--- a/llvm/lib/Target/MYRISCVX/MCTargetDesc/MYRISCVXMCCodeEmitter.cpp
+++ b/llvm/lib/Target/MYRISCVX/MCTargetDesc/MYRISCVXMCCodeEmitter.cpp
@@ -42,7 +42,6 @@ namespace llvm {


 MCCodeEmitter *createMYRISCVXMCCodeEmitter(const MCInstrInfo &MCII,
-                                           const MCRegisterInfo &MRI,
                                            MCContext &Ctx) {
   return new MYRISCVXMCCodeEmitter(MCII, Ctx, true);
 }
diff --git a/llvm/lib/Target/MYRISCVX/MCTargetDesc/MYRISCVXMCTargetDesc.h b/llvm/lib/Target/MYRISCVX/MCTargetDesc/MYRISCVXMCTargetDesc.h
index 60eff1fd0e97..caeaa4c48239 100644
--- a/llvm/lib/Target/MYRISCVX/MCTargetDesc/MYRISCVXMCTargetDesc.h
+++ b/llvm/lib/Target/MYRISCVX/MCTargetDesc/MYRISCVXMCTargetDesc.h
@@ -36,7 +36,6 @@ Target &getTheMYRISCVX32Target();
 Target &getTheMYRISCVX64Target();

 MCCodeEmitter *createMYRISCVXMCCodeEmitter(const MCInstrInfo &MCII,
-                                           const MCRegisterInfo &MRI,
                                            MCContext &Ctx);

 MCAsmBackend *createMYRISCVXAsmBackend(const Target &T,
```

- `AsmParser`に対してヘッダファイルの変更と、マクロの追加を行う必要があります。

```diff
--- a/llvm/lib/Target/MYRISCVX/AsmParser/MYRISCVXAsmParser.cpp
+++ b/llvm/lib/Target/MYRISCVX/AsmParser/MYRISCVXAsmParser.cpp
@@ -18,6 +18,7 @@
 #include "llvm/MC/MCExpr.h"
 #include "llvm/MC/MCInst.h"
 #include "llvm/MC/MCInstBuilder.h"
+#include "llvm/MC/MCInstrInfo.h"
 #include "llvm/MC/MCObjectFileInfo.h"
 #include "llvm/MC/MCParser/MCAsmLexer.h"
 #include "llvm/MC/MCParser/MCParsedAsmOperand.h"
@@ -374,7 +375,9 @@ class MYRISCVXOperand : public MCParsedAsmOperand {
 }

 #define GET_REGISTER_MATCHER
+#define GET_SUBTARGET_FEATURE_NAME
 #define GET_MATCHER_IMPLEMENTATION
+#define GET_MNEMONIC_SPELL_CHECKER
 #include "MYRISCVXGenAsmMatcher.inc"

 void printMYRISCVXOperands(OperandVector &Operands) {
```

- `Disassembler`のヘッダファイルが変更ととなっています。

```diff
diff --git a/llvm/lib/Target/MYRISCVX/Disassembler/MYRISCVXDisassembler.cpp b/llvm/lib/Target/MYRISCVX/Disassembler/MYRISCVXDisassembler.cpp
index 38304c78793e..f267fe066c10 100644
--- a/llvm/lib/Target/MYRISCVX/Disassembler/MYRISCVXDisassembler.cpp
+++ b/llvm/lib/Target/MYRISCVX/Disassembler/MYRISCVXDisassembler.cpp
@@ -19,8 +19,8 @@
 #include "MYRISCVXSubtarget.h"
 #include "llvm/ADT/ArrayRef.h"
 #include "llvm/MC/MCContext.h"
+#include "llvm/MC/MCDecoderOps.h"
 #include "llvm/MC/MCDisassembler/MCDisassembler.h"
-#include "llvm/MC/MCFixedLenDisassembler.h"
 #include "llvm/MC/MCInst.h"
 #include "llvm/MC/MCRegisterInfo.h"
 #include "llvm/MC/MCSubtargetInfo.h"
```
