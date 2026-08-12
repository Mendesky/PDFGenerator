//
//  TaxRemitterSection.swift
//  PDFGenerator
//
//  代繳稅金（訪談表 P2-7）— 五個稅種各自的繳納執行方。
//  版面比照 EvidenceInfoSection（統購）：標題列 grey60 + 值 text，未選以「-」呈現。
//

import Plot

/// 代繳稅金區塊：列出各稅種由事務所代繳或客戶自行繳納。
///
/// **與 `EvidenceInfoSection`（統購）刻意分開的理由**：代繳稅金不屬於「發票憑證 / 統購」概念，
/// 只是版面上排在其後。做成獨立 component 讓兩者能各自調整順序、樣式與存在與否；
/// 若塞進 EvidenceInfoSection，日後要拆或改排序都得動到統購的渲染。
///
/// **未選一律顯示 `-`**：呼叫端把「尚未選擇」轉成 `nil` 傳入即可，本 component 不區分
/// 「沒有資料來源」與「使用者未選」—— 兩者在紙本上都是空白。但呼叫端**不可**把讀取失敗
/// （例如上游 503）也轉成 `nil`，那會把故障印成使用者的選擇。
public struct TaxRemitterSection: Component {
    let items: [Item]

    public var body: any Component {
        Div {
            for item in items {
                Div {
                    Paragraph(item.title).class("grey60")
                    Paragraph(item.value ?? "-").class("text")
                }.class("gap8")
            }
        }.class("taxRemitterInfo")
    }

    /// - Parameter items: 稅種列，順序即呈現順序（由呼叫端決定，通常照訪談表印製順序）。
    public init(items: [Item]) {
        self.items = items
    }
}

extension TaxRemitterSection {
    public struct Item {
        let title: String
        /// `nil` = 尚未選擇 → 呈現為「-」。
        let value: String?

        public init(title: String, value: String?) {
            self.title = title
            self.value = value
        }
    }
}
