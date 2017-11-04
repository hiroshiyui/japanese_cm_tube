# 如何做：思路篇

1. 建立 "CM" 清單
1. 根據 "CM" 清單，建立「頻道」清單
1. 根據「頻道」與其「影片」關聯性，建立一種判斷模型
1. 初步資料清理
1. 根據資料清理結果，得出「公式（官方）」頻道列表
1. "CM" 影片只要出自「公式（官方）」頻道，照理說應該就是「原汁原味」的版本
1. 將這些「原汁原味」的 CM 影片依日期建立 YouTube 播放列表
1. 進一步可以將這些影片依主題分類

# 如何做：實作篇

1. 開 Google Developers console
1. 開 Japanese CM Tube 專案
1. 建立 API 金鑰
1. 啟用 Google APIs
    * Knowledge Graph Search API
    * YouTube Data API v3
    * （未定）Google Cloud Machine Learning Engine
    * （未定）Prediction API
    * （未定）Google Cloud Natural Language API