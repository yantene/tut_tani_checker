# TUT TAN'I Checker

豊橋技科大生のための成績確認ツールです．
成績を確認したいが大学へ行くことができないときなどに重宝するかと思います．

スクリプトのコードの解説は以下のページで行っております．

[技科大の成績確認ツールを作ってみた - yantene.net](http://yantene.net/tut_tani_checker.html)

くれぐれもスクリプトのご利用は自己責任でお願い致します．

## Step 0

予め TUTVPN に接続し，
`wlinux0.edu.tut.ac.jp` へ SSH でログインしておいてください．

## Step 1

本リポジトリをクローンし，
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
