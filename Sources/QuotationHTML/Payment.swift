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
    /// 酬金補充說明（per-case 註解，例：「*財務簽證依預估資產總額新台幣壹億元報價」）。
    /// 多行內容以 `\n` 分隔；render 時前綴單一個 `*`、整段 `white-space: pre-line` 保留換行。
    /// `nil` 或空字串 → 不渲染此 row。
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
                    TableCell{
                        Text("*\(supplementaryNote)")
                    }.attribute(named: "colspan", value: "2").style("white-space: pre-line; padding-top: 0.5em;")
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
