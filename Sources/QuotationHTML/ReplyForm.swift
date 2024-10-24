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
    let additionalServices: [String]
    let quotationNo: String?
    
    public var body: any Component{
        ComponentGroup{
            H2("同意函").style("text-align: center;")
            Table{
                TableRow{
                    TableCell("受文者：").style("width: 70px;")
                    TableCell(sender)
                }
                TableRow{
                    TableCell("主　旨：")
                    TableCell(subject)
                }
                TableRow{
                    TableCell("")
                    TableCell("附加服務請勾選：")
                }
                for additionalService in additionalServices{
                    TableRow{
                        TableCell("")
                        TableCell("□\(additionalService)")
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
    
    public init(receiver: String, sender: String, subject: String, additionalServices: [String], quotationNo: String) {
        self.receiver = receiver
        self.sender = sender
        self.subject = subject
        self.additionalServices = additionalServices
        self.quotationNo = quotationNo
    }
}
