//
//  Payment.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/4/23.
//
import Plot

public struct Payment: Component {
    public let name: String
    public let items: [PaymentItem]
    public let needShowName: Bool
    /// 此 bundle 所屬 quotingCase 的名稱。多 case（≥2 個不同 `caseName`）時 `PaymentBlock` /
    /// `ReplyFormPaymentBlock` 會在該 case 第一個 bundle 上方渲染 case 名稱標題（bundle 名標題落在其下）；
    /// 單一 case 時不渲染 case 標題（沿用既有單/多 bundle 行為）。`nil` 視為「無 case 維度」（= 單 case）。
    /// **是否顯示** case 標題是 presentation 判斷，由本 lib 依 caseName 分組數決定，caller 只忠實提供值。
    public let caseName: String?
    /// 酬金補充說明（per-case 註解）。
    /// **markdown 字串** — 由 PDFGenerator 內部 `SupplementaryNoteHTMLRenderer` 渲染成 HTML
    /// （markdown → HTML + soft break 換行 + scoped style）後 inject 到 `<td>`。
    /// caller（OC）只做領域 / 安全前處理：template variable 替換成實際值、內嵌圖片 fetch + ownership
    /// 驗證後 inline 成 `<img data:...>`；**不做 markdown→HTML、不傳 CSS、不加 marker**（presentation 全歸此處）。
    /// `nil` 或空字串 → 不渲染此 row。
    ///
    /// **渲染重點**：
    /// - 補充說明 row 兩個 cell 帶 `border-top: 1px solid black` → 上方一條跨整欄分隔線（取代舊 `*` marker）。
    /// - markdown / 樣式細節見 `SupplementaryNoteHTMLRenderer`。
    public let supplementaryNote: String?

    public var body: any Component{
        ComponentGroup{
            if needShowName {
                TableRow{
                    TableCell{
                        Text(name).bold().style("font-size: 1.1em;")
                    }.attribute(named: "colspan", value: "3")
                }
            }
            for (index, item) in items.enumerated(){
                TableRow{
                    TableCell("(\(index+1))").style("vertical-align: top; width: 1.35rem;")
                    item
                }.style("padding-bottom: 0.5em; width: 100%; padding-top: 0.5em;")
            }
            if let supplementaryNote, !supplementaryNote.isEmpty {
                // 補充說明上方一條橫線：border 下在 **cell** 而非 row —— border-collapse 下 weasyprint
                // 對非首列的 row-level border-top 不穩（會與前一列 border 塌掉而不畫），cell border 才可靠。
                // 兩個 cell（占位 + colspan=2）都加 → 跨整欄、視覺等同 PaymentBlock 表頭分隔線。
                // markdown → HTML 在此渲染（presentation 歸 PDFGenerator）；caller 傳的是 markdown。
                TableRow{
                    TableCell()  // alignment 占位，對齊 (n) 編號欄
                        .style("border-top: 1px solid black;")
                    TableCell(html: SupplementaryNoteHTMLRenderer.render(markdown: supplementaryNote))
                        .attribute(named: "colspan", value: "2")
                        .style("border-top: 1px solid black; padding-top: 0.5em;")
                }
            }
        }
    }

    public init(name: String, items: [PaymentItem], needShowName: Bool = true, supplementaryNote: String? = nil, caseName: String? = nil) {
        self.name = name
        self.items = items
        self.needShowName = needShowName
        self.supplementaryNote = supplementaryNote
        self.caseName = caseName
    }

    package func hideName() -> Self {
        .init(name: name, items: items, needShowName: false, supplementaryNote: supplementaryNote, caseName: caseName)
    }
}

extension Payment {
    public struct Model {
        public let name: String
        public let items: [PaymentItem.Model]
        public let needShowName: Bool
        public let supplementaryNote: String?
        public let caseName: String?

        public init(name: String, items: [PaymentItem.Model], needShowName: Bool, supplementaryNote: String? = nil, caseName: String? = nil) {
            self.name = name
            self.items = items
            self.needShowName = needShowName
            self.supplementaryNote = supplementaryNote
            self.caseName = caseName
        }
    }
}
