# 🚀 リモート実行ツールセット：研究・実験効率化ガイド

このツールセットは、**「自分のPCで書いたプログラムを、コマンド一つでスパコン（KAGAYAKI）やUbuntuサーバー（KIELI）へ送り、実行し、終わったら通知を受け取る」**ためのものです。

---

## 📥 導入方法（クローン ＆ 配置）

### 1. ツールセットをクローンする
まずはこのリポジトリを自分のPCの適当な場所にクローンします。
```bash
git clone git@github.com:A3426L/JAIST_template.git
```

### 2. 自分のプロジェクトへ配置する
クローンしたディレクトリの中にある **`scripts/` フォルダを丸ごと**、自分の研究プロジェクトのルートディレクトリにコピーしてください。

**理想的な配置例:**
```text
自分の研究プロジェクト/
├── scripts/  <-- これをコピーして持ってくる
│   ├── kagayaki/
│   └── kieli/
└── (あなたの研究コード: main.py など)
```

---

## 🛠️ 【初期セットアップ】コピー直後にやること

`scripts/` フォルダを配置したら、以下の設定を済ませましょう。

### STEP 1: SSH接続の登録
自分のPCの `~/.ssh/config` に、接続先情報を登録してください。
```text
Host kagayaki
    HostName kagayaki.jaist.ac.jp
    User (あなたのJAISTユーザー名)

Host kieli
    HostName (KieliのIPアドレス)
    User (あなたのユーザー名)
```

### STEP 2: 設定ファイルの作成
`scripts/` フォルダ内で設定ファイルのひな形をコピーし、内容を書き換えます。
```bash
cd scripts
cp .env.example .env
```
`.env` を開き、通知用の Discord Webhook URL などを設定してください。
※ `scripts/.gitignore` が含まれているため、この設定が外部に漏れることはありません。

---

## 🏃 実行の手順

### 1. KAGAYAKI (スパコン / PBS) で実行
1. `scripts/kagayaki/job.pbs` を開き、実行したいコマンド（`CMD="..."`）を書き換えます。
2. 実行します：
   ```bash
   cd scripts/kagayaki
   ./push_kagayaki.sh
   ```

### 2. KIELI (Ubuntu / 直接実行) で実行
1. `scripts/kieli/run_remote.sh` を開き、実行したいコマンド（`CMD="..."`）を書き換えます。
2. 実行します：
   ```bash
   cd scripts/kieli
   ./push_kieli.sh
   ```

### 3. 通知 ＆ 回収（Pull）
実行が終わると Discord に通知が届きます。通知が来たら結果を回収しましょう。
```bash
./pull_kagayaki.sh  # または ./pull_kieli.sh
```

---

## ⚠️ 同期の挙動と注意点（重要）
本ツールは **「完全同期」** を行います（`rsync --delete` オプションを使用）。
- **削除も同期されます**: ローカルでファイルを消してから `push` するとリモートからも消え、リモートで消してから `pull` するとローカルからも消えます。
- **事前の確認**: 不安な場合はコマンドの末尾に `--dry-run` を付けて、何が変更・削除されるか確認してください。

---