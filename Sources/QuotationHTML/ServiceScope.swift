//
//  ServiceScope.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Plot

public struct ServiceScope: Component {
    let index: Int
    let title: String
    let heading: String
    let items: [QuotingServiceTerm]?
    
    public var body: any Component{
        ComponentGroup{
            Div{
                let chineseNumber = index.representToChineseString(offset: 1)
                Div(Text("\(chineseNumber)、\(title)")).style("font-size: 1.1em;")
                Paragraph(heading).style("text-indent: 2em;")
            }.style("break-inside: avoid-page;")
            
            if let items{
                
                for (offset, item) in items.enumerated() {
                    Div{
                        Div(Text("（\(offset.representToChineseString(offset: 1))）\(item.title)")).style("display: flex; text-indent: 2em;")
                        Div{
                            if let term = item.term{
                                // 服務內容吃 markdown（項目符號清單 + 段落內換行）；escape 由 renderer 負責，
                                // 見 ServiceContentHTMLRenderer。原本是 `Div(term)`：Plot 會 escape，
                                // 但完全不處理 `\n`，多行內容在 PDF 會連成一行。
                                //
                                // **無縮排**：原本是 `padding-left: 3em; text-indent: 2em`，疊上外層的 2em
                                // 之後內文比標題深了三層，編號項又是另一個深度 —— 三層遞進縮排。使用者要求
                                // 內文與編號項全部對齊同一條左緣（首行縮排由資料本身的全形空格表達，不由 CSS 加）。
                                Div(html: ServiceContentHTMLRenderer.render(markdown: term))
                                    .style("display: flex;")
                            }
                        }.style("display: flex; flex-direction: column;")
                        if let serviceItemTerms = item.serviceItemTerms{
                            Div{
                                List{
                                    for serviceItemTerm in serviceItemTerms {
                                        ListItem{
                                            for line in serviceItemTerm.term.split(separator: "\n"){
                                                Text(String(line)).addLineBreak()
                                            }
                                        }
                                    }
                                }
                                .environmentValue(.ordered, key: .listStyle)
                                // `<ol>` 自身仍會吃瀏覽器／weasyprint 預設的 padding-left（約 40px），
                                // 不關掉的話編號會比內文右一截。`inside` 讓「1.」排進文字流，與內文同左緣。
                                .style("list-style-position: inside; padding-left: 0; margin: 0;")
                                // 編號與內文共用同一條左緣：標記排進文字流（`inside`）、清單自身不再吃
                                // 瀏覽器預設的 padding。原本外層還有 `padding-left: 3.8em`，是三層縮排的最後一層。
                            }.style("display: flex;")
                        }
                    }.style("display: flex; flex-direction: column;  break-inside: avoid-page; ")
                }
            }
        }
    }
    
    public init(title: String, heading: String, items: [QuotingServiceTerm]?) {
        self.index = -1
        self.title = title
        self.heading = heading
        self.items = items
    }
    
    private init(index: Int, title: String, heading: String, items: [QuotingServiceTerm]?) {
        self.index = index
        self.title = title
        self.heading = heading
        self.items = items
    }
    
    internal init(index: Int, title: String, heading: String, items: [QuotingServiceTerm.Model]?) {
        self.index = index
        self.title = title
        self.heading = heading
        self.items = items.map{
            .init($0)
        }
    }
    
    internal init(index: Int, model: Model) {
        self.index = index
        self.title = model.title
        self.heading = model.heading
        self.items = model.items.map{
            $0.map{
                .init(model: $0)
            }
        }
    }
    
}


extension ServiceScope {
    public struct Model {
        let title: String
        let heading: String
        let items: [QuotingServiceTerm.Model]?
        
        public init(title: String, heading: String, items: [QuotingServiceTerm.Model]?) {
            self.title = title
            self.heading = heading
            self.items = items
        }
        
        
    }
}
