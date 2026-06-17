//
//  InterviewInfoSection.swift
//  PDFGenerator
//
//  訪談紀錄 — 對應 Frontend interview-info.component。
//  每筆：title（灰）+ description（多行文字，換行轉 <br>；無內容顯示 -）。
//

import Plot

public struct InterviewInfoSection: Component {
    let items: [Item]

    public var body: any Component {
        Div {
            for item in items {
                Div {
                    Div(Paragraph(item.title)).class("title")
                    if let description = item.description, !description.isEmpty {
                        // markdown → HTML（清單、粗體、換行…）
                        Div(html: MarkdownHTML.render(description)).class("description")
                    } else {
                        Div(Text("-")).class("description")
                    }
                }.class("unit")
            }
        }.class("interviewInfo")
    }

    public init(items: [Item]) {
        self.items = items
    }
}

extension InterviewInfoSection {
    public struct Item {
        let title: String
        let description: String?

        public init(title: String, description: String? = nil) {
            self.title = title
            self.description = description
        }
    }
}
