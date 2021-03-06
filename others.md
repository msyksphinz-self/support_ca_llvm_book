# あとがき

本書は命令セットアーキテクチャを解説する本です。しかし最初にプロジェクトを始めた際、LLVMバックエンドを解析するための書籍としてスタートしました。LLVMという大規模かつ複雑怪奇なプロジェクトを通じて、命令セットアーキテクチャを学ぶというのは筆者にとって非常に面白いプロジェクトではありましたが、それ以上にハードルの高いものでした。

私がLLVMに興味を持ったのは、2017年に品川で開催された「コンパイラ勉強会」に参加したのがきっかけでした。当時はRISC-VのLLVM対応はほとんど進んでおらず、「よっしゃそれならイッチョ私がやったろうじゃないか」という気持ちでLLVMの勉強を開始しました。しかし非常に複雑なコードと一からの勉強は思いのほか時間がかかり、本書が書きあがった時にはLLVMのRISC-V対応はメインストリームに取り込まれていました。残念。

本書の元ネタは、すべてブログ「FPGA開発日記（msyksphinz.hatenablog.com）」に掲載されているものです。二足の草鞋ではありませんが、実はLLVM解析結果をブログに執筆しているのと同時に、書籍化へ向けて第1段の原稿を作っていました。これは特にLLVMに焦点を当てたもので命令セットアーキテクチャ自体にはあまり重きを置いていなかったのですが、編集の方との様々な議論の中で「命令セットアーキテクチャについてもある程度解説しないと、っていうかそっちをメインにしないとストーリーが作れんやろ」という結論に達し、2部構成に変更しました。ちなみにですが本格的な執筆は2020年に入ってからで、第1段の原稿をある程度ベースにしていますが全く別物になっています。

私は高等専門学校から大学学部、大学院まで一貫してコンピュータアーキテクチャ、ハードウェア設計を中心とした研究を行ってきました。取り扱ったものはFPGA向けのCPU/IPだったり、ヘンテコなハードウェアアクセラレータだったりと様々ですがいつも悩まされるのがコンパイラです。修士のときにコンパイラを自作して研究に使っていたのですが、「あーこれもうちょっと一般的にできないかな」「アーキテクチャ変えたらほとんど書き直しやん」と不満に感じておりLLVMのようなコンパイラ基盤を作ってみたいなと漠然と思っていました（そして当時はLLVMの存在をほとんど知らなかった）。LLVMが脚光を浴び始めてから自分で調査を行ってみても複雑怪奇でサッパリ分からず、しばらく放置していたのですが上記のようにコンパイラ勉強会に参加して、もう一度LLVM欲が再燃したという訳です。人生、いろんな方向にアンテナを張っていれば、思わぬところで何が起こるか分かりません。



## 謝辞

本書の執筆に当たり、以下の方にレビューをして頂きました（敬称略、五十音順）。

- 安達 浩次
- 石井 敬
- 石谷 太一
- 角田 俊太郎
- 初田 直也
- 林 伴一

私の駄文のような文章を一から丁寧に指摘して下さり、驚くほど多くの指摘と改善を頂きました。ありがとうございます。

ほとんど殴り込みの形で企画を持ち込んだ私を快く受け入れて下さり、本書の初期段階から関わって頂いた技術評論社の村下昇平様に感謝致します。企画の初期段階から始まり構成案の決定など、すべてのステップで非常に有益なアドバイスを頂きました。ありがとうございます。

最後に、私が昼夜問わずLLVMをぶん回しながらうんうん言いつつ原稿と格闘しているのを静かに支えてくれた、妻の彩と娘の美月に感謝致します。妻は非エンジニアの立場から、構成、説明の分かりやすさなどについて非常に多くのアドバイスをもらいました。娘はMDIC（My Daughter Interrupt Controller）として最優先の割り込み・例外処理を家族にかけ続けてくれていますが、それも含めてとても楽しい日々が続いています。家族の協力が無ければ、この本は書き上げることはできませんでした。感謝します。
