//
//  ContactSection.swift
//  PDFGenerator
//
//  聯絡人資料 + 公司聯絡資訊（合併 Frontend contact-info + comapny-contact-info，
//  兩者在 print-page 同一分隔區塊內相鄰）。
//  - contacts：姓名（粗）+ 稱謂 + 關係；各聯絡方式 title + 值
//  - 公司：核准設立日期、公司電話/傳真、登記地址、通訊地址
//

import Plot

public struct ContactSection: Component {
    let contacts: [Contact]
    let establishedDate: String?
    let telephones: [String]
    let faxes: [String]
    let registeredAddress: String?
    let communicationAddress: String?

    public var body: any Component {
        Div {
            Div(Paragraph("聯絡人資料")).class("title")
            for contact in contacts {
                Div {
                    Div {
                        if let relationship = contact.relationship {
                            Div(Paragraph(relationship)).class("relationship")
                        }
                        Div {
                            Paragraph(contact.name)
                            Paragraph(contact.gender).class("gender")
                        }.class("name")
                    }.class("padding4")
                    Div {
                        for method in contact.methods {
                            for (index, value) in method.values.enumerated() {
                                Div {
                                    if index == 0 {
                                        Paragraph(method.title).class("type")
                                    }
                                    Paragraph(value).class("right")
                                }.class(index == 0 ? "methodRow" : "methodRow rightContent")
                            }
                        }
                    }.class("communications")
                }.class("contactUnit")
            }

            if let establishedDate {
                Div {
                    Div(Paragraph("核准設立日期")).class("title")
                    Paragraph(establishedDate)
                }.class("unit")
            }
            Div {
                Div {
                    Div(Paragraph("公司電話")).class("title")
                    for telephone in telephones {
                        Paragraph(telephone)
                    }
                }.class("unit")
                Div {
                    Div(Paragraph("公司傳真")).class("title")
                    if faxes.isEmpty {
                        Paragraph("-")
                    } else {
                        for fax in faxes {
                            Paragraph(fax)
                        }
                    }
                }.class("unit")
            }.class("phone")
            if let registeredAddress {
                Div {
                    Div(Paragraph("公司登記地址")).class("title")
                    Paragraph(registeredAddress)
                }.class("unit")
            }
            if let communicationAddress {
                Div {
                    Div(Paragraph("公司通訊地址")).class("title")
                    Paragraph(communicationAddress)
                }.class("unit")
            }
        }.class("contactInfo")
    }

    public init(
        contacts: [Contact],
        establishedDate: String? = nil,
        telephones: [String] = [],
        faxes: [String] = [],
        registeredAddress: String? = nil,
        communicationAddress: String? = nil
    ) {
        self.contacts = contacts
        self.establishedDate = establishedDate
        self.telephones = telephones
        self.faxes = faxes
        self.registeredAddress = registeredAddress
        self.communicationAddress = communicationAddress
    }
}

extension ContactSection {
    public struct Contact {
        let name: String
        let gender: String
        let relationship: String?
        let methods: [Method]

        public init(name: String, gender: String, relationship: String? = nil, methods: [Method]) {
            self.name = name
            self.gender = gender
            self.relationship = relationship
            self.methods = methods
        }
    }

    public struct Method {
        let title: String
        let values: [String]

        public init(title: String, values: [String]) {
            self.title = title
            self.values = values
        }
    }
}
