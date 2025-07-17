// The Swift Programming Language
// https://docs.swift.org/swift-book

import Plot
import Foundation

struct Page{
    static var `break`: Component{
        Paragraph().style("break-before: page;")
    }
}


protocol TitleContainableComponent: TitleContainable, Component{}

extension ContentItem: TitleContainableComponent {}
extension ServiceScope: TitleContainableComponent {}
extension BusinessClientAssistance: TitleContainableComponent {}

public struct AuditQuotation: Renderable {
    let no: String?
    let purpose: ContentItem?
    let paymentBlock: PaymentBlock
    let serviceScope: ServiceScope
    let letterHeader: LetterHeader
    let assistance: BusinessClientAssistance?
    let notes: Note
    let replyForm: ReplyForm
    let contractHeader: ContractHeader?
    let rightsAndObligations: ContractSection?

    public init(no: String?, purpose: ContentItem?, paymentBlock: PaymentBlock, serviceScope: ServiceScope, letterHeader: LetterHeader, assistance: BusinessClientAssistance?, notes: Note, replyForm: ReplyForm, contractHeader: ContractHeader?, rightsAndObligations: ContractSection? = nil) {
        self.no = no
        self.purpose = purpose
        self.paymentBlock = paymentBlock
        self.serviceScope = serviceScope
        self.letterHeader = letterHeader
        self.assistance = assistance
        self.notes = notes
        self.replyForm = replyForm
        self.contractHeader = contractHeader
        self.rightsAndObligations = rightsAndObligations
    }

    func getTitleContainableItems() -> [TitleContainableComponent] {
        let items:[(any TitleContainableComponent)?] = [purpose, serviceScope, assistance]
        return items.compactMap{ $0 }
    }
    
    public func render(indentedBy indentationKind: Plot.Indentation.Kind?) -> String {
        let components = getTitleContainableItems()
        let html = HTML{
            letterHeader
            Page.break
            H3("專業服務公費報價單").style("text-align: center; font-size: 1.5rem;")
            if let no {
                Paragraph("嘉威稅字第\(no)號").style("font-size: 0.6875rem; text-align: right;")
            }
            
            if let contractHeader {
                contractHeader.style("font-size: 0.9rem;")
            }
            
            for (index, item) in components.enumerated() {
                item.set(index: index)
            }
            Table{
                let chineseNumber = toChineseNumber(index: components.count)
                TableRow{
                    TableCell{
                        Paragraph("\(chineseNumber)、")
                    }.style("vertical-align: top;")
                    TableCell(paymentBlock)
                }.style("break-inside: avoid-page;")
                TableRow{
                    TableCell()
                    TableCell(notes)
                }
            }
            Node.br()
            if let rightsAndObligations{
                rightsAndObligations.set(index: components.count + 1)
            }
            Page.break
            replyForm
        }.node.style("font-family: 華康標楷體,標楷體-繁,標楷體; width: 100%; line-height: 1.5em; font-size: 16px;" )
        return html.render(indentedBy: indentationKind)
    }
    
}


extension AuditQuotation{
    public var headerHTML: Component{
        ComponentGroup{
            Header{
                if let fileUrl = Bundle.module.url(forResource: replyForm.sender.headerResource, withExtension: "png"){
                    Image(fileUrl)
                }
            }
            
            Node<String>.element(named: "style", text: """
        img{
            width: 80%;
        }
        header {
            top: 50px;
            position: fixed;
            
            /*left: 0;*/
            text-align: center;
            
            height: 138px;
            width: 100%;
        }
        """)
        }
    }

    public var footerHTML: Component{
        ComponentGroup{
            Footer{
                if let fileUrl = Bundle.module.url(forResource: replyForm.sender.footerResource, withExtension: "png"){
                    Image(fileUrl)
                }
            }
            
            Node<String>.element(named: "style", text: """
        img{
            width: 80%;
        }
        footer {
            position: fixed;
            bottom: 0;
            text-align: center;     
            width: 100%;
            height: 116px;
        }
        """)
        }
    }
}
