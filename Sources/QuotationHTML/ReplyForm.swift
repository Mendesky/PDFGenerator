//
//  ReplyForm.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//
import Plot

public struct ReplyForm: Component{
    let receiver: String
    let sender: Organization
    let subject: String
    let payments: [Payment]
    let additionalServices: [AdditionalService]
    let quotationNo: String?
    let showCompanyStamp: Bool
    
    public var body: any Component{
        ComponentGroup{
            H2("同意函").style("text-align: center;")
            Table{
                TableRow{
                    TableCell("受文者：").style("width: 70px; white-space: nowrap; vertical-align: top")
                    TableCell(sender.displayName)
                }
                TableRow{
                    TableCell("主　旨：").style("white-space: nowrap; vertical-align: top")
                    TableCell(subject)
                }
                TableRow{
                    TableCell("")
                    TableCell("酬　金：").style("white-space: nowrap; vertical-align: top")
                }
                TableRow{
                    TableCell("")
                    TableCell{
                        ReplyFormPaymentBlock(payments: payments)
                    }
                }
                if additionalServices.count > 0 {
                    TableRow{
                        TableCell("")
                        TableCell("附加服務請勾選：").style("white-space: nowrap; vertical-align: top;")
                    }
                    for additionalService in additionalServices{
                        TableRow{
                            TableCell("")
                            if additionalService.isSelected == false {
                                TableCell("□\(additionalService.name)")
                            } else {
                                TableCell("☑\(additionalService.name)")
                            }
                        }.style("font-size: 0.875rem;")
                    }
                }
                TableRow{
                    TableCell("附　件：")
                    if let quotationNo {
                        TableCell("嘉威稅字第\(quotationNo)號公費報價單")
                    }
                }
            }.style("width: 100%;")
            Node.br()
            Table{
                TableRow{
                    TableCell().style("width: 102px;")
                    TableCell(receiver)
                    TableCell().style("width: 10rem;")
                }
                TableRow{
                    TableCell()
                    TableCell()
                    if showCompanyStamp {
                        TableCell("（公　司　章）　　").style("height: 6rem;vertical-align: top;")
                    }else{
                        TableCell("　").style("height: 6rem;vertical-align: top;")
                    }
                }
                
                TableRow{
                    TableCell()
                    TableCell()
                    TableCell("（授權人簽名或蓋章）").style("height: 6rem;vertical-align: top;")
                }
            }.style("width: 100%;")
            Div{
                Paragraph("中　　華　　民　　國")
                Paragraph("年")
                Paragraph("月")
                Paragraph("日")
            }.style("display: flex; justify-content: space-between; width: 100%; margin: 0 auto; position: absolute; bottom: 0px;")
        }
        
    }
    
    public init(receiver: String, sender: String, subject: String, payments: [Payment] = [], additionalServices: [AdditionalService], quotationNo: String?, showCompanyStamp: Bool = true) {
        self.receiver = receiver
        self.sender = Organization(rawValue: sender)
        self.subject = subject
        self.payments = payments
        self.additionalServices = additionalServices
        self.quotationNo = quotationNo
        self.showCompanyStamp = showCompanyStamp
    }
    
    public init(receiver: String, sender: Organization, subject: String, payments: [Payment.Model] = [], additionalServices: [AdditionalService], quotationNo: String?, showCompanyStamp: Bool = true) {
        self.receiver = receiver
        self.sender = sender
        self.subject = subject
        self.payments = .init(payments)
        self.additionalServices = additionalServices
        self.quotationNo = quotationNo
        self.showCompanyStamp = showCompanyStamp
    }
    
    public init(receiver: String, sender: Organization, quotationNo: String?, model: Model) {
        self.receiver = receiver
        self.sender = sender
        self.subject = model.subject
        self.payments = .init(model.payments)
        self.additionalServices = .init(model.additionalServices)
        self.quotationNo = quotationNo
        self.showCompanyStamp = model.showCompanyStamp
    }
}

extension ReplyForm{
    public struct Model {
        let subject: String
        let payments: [Payment.Model]
        let additionalServices: [AdditionalService.Model]
        let showCompanyStamp: Bool
        
        public init(subject: String, payments: [Payment.Model], additionalServices: [AdditionalService.Model], showCompanyStamp: Bool) {
            self.subject = subject
            self.payments = payments
            self.additionalServices = additionalServices
            self.showCompanyStamp = showCompanyStamp
        }
    }
}
