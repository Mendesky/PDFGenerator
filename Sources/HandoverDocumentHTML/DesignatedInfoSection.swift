//
//  DesignatedInfoSection.swift
//  PDFGenerator
//
//  指派資訊 — 對應 Frontend designated-info.component。
//  每筆：title（灰）+ strongInfoTitle（粗）為標籤，value 為值。
//  例：客戶指定 / 簽證會計師 / 無；客戶指定 / 服務組別 / 台中所 審3。
//

import Plot

public struct DesignatedInfoSection: Component {
    let items: [Item]

    public var body: any Component {
        Div {
            for item in items {
                Div {
                    Div {
                        Paragraph(item.title).class("title")
                        Paragraph(item.strongInfoTitle).class("bold")
                    }.class("labelGroup")
                    Paragraph(item.value).class("value")
                }.class("service")
            }
        }.class("designatedInfo")
    }

    public init(items: [Item]) {
        self.items = items
    }
}

extension DesignatedInfoSection {
    public struct Item {
        let title: String
        let strongInfoTitle: String
        let value: String

        public init(title: String, strongInfoTitle: String, value: String) {
            self.title = title
            self.strongInfoTitle = strongInfoTitle
            self.value = value
        }
    }
}
