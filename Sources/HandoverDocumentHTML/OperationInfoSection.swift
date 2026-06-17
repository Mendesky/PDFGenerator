//
//  OperationInfoSection.swift
//  PDFGenerator
//
//  營運資訊 — 對應 Frontend operation-info.component。
//  以群組呈現，群組可水平（並排，如 扣繳人數 / 分支機構家數）或垂直
//  （堆疊，如 營業項目及產品）。每個 unit：title（灰）+ text。
//

import Plot

public struct OperationInfoSection: Component {
    let groups: [Group]

    public var body: any Component {
        Div {
            for group in groups {
                Div {
                    for unit in group.units {
                        Div {
                            Div(Paragraph(unit.title)).class("title")
                            Div(Paragraph(unit.text)).class("content")
                        }.class("unit")
                    }
                }.class(group.direction.rawValue)
            }
        }.class("operationInfo")
    }

    public init(groups: [Group]) {
        self.groups = groups
    }
}

extension OperationInfoSection {
    public enum Direction: String {
        case horizontal
        case vertical
    }

    public struct Group {
        let direction: Direction
        let units: [Unit]

        public init(direction: Direction, units: [Unit]) {
            self.direction = direction
            self.units = units
        }
    }

    public struct Unit {
        let title: String
        let text: String

        public init(title: String, text: String) {
            self.title = title
            self.text = text
        }
    }
}
