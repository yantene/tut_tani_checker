#!/bin/bash

# html のテキストデータを引数に，
# 値の設定されているフォームデータを
# 改行で区切られた name=value の形式で
# 標準出力へ出力する関数です．
form_data() {
  echo "$*" \
    | grep -o -P '<input.+?>' \
    | sed -r 's/^.+name="([^"]+)".+value="([^"]*)".+$/\1=\2/' \
    | sed -r '/^[^= ]+=[^ ]*$/!d'
}

DC_LOGIN="https://www.ead.tut.ac.jp/Portal/LogIn.aspx"
DC_SELECT="https://www.ead.tut.ac.jp/Portal/ReferResults/Portal.aspx"
DC_RESULTS="https://www.ead.tut.ac.jp/Portal/ReferResults/Results.aspx"

# 認証情報を入力してもらう．

read -p "Account ID: " id
read -sp "Password: " password; echo

cookie=`mktemp cookie.XXXXXX`

# ログイン画面を開き，
# セッション ID と各種フォームデータを取得する．

login_html=`curl "$DC_LOGIN"\
  --silent \
  --cookie-jar $cookie`

# html ファイルからフォームデータを取得し，
# ユーザ ID とパスワードの情報を付加した上で，
# ログイン時の curl のパラメタとして使用できるよう整形する．

account_data="--data-urlencode txtID=$id"
password_data="--data-urlencode txtPassWord=$password"

login_parameters="`form_data $login_html \
  | sed -r 's/^(.*)$/--data-urlencode \1/' \
  | tr '\n' ' '` $account_data $password_data"

# ログインする．

curl "$DC_LOGIN" \
  --silent \
  --cookie $cookie \
  --referer "$DC_LOGIN" \
  $login_parameters > /dev/null

# 成績情報のページを取得する．

select_html=`curl "$DC_SELECT" \
  --silent \
  --cookie $cookie`

# html ファイルからフォームデータを取得し，
# 過去の全成績を表示するよう変更を加えた上で，
# curl のパラメタとして使用できるよう整形する．

select_parameters=`form_data $select_html \
  | sed -r '/^.*btnGpa.*$/d' \
  | sed -r 's/^(.*)$/--data-urlencode \1/' \
  | tr '\n' ' '`

# 成績明細のページを取得する．

results_html=`curl "$DC_SELECT" \
  -L \
  --silent \
  --cookie $cookie \
  $select_parameters`

# html ファイルからフォームデータを取得し，
# 全件の成績データを要求するよう変更を加えた上で，
# curl のパラメタとして使用できるよう整形する．

all_results_request="--data-urlencode rdlGrid\$ddlLines=0"

all_results_parameters="`form_data $results_html \
  | sed -r 's/^(.*)$/--data-urlencode \1/' \
  | tr '\n' ' '` $all_results_request"

# 全成績明細のページを取得する．

all_results=`curl "$DC_RESULTS" \
  --silent \
  --cookie $cookie \
  $all_results_parameters`

# 成績情報を整形して表示する

record_line_ptn='<td align="center">.+</td>'
record_data_ptn='<td align="center"><font color="0">([0-9]+)<\/font><\/td><td align="center"><font color="0">(.期)<\/font><\/td><td align="left"><font color="0">(.+<br>　?)?(.+)<\/font><\/td><td align="left"><font color="0">(.+)<\/font><\/td><td align="center"><font color="0">([0-9.]+)<\/font><\/td><td align="center"><font color="0">(履修放)?(.+)<\/font><\/td>'

echo "$all_results" \
  | grep -o -P "$record_line_ptn" \
  | sed -r "s/$record_data_ptn/\1年 \2\t\8\t\4(\5)/" \
  | sed -r 's/(&#[0-9]+)/\1;/' \
  | nkf -w --numchar-input \
  | sort -k 1,1 -k 2,2r

rm $cookie
