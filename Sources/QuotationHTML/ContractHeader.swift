//
//  ContractForm.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/25.
//
import Plot

public struct ContractHeader: Component {
    let client: QuotationClient
    let sender: Organization
    let subject: String
    let content: String

    /// 單一公司的便捷建構。集團請走 `init(client:...)`。
    public init(receiver: String, sender: String, subject: String, content: String) {
        self.client = .single(name: receiver)
        self.sender = Organization(rawValue: sender)
        self.subject = subject
        self.content = content
    }

    public init(client: QuotationClient, sender: String, subject: String, content: String) {
        self.client = client
        self.sender = Organization(rawValue: sender)
        self.subject = subject
        self.content = content
    }

    init(client: QuotationClient, sender: Organization, model: Model){
        self.client = client
        self.sender = sender
        self.subject = model.subject
        self.content = model.content
    }
    
    public var body: any Component{
        ComponentGroup{
            Table{
                TableRow{
                    TableCell("受 文 者：").style("vertical-align: top; width: 6em; font-size: 1rem;")
                    // 集團以頓號串接並附「共N家」（`inlineJoinedText`）；「（以下簡稱 貴公司）」
                    // 是公文樣板，留在本 component 不下放給呼叫端。
                    TableCell("\(client.inlineJoinedText)（以下簡稱 貴公司）").style("font-size: 1rem;")
                }
                TableRow{
                    TableCell("發 文 者：").style("vertical-align: top; font-size: 1rem;")
                    TableCell("\(sender.displayName)（以下簡稱 本事務所）").style("font-size: 1rem;")
                }
                TableRow{
                    TableCell("主    旨：").style("vertical-align: top; font-size: 1rem;")
                    TableCell(subject).style("font-size: 1rem;")
                }
                TableRow{
                    TableCell("說    明：").style("vertical-align: top; font-size: 1rem;")
                    TableCell(content).style("font-size: 1rem;")
                }
            }.style("margin: 2rem 2rem 3rem 2rem;")
        }
    }
    
}

extension ContractHeader {
    public struct Model {
        let subject: String
        let content: String
        
        public init(subject: String, content: String) {
            self.subject = subject
            self.content = content
        }
    }
}
