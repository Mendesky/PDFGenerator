//
//  AdditionalServiceBlock.swift
//  PDFGenerator
//
//  附加服務區塊 — 對應 Frontend additional-service.component。
//

import Foundation
import Plot

public struct AdditionalServiceBlock: Component {
    let units: [AdditionalQuotingUnit]

    public var body: any Component {
        Div {
            Div(Paragraph("附加服務")).class("title")
            Div {
                if units.isEmpty {
                    Paragraph("-")
                } else {
                    for unit in units {
                        // 用 table：名稱 cell + 右側 price cell
                        Table {
                            TableRow {
                                TableCell {
                                    for name in unit.services {
                                        Div(Paragraph(name)).class("name")
                                    }
                                }.class("nameCell")
                                TableCell {
                                    Paragraph(unit.price.thousandSeparated).class("dollar")
                                    Paragraph("元 / \(unit.billingPeriod.text)").class("period")
                                }.class("price")
                            }
                        }.class("unit")
                    }
                }
            }.class("servicesContainer")
        }.class("additionalService")
    }

    public init(units: [AdditionalQuotingUnit]) {
        self.units = units
    }
}

extension AdditionalServiceBlock {
    public struct AdditionalQuotingUnit {
        let services: [String]
        let billingPeriod: BillingPeriod
        let price: Decimal

        public init(services: [String], billingPeriod: BillingPeriod, price: Decimal) {
            self.services = services
            self.billingPeriod = billingPeriod
            self.price = price
        }
    }
}
