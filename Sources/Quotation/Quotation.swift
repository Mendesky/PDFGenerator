// The Swift Programming Language
// https://docs.swift.org/swift-book

import Plot
import Foundation

struct Page{
    static var `break`: Component{
        Paragraph().style("page-break-before: always;")
    }
}


public struct BusinessClientQuotation: Renderable {
    let purpose: ContentItem
    let payment: Payment
    let serviceScope: ServiceScope
    let letterHeader: LetterHeader
    let assistance: BusinessClientAssistance
    let notes: Note
    let replyForm: ReplyForm
    
    public init(purpose: ContentItem, payment: Payment, serviceScope: ServiceScope, letterHeader: LetterHeader, assistance: BusinessClientAssistance, notes: Note, replyForm: ReplyForm) {
        self.purpose = purpose
        self.payment = payment
        self.serviceScope = serviceScope
        self.letterHeader = letterHeader
        self.assistance = assistance
        self.notes = notes
        self.replyForm = replyForm
    }
    
    public func render(indentedBy indentationKind: Plot.Indentation.Kind?) -> String {
        HTML{
            ComponentGroup{
                Div{
                    letterHeader
                    Page.break
                    Table{
                        TableRow{
                            TableCell{
                                Paragraph("一、")}
                            .style("vertical-align: top;")
                            TableCell(purpose)
                        }
                        TableRow{
                            TableCell{
                                Paragraph("二、")}
                            .style("vertical-align: top;")
                            TableCell(serviceScope)
                        }
                        TableRow{
                            TableCell{
                                Paragraph("三、")}
                            .style("vertical-align: top;")
                            TableCell(assistance)
                        }
                    }
                    Page.break
                    Table{
                        TableRow{
                            TableCell{
                                Paragraph("四、")}
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
                }.style("font-family: 標楷體-繁;width: 100%;")
            }
        }
        .render(indentedBy: indentationKind)
    }
    
}


extension BusinessClientQuotation{
    public static var headerHTML: Component{
        ComponentGroup{
            Header{
                Image(Bundle.module.url(forResource: "quotation-header", withExtension: "png")!)
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
                Image(Bundle.module.url(forResource: "quotation-footer", withExtension: "png")!)
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
            height: 100px;
        }
        """)
        }
    }
}
