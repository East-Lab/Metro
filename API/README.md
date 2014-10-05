API仕様
=====================================
## リクエストパラメータ
* lat = 緯度
* lon = 経度

## レスポンス
リクエスト下緯度経度情報から近い順に出入口情報を10件返します。
* 成功時
  * error = エラー番号（成功時：１）
  * title = 出入口の名前
  * lat = 緯度
  * lon = 経度
* 失敗時
  * error = エラー番号（失敗時：０）
  * error_msg = エラーメッセージ


## サンプルURL
* 東京駅
  * http://gif-animaker.sakura.ne.jp/metro/API/getMetroPOI.php?lat=35.681265&lon=139.766926
* 六本木駅
  * http://gif-animaker.sakura.ne.jp/metro/API/getMetroPOI.php?lat=35.6641222&lon=139.729426
* 国立競技場
  * http://gif-animaker.sakura.ne.jp/metro/API/getMetroPOI.php?lat=35.678086&lon=139.714935 
