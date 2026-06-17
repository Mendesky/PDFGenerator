//
//  MaintenanceInfoSection.swift
//  PDFGenerator
//
//  熟悉人員/會計師、客戶來源、訪談人 — 對應 Frontend maintenance-info.component。
//  staff 以 [事務所][部門] 灰框 chip + 粗體姓名呈現。
//

import Plot

public struct MaintenanceInfoSection: Component {
    let familiarPersons: [Staff]
    let source: String
    let interviewers: [Staff]

    public var body: any Component {
        Div {
            staffUnit(title: "熟悉人員/會計師", staffs: familiarPersons)
            Div {
                Div(Paragraph("客戶來源")).class("title")
                Div(Paragraph(source).class("bold")).class("source")
            }.class("unit")
            staffUnit(title: "訪談人", staffs: interviewers)
        }.class("maintenanceInfo")
    }

    private func staffUnit(title: String, staffs: [Staff]) -> Component {
        Div {
            Div(Paragraph(title)).class("title")
            Div {
                for staff in staffs {
                    Div {
                        Div {
                            Div(Paragraph(staff.firmName)).class("label")
                            Div(Paragraph(staff.department)).class("label")
                        }.class("info")
                        Div(Paragraph(staff.name).class("bold")).class("name")
                    }.class("staff")
                }
            }.class("staffContainer")
        }.class("unit")
    }

    public init(familiarPersons: [Staff], source: String, interviewers: [Staff]) {
        self.familiarPersons = familiarPersons
        self.source = source
        self.interviewers = interviewers
    }
}

extension MaintenanceInfoSection {
    public struct Staff {
        let firmName: String
        let department: String
        let name: String

        public init(firmName: String, department: String, name: String) {
            self.firmName = firmName
            self.department = department
            self.name = name
        }
    }
}
