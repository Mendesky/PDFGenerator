//
//  ReplyForm.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//
import Plot

public struct ReplyForm: Component{
    let receiver: String
    let sender: String
    let subject: String
    let paymentItems: [PaymentItem]
    let additionalServices: [AdditionalService]
    let quotationNo: String?
    
    public var body: any Component{
        ComponentGroup{
            H2("同意函").style("text-align: center;")
            Table{
                TableRow{
                    TableCell("受文者：").style("width: 70px; white-space: nowrap; vertical-align: top")
                    TableCell(sender)
                }
                TableRow{
                    TableCell("主　旨：").style("white-space: nowrap; vertical-align: top")
                    TableCell(subject)
                }
                TableRow{
                    TableCell("酬　金：").style("white-space: nowrap; vertical-align: top")
                    Table{
                        TableRow{
                            TableCell()
                            TableCell("服務項目")
                            TableCell("公費金額").style("white-space: nowrap")
                            TableCell()
                        }.style("border-bottom: 1pt solid black;")

                        for (index, item) in paymentItems.enumerated(){
                            TableRow{
                                TableCell("(\(index+1))")
                                item
                            }
                        }
                    }.style("border-collapse: collapse; font-size: 12px; width: 100%;")
                }
                TableRow{
                    TableCell("附加服務請勾選：").style("white-space: nowrap; vertical-align: top")
                    Table{
                        for additionalService in additionalServices{
                            TableRow{
                                TableCell("")
                                if additionalService.isSelected == false {
                                    TableCell("□\(additionalService.name)")
                                } else {
                                    TableCell("☑\(additionalService.name)")
                                }
                            }
                        }
                    }.style("border-collapse: collapse")
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
                    TableCell("（公　司　章）　　").style("height: 6rem;vertical-align: top;")
                }
                TableRow{
                    TableCell()
                    TableCell()
                    TableCell("（授權人簽名或蓋章）").style("height: 6rem;vertical-align: top;")
                }
            }.style("width: 100%;")
        }
        
    }
    
    public init(receiver: String, sender: String, subject: String, paymentItems: [PaymentItem], additionalServices: [AdditionalService], quotationNo: String?) {
        self.receiver = receiver
        self.sender = sender
        self.subject = subject
        self.paymentItems = paymentItems
        self.additionalServices = additionalServices
        self.quotationNo = quotationNo
    }
}
