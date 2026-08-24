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
                                // 縮排只有一層：內文與編號項**共用** `Self.bodyIndent`，都縮在標題底下。
                                // 原本是外層 2em ＋ 自身 3em ＋ text-indent 2em，而編號項另外 3.8em ——
                                // 三個不同深度，一層比一層右。首行縮排由資料本身的全形空格表達，不由 CSS 加。
                                Div(html: ServiceContentHTMLRenderer.render(markdown: term))
                                    .style("display: flex;")
                            }
                        }.style("display: flex; flex-direction: column; padding-left: \(Self.bodyIndent);")
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
                                //
                                // **margin 不歸零**：先前一併寫了 `margin: 0`，那超出「對齊」的需要——
                                // 它拿掉的是 `<ol>` 預設的上下 margin，也就是「內文與第一個編號項之間」
                                // 那道間距，結果整段看起來比原本更擠。行距本身沒動過（1.5em，
                                // 設在 Quotation.swift 的根容器），變窄的是區塊間距。
                                .style("list-style-position: inside; padding-left: 0;")
                                // 編號與內文共用同一條左緣：外層用同一個 `bodyIndent`，清單自身不再吃
                                // 瀏覽器預設的 padding（約 40px），標記 `inside` 排進文字流。
                            }.style("display: flex; padding-left: \(Self.bodyIndent);")
                        }
                    }.style("display: flex; flex-direction: column;  break-inside: avoid-page; ")
                }
            }
        }
    }
    
    /// 內文與編號項共用的縮排深度（相對於區塊左緣）。
    ///
    /// 兩者**必須用同一個值**——它們在版面上是同一層；分開寫就是先前「一層比一層右」的來源。
    ///
    /// `5em` 是算出來的，不是估的：標題自己 `text-indent: 2em`，前綴「（一）」佔 3 個全形字（≈3em），
    /// 所以標題第一個字（例：「稅務帳務處理作業」的「稅」）落在 5em —— 內文與編號項對齊到那裡。
    static let bodyIndent = "5em"

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
