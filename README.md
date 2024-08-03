# CODE_NTPU

# 版本更新狀況
## 現有功能(ver 4.3)
- Firebase auth、Firebase儲存個人資訊，以及常用操作(Example:pinned最愛使用的服務項目)
- 帳號建立以及登入介面
- 行事曆功能，拖動月份查看當前學校月份事件(也提供新生按鈕以區分事件)(註:行事曆有部分資訊僅通知新生)
- 個人課表功能，新增與刪除課程以更容易查看
- 統整北大學生常用連結，並且開放「個人常用連結專區」，新增與刪除個人常用的網站連結，提升個人使用體驗
- 服務專區建立，統一現有App可以提供的服務(Example:惜福專區、社團活動宣傳等)

## 更新紀錄

### 4.31
- 更新課表建立時"日間部夜間課"的時間進行調整
- 更新刪除課表的文字排版


## 預計更新功能
- 服務專區功能完全建立(惜福專區、社團活動宣傳、愛心傘借助與歸還)
- 首頁佈告欄展示資訊連上Firebase，以更好推撥與更新資訊
- 個人課表功能更新"更好的操作方式以及更新自定義事件"
- 開發管理者版本App，已更加進行管理資訊(服務專區預計將由管理者管理使用者操作情況，Example:封鎖不當資訊、管理當前愛心傘使用狀況等)
- 個人資訊頁面與個性化調整選擇(Example:多語言選擇等)
- 設計早/午/晚/消餐推薦

## 現有問題
- 早午晚餐的推薦設計需要著重考量，firebase的資源珍貴，很難顧及不斷更新的餐點推薦，以及要如何記錄"當前使用者已經填寫過這家店的評價"
- firebase要如何處理圖片問題 => 攸關"布告欄"、"愛心食品"的圖片問題
- cloud function要如何處理 => 不然之後要如何處理資料更新(總不能把所有資料存起來，過時的資訊要將其刪除，但如果手動去做極度麻煩)

