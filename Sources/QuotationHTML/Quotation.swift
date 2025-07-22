// The Swift Programming Language
// https://docs.swift.org/swift-book

import Plot
import Foundation

struct Page{
    static var `break`: Component{
        Paragraph().style("break-before: page;")
    }
}

public struct AuditQuotation: Renderable {
    let no: String?
    let receiver: String
    let sender: Organization
    let purpose: Purpose.Model?
    let payments: [Payment.Model]
    let serviceScope: ServiceScope.Model
    let letterHeader: LetterHeader.Model
    let assistance: BusinessClientAssistance.Model?
    let notes: [Note.Model]
    let replyForm: ReplyForm.Model
    let contractHeader: ContractHeader.Model?
    let rightsAndObligations: RightsAndObligation.Model?
    
    @available(*, deprecated, message: "This initialize method scope will be converted to private in the future nearly.")
    public init(no: String?, purpose: ContentItem?, paymentBlock: PaymentBlock, serviceScope: ServiceScope, letterHeader: LetterHeader, assistance: BusinessClientAssistance?, notes: Note, replyForm: ReplyForm, contractHeader: ContractHeader?, rightsAndObligations: ContractSection? = nil) {
        self.no = no
        self.receiver = replyForm.receiver
        self.sender = replyForm.sender
        self.purpose = purpose.map{
            .init(title: $0.title, content: $0.content)
        }
        self.payments = paymentBlock.payments.map{
            .init(name: $0.name, items: $0.items.map{
                .init(names: $0.names, fee: $0.fee)
            }, needShowName: $0.needShowName)
        }
        self.serviceScope = .init(title: serviceScope.title, heading: serviceScope.heading, items: serviceScope.items.map{
            $0.map{
                .init(title: $0.title, term: $0.term, serviceItemTerms: $0.serviceItemTerms.map{
                    $0.map{
                        .init(content: $0.term)
                    }
                })
            }
        })
        
        self.letterHeader = .init(to: letterHeader.to, from: letterHeader.from, content: letterHeader.content, date: letterHeader.date, blessings: letterHeader.blessings)
        self.assistance = assistance.map{
            .init(title: $0.title, items: $0.items.map{
                .init(title: $0.content, content: $0.content)
            })
        }
        self.notes = notes.contents.map{
            .init(content: $0)
        }
        
        self.replyForm = .init(subject: replyForm.subject, payments: replyForm.payments.map{
            .init(name: $0.name, items: $0.items.map{
                .init(names: $0.names, fee: $0.fee)
            }, needShowName: $0.needShowName)
        }, additionalServices: replyForm.additionalServices.map{
            .init(name: $0.name, isSelected: $0.isSelected)
        }, showCompanyStamp: replyForm.showCompanyStamp)
        
        self.contractHeader = contractHeader.map{
            .init(subject: $0.subject, content: $0.content)
        }
        self.rightsAndObligations = rightsAndObligations.map{
            .init(title: $0.title, heading: $0.heading, terms: $0.provisions.map{
                $0.term
            })
        }
    }
    
    public init(no: String?, receiver: String, sender: Organization, purpose: Purpose.Model?, payments: [Payment.Model], serviceScope: ServiceScope.Model, letterHeader: LetterHeader.Model, assistance: BusinessClientAssistance.Model?, notes: [Note.Model], replyForm: ReplyForm.Model, contractHeader: ContractHeader.Model?, rightsAndObligations: RightsAndObligation.Model? = nil) {
        self.no = no
        self.receiver = receiver
        self.sender = sender
        self.purpose = purpose
        self.payments = payments
        self.serviceScope = serviceScope
        self.letterHeader = letterHeader
        self.assistance = assistance
        self.notes = notes
        self.replyForm = replyForm
        self.contractHeader =  contractHeader
        self.rightsAndObligations = rightsAndObligations
    }

    func build() -> (index: Int, components: [any Component]) {
        var items: [any Component] = []
        var index = 0
        if let purpose {
            items.append(ContentItem(index: index, title: purpose.title, content: purpose.content))
            index += 1
        }
        
        
        items.append(ServiceScope(index: index, title: serviceScope.title, heading: serviceScope.heading, items: serviceScope.items))
        index += 1
        
        
        if let assistance {
            items.append(BusinessClientAssistance(index: index, title: assistance.title, items: assistance.items))
        }
        
        return (index, items)
    }
    
    public func render(indentedBy indentationKind: Plot.Indentation.Kind?) -> String {
        let (endIndex, components) = build()
        let html = HTML{
            LetterHeader(quotingOrganization: sender, model: letterHeader)
            Page.break
            H3("專業服務公費報價單").style("text-align: center; font-size: 1.5rem;")
            if let no {
                Paragraph("嘉威稅字第\(no)號").style("font-size: 0.6875rem; text-align: right;")
            }
            
            if let contractHeader {
                ContractHeader(receiver: receiver, sender: sender, model: contractHeader).style("font-size: 0.9rem;")
            }
            
            for component in components {
                component
            }
            
            Table{
                let chineseNumber = components.count.representToChineseString(offset: 1)
                TableRow{
                    TableCell{
                        Paragraph("\(chineseNumber)、")
                    }.style("vertical-align: top;")
                    TableCell(PaymentBlock(payments: payments))
                }.style("break-inside: avoid-page;")
                TableRow{
                    TableCell()
                    TableCell(Note(models: notes))
                }
            }
            Node.br()
            if let rightsAndObligations{
                ContractSection.init(index: (components.count+1), title: rightsAndObligations.title, heading: rightsAndObligations.heading, provisions: rightsAndObligations.terms.map{
                    .init(term: $0)
                })
            }
            Page.break
            ReplyForm(receiver: receiver, sender: sender, quotationNo: no, model: replyForm)
        }.node.style("font-family: 華康標楷體,標楷體-繁,標楷體; width: 100%; line-height: 1.5em; font-size: 16px;" )
        return html.render(indentedBy: indentationKind)
    }
    
}


extension AuditQuotation{
    public var headerHTML: Component{
        ComponentGroup{
            Header{
                if let fileUrl = Bundle.module.url(forResource: sender.headerResource, withExtension: "png"){
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
                if let fileUrl = Bundle.module.url(forResource: sender.footerResource, withExtension: "png"){
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
