API仕様
=====================================
## /metro/API/getMetroPOI.php
### 概要
緯度経度を渡すと、その近くの出入口の緯度経度情報を返します。

### リクエストパラメータ
* lat = 緯度
* lon = 経度

### レスポンス
リクエスト下緯度経度情報から近い順に出入口情報を10件返します。
* 成功時
  * error = エラー番号（成功時：１）
  * title = 出入口の名前
  * lat = 緯度
  * lon = 経度
* 失敗時
  * error = エラー番号（失敗時：０）
  * error_msg = エラーメッセージ

### サンプルURL
* 東京駅
  * http://gif-animaker.sakura.ne.jp/metro/API/getMetroPOI.php?lat=35.681265&lon=139.766926&radius=100000
* 六本木駅
  * http://gif-animaker.sakura.ne.jp/metro/API/getMetroPOI.php?lat=35.6641222&lon=139.729426&radius=100000
* 国立競技場
  * http://gif-animaker.sakura.ne.jp/metro/API/getMetroPOI.php?lat=35.678086&lon=139.714935&radius=100000

## /metro/API/get2Point.php

### 概要
* 現在位置の緯度経度と目的地の緯度経度を渡すと、駅を通って抜けられる2点の出入口を返します。
* 2点がそれぞれ異なる駅である場合は結果に含まれません。ただし、赤坂見附と永田町や、国会議事堂前と溜池山王など、駅がつながっている場合は結果に含みます。
* 目的地に近い出入口pointBは１点固定で返ってきます。
* 現在地に近い出入口pointAは近い順に１０点返ってきます。

### リクエストパラメータ
* latA = 現在位置の緯度
* lonA = 現在位置の経度
* radiusA = 現在地の半径何mの範囲の出入口を探すか
* latB = 目的地の緯度
* lonB = 目的地の経度
* radiusB = 目的地の半径何mの範囲の出入口を探すか

### レスポンス
リクエスト下緯度経度情報から近い順に出入口情報を10件返します。
* 成功時
  * error = エラー番号（成功時：１）
  * error_msg = エラーメッセージ（成功時は空）
  * result = 結果の配列
  	* pointA = 現在値付近の出入口情報
  		* title = 出入口の名前
  		* lat = 緯度
  		* lon = 経度
  	* pointB = 目的地の出入口情報
  		* title = 出入口の名前
  		* lat = 緯度
  		* lon = 経度
* 失敗時
  * error = エラー番号（失敗時：０）
  * error_msg = エラーメッセージ
  * result = 結果（エラー時は空）

### サンプルURL
![2point](https://raw.githubusercontent.com/donkeykey/Metro/master/concept/2point.png "2point")
* http://gif-animaker.sakura.ne.jp/metro/API/get2Point.php?latA=35.675742&lonA=139.738220&radiusA=200000&latB=35.679672&lonB=139.738541&radiusB=200000

