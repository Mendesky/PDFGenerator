// The Swift Programming Language
// https://docs.swift.org/swift-book

import Plot
import Foundation

struct Page{
    static var `break`: Component{
        Paragraph().style("page-break-before: always;")
    }
}

protocol TitleContainableComponent: TitleContainable, Component{}

extension ContentItem: TitleContainableComponent {}
extension ServiceScope: TitleContainableComponent {}
extension BusinessClientAssistance: TitleContainableComponent {}
extension Payment: TitleContainableComponent {}

public struct BusinessClientQuotation: Renderable {
    let no: String?
    let purpose: ContentItem?
    let payment: Payment
    let serviceScope: ServiceScope
    let letterHeader: LetterHeader
    let assistance: BusinessClientAssistance?
    let notes: Note
    let replyForm: ReplyForm
    let contractHeader: ContractHeader?

    public init(no: String?, purpose: ContentItem?, payment: Payment, serviceScope: ServiceScope, letterHeader: LetterHeader, assistance: BusinessClientAssistance?, notes: Note, replyForm: ReplyForm, contractHeader: ContractHeader?) {
        self.no = no
        self.purpose = purpose
        self.payment = payment
        self.serviceScope = serviceScope
        self.letterHeader = letterHeader
        self.assistance = assistance
        self.notes = notes
        self.replyForm = replyForm
        self.contractHeader = contractHeader
    }

    func getTitleContainableItems() -> [TitleContainableComponent] {
        let items:[(any TitleContainableComponent)?] = [purpose, serviceScope, assistance]
        return items.compactMap{ $0 }
    }
    
    public func render(indentedBy indentationKind: Plot.Indentation.Kind?) -> String {
        let components = getTitleContainableItems()
        let html = HTML{
            ComponentGroup{
                Div{
                    letterHeader
                    Page.break
                    H3("專業服務公費報價單").style("text-align: center;")
                    if let no {
                        Paragraph("嘉威稅字第\(no)號").style("font-size: 11px;text-align: right;")
                    }
                    contractHeader
                    Table{
                        for (index, item) in components.enumerated() {
                            let chineseNumber = toChineseNumber(index: index)
                            TableRow(TableCell("\(chineseNumber)、\(item.title)"))
                            TableRow(TableCell(item))
                        }
                    }
//                    Page.break
                    Table{
                        let chineseNumber = toChineseNumber(index: components.count)
                        TableRow{
                            TableCell{
                                Paragraph("\(chineseNumber)、")}
                            .style("vertical-align: top;")
                            TableCell(payment)
                        }
                        TableRow{
                            TableCell()
                            TableCell(notes)
                        }
                    }
                    Page.break
                    replyForm
                }.style("font-family: 華康標楷體,標楷體-繁,標楷體;width: 100%;")
            }
        }
        return html.render(indentedBy: indentationKind)
    }
    
}


extension BusinessClientQuotation{
    public var headerHTML: Component{
        ComponentGroup{
            Header{
                Image(Bundle.module.url(forResource: replyForm.sender.headerResource, withExtension: "png")!)
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
                Image(Bundle.module.url(forResource: replyForm.sender.footerResource, withExtension: "png")!)
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

    public static var headerHTML: Component{
        ComponentGroup{
            Header{
                Image(Bundle.module.url(forResource: "jw-quotation-header", withExtension: "png")!)
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
    
    public static var footerHTML: Component{
        ComponentGroup{
            Footer{
                Image(Bundle.module.url(forResource: "jw-quotation-footer", withExtension: "png")!)
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
