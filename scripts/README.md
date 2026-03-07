# 🚀 リモート実行ツールセット：研究・実験効率化ガイド

このツールセットは、「自分のPCで書いたプログラムを、コマンド一つでスパコン（KAGAYAKI）やUbuntuサーバー（KIELI）へ送り、実行し、終わったら通知を受け取る」ためのものです。

全ての仕組みが `scripts/` ディレクトリ内に完結しているため、このフォルダを自分の研究用ディレクトリにコピーするだけで、どこでもリモート実行環境が整います。

---

## 🛠️ 【初期セットアップ】導入の手順

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
`scripts/` フォルダ内にある設定ファイルのひな形をコピーし、内容を書き換えます。
```bash
cd scripts
cp .env.example .env
```
`.env` を開き、通知用の Discord Webhook URL などを設定してください。

---

## 🏃 実行の手順

実行したいコマンドは、それぞれの「実行用ファイル」に直接書き込みます。

### 1. KAGAYAKI (スパコン / PBS)
1. `scripts/kagayaki/job.pbs` を開き、`CMD="python3 ..."` の行を実行したいコマンドに書き換えます。
2. 実行します：
   ```bash
   cd scripts/kagayaki
   ./push_kagayaki.sh
   ```

### 2. KIELI (Ubuntu / 直接実行)
1. `scripts/kieli/run_remote.sh` を開き、`CMD="python3 ..."` の行を実行したいコマンドに書き換えます。
2. 実行します：
   ```bash
   cd scripts/kieli
   ./push_kieli.sh
   ```

### 3. 通知 ＆ 回収（Pull）
通知が来たら、結果を手元に回収しましょう。
```bash
./pull_kagayaki.sh  # または ./pull_kieli.sh
```

---

## ⚠️ 同期の挙動と注意点（重要）

本ツールは **「完全同期」** を行います（`rsync --delete` オプションを使用）。

- **削除も同期されます**: 
  ローカルでファイルを消してから `push` すると、リモート側のファイルも消去されます。逆に、リモートで消した後に `pull` すると、ローカルのファイルも消去されます。
- **不用意な消去を防ぐには**:
  「何が消されるか」を事前に確認したい場合は、引数に `--dry-run` を付けて実行してください。
  ```bash
  ./pull_kagayaki.sh --dry-run
  ```
  *(※ 画面に対象ファイルが表示されるだけで、実際には何も変更されません。)*

---

## 📂 ディレクトリ構成

```text
(Project Name)/
├── scripts/             # 【重要】このフォルダをコピペして使う
│   ├── .env             # 秘密の設定 (Git管理外)
│   ├── .env.example     # 設定のテンプレート
│   ├── .gitignore       # env等を守る設定
│   ├── kagayaki/        # KAGAYAKI用 (push, pull, job.pbs, notify)
│   └── kieli/           # KIELI用 (push, pull, run_remote, notify)
└── (Your Code)          # あなたの研究コード
```

---