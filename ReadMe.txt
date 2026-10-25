━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

4CA式コード実行ステコン作成補助ツール＋ ver_1.00
                                       Author:Halkaze

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### 概要 ###

ダウンロードありがとうございます！

こちらは、
・自作の「4CA式コード実行ステコン作成補助ツール ver_1.00」
・自作の「アセンブル作業自動化ツール ver_1.00」
・後述のBSDライセンスによって提供されている「NASM-2.11.08」
を合わせたセットとなっております。

「4CA式コード実行ステコン作成補助ツール ver_1.00」については、
「MakeCode_4CA」フォルダ内のReadMe.txtを別途参照してください。

不具合報告などはこちらまでどうぞ
  ブログ ：https://halkaze.fc2.net/
  Twitter：@halkazeMUGEN1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### 使い方 ###

※この項では、「AutoAssemble.bat」の使い方についてのみ説明します。

１．「input.txt」内にアセンブリ言語でコードを記述する
２．「AutoAssemble.bat」を起動する

「AutoAssemble.bat」起動後は、記述が正しければ自動的に機械語に変換され、
「MakeCode_4CA.bat」が起動し、DTCステコン記述が完成します。

「input.txt」の書き方や4CA式コード、RETRET式コードの書き方については
Sampleフォルダ内の各ファイルを参照してください。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### 更新履歴 ###

2021/12/31:正式公開

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### NASM使用にかかるライセンス表示 ###

NASM is now licensed under the 2-clause BSD license, also known as the
simplified BSD license.

    Copyright 1996-2010 the NASM Authors - All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following
    conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
      CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
      INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
      MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
      DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
      CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
      NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
      LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
      HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
      OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
      EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━