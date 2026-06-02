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
    /// 酬金補充說明（per-case 註解）。
    /// **HTML 字串**（非純文字）— 整段以 raw HTML inject 到 `<td>`，不做 HTML escape、不加任何前綴。
    /// caller（OC composer）負責把 markdown + 內嵌 HTML 轉成乾淨 HTML 字串（含內嵌圖片轉 data URI、
    /// template variable 替換等）+ 內嵌 scoped `<style>` block 控版面後傳入。
    /// `nil` 或空字串 → 不渲染此 row。
    ///
    /// **語意變更（2026-06）**：
    /// 1. 原為純文字 `Text()` rendering、escape HTML chars；frontend 引入富文字編輯（粗體 / 底線 /
    ///    刪除線 / 圖片 / 表格等）後改為 HTML。既有純文字 caller 仍可正常渲染（無 HTML tag 即等同純文字），
    ///    但若內含 `<` `>` `&` 等 HTML 字元需 caller 先 escape。
    /// 2. **拔掉硬寫的 `*` 前綴**：原 `"*\(supplementaryNote)"` 純文字時代的視覺標記，富文字時代由前端
    ///    編輯器 / caller 自行決定是否在 content 內加 `*`（或其他 marker）。直接 prepend 會跟 caller 已
    ///    寫入內容的 leading `*` 重疊，且當 caller HTML 開頭是 block element（如 `<style>` 加 wrapper
    ///    `<div>`）時 `*` 文字節點會被擠到自己一行造成版面 bug。本欄位不再做任何隱性前綴 magic。
    /// 3. **無 `white-space: pre-line` style**：原本為純文字 `\n` 換行設計的 legacy CSS；HTML 時代由
    ///    HTML 結構自身（`<p>` / `<br>` / `<h*>` 等）控制換行，`pre-line` 會把 HTMLFormatter 在 block
    ///    tag 之間插入的實體 `\n` 顯示為**多餘可見換行**、造成大段空白。caller 若仍有純文字 `\n`
    ///    需求，應自行轉 `<br>`；本欄位不再做隱性 `\n` → 換行的 magic。
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
                TableRow{
                    TableCell()  // alignment 占位，對齊 (n) 編號欄
                    TableCell(html: supplementaryNote)
                        .attribute(named: "colspan", value: "2")
                        .style("padding-top: 0.5em;")
                }
            }
        }
    }

    public init(name: String, items: [PaymentItem], needShowName: Bool = true, supplementaryNote: String? = nil) {
        self.name = name
        self.items = items
        self.needShowName = needShowName
        self.supplementaryNote = supplementaryNote
    }

    package func hideName() -> Self {
        .init(name: name, items: items, needShowName: false, supplementaryNote: supplementaryNote)
    }
}

extension Payment {
    public struct Model {
        public let name: String
        public let items: [PaymentItem.Model]
        public let needShowName: Bool
        public let supplementaryNote: String?

        public init(name: String, items: [PaymentItem.Model], needShowName: Bool, supplementaryNote: String? = nil) {
            self.name = name
            self.items = items
            self.needShowName = needShowName
            self.supplementaryNote = supplementaryNote
        }
    }
}
