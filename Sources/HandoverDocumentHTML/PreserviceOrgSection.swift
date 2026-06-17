//
//  PreserviceOrgSection.swift
//  PDFGenerator
//
//  前手事務所 — 對應 Frontend preservice-organization-info.component。
//  每筆：title（灰）+ 其一：value（文字）或 labels（chip 群）。
//  例：前所名稱 -；前所服務業務 [記帳][年度CTP]；前所資訊及更換原因 [服務不好]。
//

import Plot

public struct PreserviceOrgSection: Component {
    let items: [Item]

    public var body: any Component {
        Div {
            for item in items {
                Div {
                    Div(Paragraph(item.title).class("title")).class("padding4")
                    if let value = item.value {
                        Div(Paragraph(value).class("content")).class("padding4")
                    }
                    if let labels = item.labels {
                        Div {
                            for label in labels {
                                Div(Paragraph(label).class("text")).class("label")
                            }
                        }.class("labelContainer")
                    }
                }.class("unit")
            }
        }.class("preserviceOrg")
    }

    public init(items: [Item]) {
        self.items = items
    }
}

extension PreserviceOrgSection {
    public struct Item {
        let title: String
        let value: String?
        let labels: [String]?

        public init(title: String, value: String? = nil, labels: [String]? = nil) {
            self.title = title
            self.value = value
            self.labels = labels
        }
    }
}
