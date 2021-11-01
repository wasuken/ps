# 要望とか

## backend

* ping送信機能

  * ping間隔をパラメタとして逃がす

* parent送信機能

  * sync_job.rb

  * gz圧縮

  * キャッシュ

  * まだ書いてない

  * こちらはユーザ要求(一分くらいのロック想定)もしくは五分に一度くらいを想定

  * 並行処理で処理

    * おそらくsyncとping同時に動かしたらsyncで止まってpingデータ間隔が悲しいことになってしまう

* Logging

  * エラー

  * リクエスト/レスポンス


## plugins

* ping以外のデータも扱えるようにする

* これはもはや別リポジトリで開発するべき

## frontend

* dashboard

  * 各nodeの平均ping応答速度、ping応答成功率

  * hostが収集しているnodeすべてをまとめた線グラフ
