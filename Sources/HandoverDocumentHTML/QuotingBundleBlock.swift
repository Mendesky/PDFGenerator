//
//  QuotingBundleBlock.swift
//  PDFGenerator
//
//  報價 bundle 區塊 — 對應 Frontend quoting-bundle.component。
//  結構：bundle → units → services(alias) → serviceItems → configs(name:value)。
//  bundle 數 > 1 時才顯示 bundle 名；右側顯示金額與計費週期。
//

import Foundation
import Plot

public struct QuotingBundleBlock: Component {
    let bundles: [QuotingBundle]

    public var body: any Component {
        let showBundleName = bundles.count > 1
        return Div {
            for (offset, bundle) in bundles.enumerated() {
                Div {
                    if showBundleName {
                        Div(Paragraph(bundle.name)).class("bundleName")
                    }
                    for unit in bundle.units {
                        // 用 table 取代 flex：services cell + 右側 price cell（WeasyPrint flex 巢狀百分比寬不穩）
                        Table {
                            TableRow {
                                TableCell {
                                    for service in unit.services {
                                        Div {
                                            Div(Paragraph(service.alias)).class("serviceName")
                                            Div {
                                                for item in service.items {
                                                    Div {
                                                        for config in item.configs {
                                                            Div {
                                                                Div(Paragraph(config.name)).class("configKey")
                                                                Paragraph(config.value)
                                                            }.class("configUnit")
                                                        }
                                                    }.class("configs")
                                                }
                                            }.class("items")
                                        }.class("service")
                                    }
                                }.class("services")
                                TableCell {
                                    Paragraph(unit.price.thousandSeparated).class("dollar")
                                    Paragraph("元 / \(unit.billingPeriod.text)").class("period")
                                }.class("price")
                            }
                        }.class("unit")
                    }
                }.class("bundle")
                if offset < bundles.count - 1 {
                    Div().class("dottedLine")
                }
            }
        }.class("quotingBundle")
    }

    public init(bundles: [QuotingBundle]) {
        self.bundles = bundles
    }
}

extension QuotingBundleBlock {
    public struct QuotingBundle {
        let name: String
        let units: [QuotingUnit]

        public init(name: String, units: [QuotingUnit]) {
            self.name = name
            self.units = units
        }
    }

    public struct QuotingUnit {
        let billingPeriod: BillingPeriod
        let price: Decimal
        let services: [QuotingService]

        public init(billingPeriod: BillingPeriod, price: Decimal, services: [QuotingService]) {
            self.billingPeriod = billingPeriod
            self.price = price
            self.services = services
        }
    }

    public struct QuotingService {
        let alias: String
        let items: [ServiceItem]

        public init(alias: String, items: [ServiceItem]) {
            self.alias = alias
            self.items = items
        }
    }

    public struct ServiceItem {
        let configs: [Config]

        public init(configs: [Config]) {
            self.configs = configs
        }
    }

    public struct Config {
        let name: String
        let value: String

        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
}
