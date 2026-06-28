//
//  ClassicCheckbox.swift
//  PDFGenerator
//
//  舊版訪談表的 ■/□ 勾選顯示。checked → ■，否則 □，後接標籤文字。
//

import Plot

struct ClassicCheckbox: Component {
    let label: String
    let isChecked: Bool

    var body: any Component {
        Span("\(isChecked ? "■" : "□")\(label)").class("ckbox")
    }
}

/// 一組互斥/多選的勾選項，水平排列（如 行業別：■買賣 □製造 …）。
struct ClassicCheckboxGroup: Component {
    let items: [(label: String, checked: Bool)]

    var body: any Component {
        ComponentGroup {
            for item in items {
                ClassicCheckbox(label: item.label, isChecked: item.checked)
            }
        }
    }
}
