# 如何做：思路篇

## Pattern

* SPAM filtering

## Steps

1. 建立 "CM" 清單
1. 根據 "CM" 清單，建立「頻道」清單
1. 根據「頻道」與其「影片」關聯性，建立一種判斷模型
1. 初步資料清理
1. 根據資料清理結果，得出「公式（官方）」頻道列表
1. "CM" 影片只要出自「公式（官方）」頻道，照理說應該就是「原汁原味」的版本
1. 將這些「原汁原味」的 CM 影片依日期建立 YouTube 播放列表
1. 進一步可以將這些影片依主題分類

## 如何判斷是「公式（官方）」頻道？

* 上傳影片的相關性
* 所列外部連結的一致性

# 如何做：實作篇

## 資料清理

1. 獲取資料： `curl -i -G -d "q=CM&relevanceLanguage=ja-JP&order=date&maxResults=25&type=video&part=snippet&key=THE_KEY_OF_Knowledge_Graph_Search_API" https://www.googleapis.com/youtube/v3/search`
1. 判斷 title, description 是否為日本語： `curl -X POST -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) -H "Content-Type: application/json; charset=utf-8" --data "{ 'q': '自動車CM 2003年 ニッサン リバティ 超低排出ガス車になりました M12 （後期型） TV commercial adverts Car Commercial film AD' }" "https://translation.googleapis.com/language/translate/v2/detect"`

## 燒腦

* 類似 https://www.youtube.com/watch?v=eJSeWRqbXlY 這樣沒有描述自己是「CM 動画」的廣告影片、所屬頻道又沒相關描述，在只針對文字描述處理的限制下，只能成為漏網之魚。要不就針對每部日本語 (`relevanceLanguage=ja-JP`) 的影片做視覺內容分析，要不就放棄。（SEO 對於放棄自我宣傳的朋友是愛莫能助、鞭長莫及）

## GCP
1. 開 Google Developers console
1. 開 Japanese CM Tube 專案
1. 建立 API 金鑰
1. 啟用 Google APIs
    * Knowledge Graph Search API
    * YouTube Data API v3
    * （未定）Google Cloud Machine Learning Engine
    * （未定）Prediction API
    * （未定）Google Cloud Natural Language API


## References

* [Overview - Japanese Text Analysis - Guides at Penn Libraries](https://guides.library.upenn.edu/japanesetext)
