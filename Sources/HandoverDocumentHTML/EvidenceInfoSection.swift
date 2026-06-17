//
//  EvidenceInfoSection.swift
//  PDFGenerator
//
//  統購（發票憑證）— 對應 Frontend evidence-info.component。
//  統購需求 + 統購開始期別 +（有期別時）各式發票數量列（名稱粗灰 + 值 + 單位）。
//

import Plot

public struct EvidenceInfoSection: Component {
    let purchaseArrangementType: String
    let purchaseStartDate: String?
    let counts: [Count]

    public var body: any Component {
        Div {
            Div {
                Paragraph("統購需求").class("grey60")
                Paragraph(purchaseArrangementType).class("text")
            }.class("gap8")
            if let purchaseStartDate {
                Div {
                    Paragraph("統購開始期別").class("grey60")
                    Paragraph(purchaseStartDate).class("text")
                }.class("gap8")
                Div {
                    for count in counts {
                        Div {
                            Paragraph(count.text).class("grey60 bold")
                            Paragraph(count.value).class("text")
                            if count.value != "-" {
                                Paragraph("(\(count.unit))").class("grey60")
                            }
                        }.class("evidence")
                    }
                }.class("gap4")
            }
        }.class("evidenceInfo")
    }

    public init(purchaseArrangementType: String, purchaseStartDate: String? = nil, counts: [Count] = []) {
        self.purchaseArrangementType = purchaseArrangementType
        self.purchaseStartDate = purchaseStartDate
        self.counts = counts
    }
}

extension EvidenceInfoSection {
    public struct Count {
        let text: String
        let value: String
        let unit: String

        public init(text: String, value: String, unit: String) {
            self.text = text
            self.value = value
            self.unit = unit
        }
    }
}
