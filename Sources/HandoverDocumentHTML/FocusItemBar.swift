//
//  FocusItemBar.swift
//  PDFGenerator
//
//  重點資訊列 — 對應 Frontend focus-item.component。
//  一排可換行的 chip，每個 = 白底邊框標籤（leftText [+ rightText]）+ 下方粗體值。
//  leftText/rightText 其一可加粗（boldSide），對應原 boldPosition。
//

import Plot

public struct FocusItemBar: Component {
    let items: [FocusItem]

    public var body: any Component {
        Div {
            for item in items {
                Div {
                    Div {
                        Paragraph(item.leftText).class(item.boldSide == .left ? "text bold" : "text")
                        if !item.rightText.isEmpty {
                            Paragraph(item.rightText).class(item.boldSide == .right ? "text bold" : "text")
                        }
                    }.class("type")
                    Paragraph(item.value).class("text value")
                }.class("item")
            }
        }.class("focusBar")
    }

    public init(items: [FocusItem]) {
        self.items = items
    }
}

extension FocusItemBar {
    public enum BoldSide {
        case left
        case right
    }

    public struct FocusItem {
        let leftText: String
        let rightText: String
        let boldSide: BoldSide?
        let value: String

        public init(leftText: String, rightText: String = "", boldSide: BoldSide? = nil, value: String) {
            self.leftText = leftText
            self.rightText = rightText
            self.boldSide = boldSide
            self.value = value
        }
    }
}
