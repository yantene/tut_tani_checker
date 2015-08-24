# TUT TAN'I Checker

実行は自己責任で．

## Step 0

予め TUTVPN に接続し，
`wlinux0.edu.tut.ac.jp` へ SSH でログインしておいてください．

## Step 1

リポジトリをクローンし，
リポジトリ内の `./tut_tani_checker.sh` を実行します．

```bash
git clone https://github.com/yantene/tut_tani_checker.git
cd tut_tani_checker
./tut_tani_checker.sh
```

![](/images/step1.png)

## Step 2

情報メディア基盤センターの ID と パスワードを入力します．

![](/images/step2.png)

## Step 3

そのまま Enter すると全成績が表示されます．

表示されなければ ID か パスワードが誤っているか，
スクリプトのバグです．

![](/images/step3.png)
