//
//  ContractForm.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/25.
//
import Plot

public struct ContractForm: Component {
    let receiver: String
    let sender: String
    let subject: String
    let description: String
    
    public init(receiver: String, sender: String, subject: String, description: String) {
        self.receiver = receiver
        self.sender = sender
        self.subject = subject
        self.description = description
    }
    
    public var body: any Component{
        ComponentGroup{
            Table{
                TableRow{
                    TableCell("受 文 者：").style("vertical-align: top; width: 6em;")
                    TableCell("\(receiver)（以下簡稱 貴公司）")
                }
                TableRow{
                    TableCell("發 文 者：").style("vertical-align: top;")
                    TableCell("\(sender)（以下簡稱 本事務所）")
                }
                TableRow{
                    TableCell("主    旨：").style("vertical-align: top;")
                    TableCell(subject)
                }
                TableRow{
                    TableCell("說    明：").style("vertical-align: top;")
                    TableCell(description)
                }
            }.style("font-size: 12px; margin: 2rem 2rem 3rem 2rem;")
        }
    }
}
