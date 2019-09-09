30日でできる！自作OS入門（Win10標準ツールで焼き直し）1日目
====================================

## 下準備

- QEMUはWindows用をインストール
- WSL, Hyper-Vは有効
- エディタはVS Code

## 機械語書くところ

### ファイル作成

WSLでddつかえば楽できそう．
```
wsl dd if=/dev/zero of=helloos.img count=2880
```

書き換えて完成．

### 動作確認（QEMU）
```
qemu-system-i386 .\helloos.img
```

### 動作確認（Hyper-V）

完全におまけ．本ではFDとなっているので，ここでもそれで．

```
# vfd形式に変換
qemu-img convert helloos.img helloos.vfd
```

仮想マシンをつくって，設定でvfd読ませてブート順位上げる．
メモリは最低でOK．

あとは起動すればOK．シャットダウンが効かないので停止で殺す．

## アセンブリ言語なところ

世の中に従いnasmでやる．WSLでインストール．
```
wsl sudo apt install nasm
```

asmファイルを作成．警告出ないように[ここ](http://hrb.osask.jp/wiki/?tools/nask)参照して書き換え．

生成して起動確認して終わり．
```
wsl nasm helloos.asm -o helloos-asm.img
qemu-system-i386 .\helloos-asm.img
wsl diff helloos.img helloos-asm.img
```