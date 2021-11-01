# 設計

## backend

### jobs

* job統合

  * たくさんでてきたので、統合する

  * INTERVALロジック

    1. 開始時点、現在時刻+jobごとのINTERVALの時間を変数に格納
    2. 1~5秒ごとにループを行い、1.で設定した時間を超えた場合、実行
    3. 実行後、変数を1.と同じ手順で更新

  * 配列にクラスオブジェクトを格納して上記っぽいことを実現してる

* request ping

  * ping_job.rb

  * 現状は二秒に一度送信

* parent sync(未テスト)

  * parentへ子孫及び自分の取得したpingの送信送信

* apiを提供する

  * childrenからデータを受信する

  * frontend用へのAPI提供

    * nodes

    * nodeのpings(現状だと最新100固定)

## frontend

* nodeリスト表示

* nodeのChartを表示する

