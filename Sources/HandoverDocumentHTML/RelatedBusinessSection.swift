//
//  RelatedBusinessSection.swift
//  PDFGenerator
//
//  關係企業清單 — 對應 Frontend related-business-info.component。
//  依關係類型分組（標題含家數），每家：統編 + 名稱 + 服務人員 chip（或「非所客」）+ 說明。
//  全部為空時顯示 -。
//

import Plot

public struct RelatedBusinessSection: Component {
    let blocks: [Block]

    private var isEmpty: Bool {
        blocks.allSatisfy { $0.companies.isEmpty }
    }

    public var body: any Component {
        Div {
            Div(Paragraph("關係企業清單")).class("title")
            Div {
                if isEmpty {
                    Div(Paragraph("-")).class("companysInfo")
                } else {
                    for block in blocks where !block.companies.isEmpty {
                        Div {
                            Div {
                                Div(Paragraph("\(block.title) (\(block.companies.count))")).class("label")
                            }.class("relatedType")
                            Div {
                                for company in block.companies {
                                    Div {
                                        // 第一行：統編 + 名稱
                                        Div {
                                            Div(Paragraph(company.businessId)).class("padding4")
                                            Div(Paragraph(company.name).class("name")).class("padding4")
                                        }.class("basicInfo")
                                        // 第二行：服務人員 chip（含小人形 icon）或非所客
                                        if let serviceEmployee = company.serviceEmployee {
                                            Div {
                                                Span(html: Self.employeeIconSVG).class("employeeIcon")
                                                Paragraph(serviceEmployee)
                                            }.class("employeeLabel")
                                        } else {
                                            Div(Paragraph("非所客")).class("nonClient")
                                        }
                                        // 第三行：關係說明（markdown）
                                        if !company.description.isEmpty {
                                            Div(html: MarkdownHTML.render(company.description)).class("description")
                                        }
                                    }.class("companyUnit")
                                }
                            }.class("companysInfo")
                        }.class("unit")
                    }
                }
            }.class("relatedContainer")
        }.class("relatedBusiness")
    }

    public init(blocks: [Block]) {
        self.blocks = blocks
    }
}

extension RelatedBusinessSection {
    /// 服務人員 badge 前的小人形 icon（對齊 Frontend related-business employeeIcon，白色）。
    static let employeeIconSVG = """
    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 14 14" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M6.89999 1.08C3.68399 1.08 1.08 3.684 1.08 6.9C1.08 7.836 1.302 8.718 1.692 9.498C1.974 9.228 2.298 9.006 2.658 8.832C2.328 8.454 2.124 7.962 2.124 7.422C2.124 6.246 3.078 5.292 4.25399 5.292C5.42999 5.292 6.38399 6.246 6.38399 7.422C6.38399 7.962 6.17999 8.454 5.84999 8.832C6.04199 8.922 6.22799 9.036 6.40199 9.156C6.77399 8.562 7.31399 8.076 7.95599 7.776C7.62599 7.398 7.42199 6.906 7.42199 6.366C7.42199 5.19 8.37599 4.236 9.55199 4.236C10.728 4.236 11.682 5.19 11.682 6.366C11.682 6.906 11.478 7.398 11.148 7.776C11.64 8.01 12.072 8.352 12.42 8.766C12.618 8.178 12.726 7.548 12.726 6.9C12.726 3.684 10.122 1.08 6.90599 1.08H6.89999ZM11.886 9.906C11.442 9.066 10.56 8.496 9.55199 8.496C8.54399 8.496 7.64399 9.078 7.19999 9.93C7.67999 10.56 7.96799 11.346 7.96799 12.198V12.624C9.62999 12.318 11.04 11.304 11.886 9.906ZM6.89399 12.72V12.198C6.89399 11.508 6.62999 10.878 6.19199 10.404C6.17999 10.392 6.17399 10.386 6.16799 10.374C5.68799 9.87 5.00999 9.552 4.25399 9.552C3.498 9.552 2.766 9.894 2.28 10.434C3.342 11.82 5.01599 12.714 6.89399 12.714V12.72ZM0 6.9C0 3.09 3.09 0 6.89999 0C10.71 0 13.8 3.09 13.8 6.9C13.8 10.71 10.71 13.8 6.89999 13.8C3.09 13.8 0 10.71 0 6.9ZM9.55199 5.316C8.96999 5.316 8.50199 5.784 8.50199 6.366C8.50199 6.948 8.96999 7.416 9.55199 7.416C10.134 7.416 10.602 6.948 10.602 6.366C10.602 5.784 10.134 5.316 9.55199 5.316ZM4.25399 6.378C3.67199 6.378 3.204 6.846 3.204 7.428C3.204 8.01 3.67199 8.478 4.25399 8.478C4.83599 8.478 5.30399 8.01 5.30399 7.428C5.30399 6.846 4.83599 6.378 4.25399 6.378Z" fill="white"/></svg>
    """

    public struct Block {
        let title: String
        let companies: [Company]

        public init(title: String, companies: [Company]) {
            self.title = title
            self.companies = companies
        }
    }

    public struct Company {
        let businessId: String
        let name: String
        /// 服務人員（部門 + 姓名）；nil 表示「非所客」。
        let serviceEmployee: String?
        let description: String

        public init(businessId: String, name: String, serviceEmployee: String? = nil, description: String) {
            self.businessId = businessId
            self.name = name
            self.serviceEmployee = serviceEmployee
            self.description = description
        }
    }
}
