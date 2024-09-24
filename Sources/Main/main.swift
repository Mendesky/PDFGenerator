//
//  main.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Foundation
import Quotation
import Plot
import PDFGenerator

let header = LetterHeader(to: "全家人健康事業股份有限公司", from: "嘉威聯合會計師事務所", content: "茲將附上全家人健康事業股份有限公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證暨財會委外處理作業之專業服務公費報價單。 我們希望以最專業多元的服務與 貴公司長久配合，公費內容若經確認，煩請將最後一頁同意函簽章並回傳至敝事務所（FAX：2299-9901），謝謝您的合作。", date: Date(), blessings: "順頌 商祺")

print(header.render())


let purpose = ContentItem(title: "目的", content: "貴公司委託本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務，以協助　貴公司提升整體會計帳務品質，並符合相關稅務法令和企業會計準則等之規定。")
print(purpose.render())

print("\n")
let scope = ServiceScope(title: "服務範圍及內容", content: "本項專案作業之服務範圍將根據相關稅務法令、企業會計準則與會計師查核簽證準則之規定，由  貴公司委託本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務，俾能符合相關法令規定與提升整體會計帳務品質。具體服務事項如下：", items: [
    ServiceScopeItem(title: "營利事業所得稅查核簽證", content: "營利事業所得稅查核簽證主要係包括執行營利事業所得稅結算申報程序及依照「所得稅法」規定進行會計師查核簽證作業。", termStrings: ["平時會計帳務作業", "資金流程作業。", "成本表編製作業。"])
])
print(scope.render())


print("\n")
let assistance = BusinessClientAssistance(title: "貴公司之協助辦理事項", items: [
    ContentItem(title: "指派專責會計人員", content: "為期本專業服務能順利完成，爰建議  貴公司應指派熟悉公司會計作業流程之人員，以作為與本事務所溝通協調及對內對外之窗口。"),
    ContentItem(title: "網路銀行申請", content: "為方便本事務所執行出納事務，故請 貴公司配合申請網路銀行，以利運作順暢。(請提供編輯與審核帳號各一組)"),
    ContentItem(title: "配合及時提供相關資訊", content: "為順利達成上述服務，委任人應提供相關之會計資訊、文件及憑證等，供受任人審閱，並答覆有關問題之詢問。委任人會計人員應對財會委外工作儘量協助，此項協助包括憑證蒐集、對帳、提供有關文件資料、相關問題詢問等；至於其具體配合事項，將由受任人之服務人員於工作開始前，提供應備資料清單，商請委任人有關人員惠予配合。")
])
print(assistance.render())


print("\n")
let payment = Payment(title: "酬金", items: [
    .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"], price: "5,000", billingPeriod: .yearly),
    .init(names: ["會計帳務處理作業（113 年 5 月開始）"], price: "6,000", billingPeriod: .monthly13)
])

print(payment.render())


let html = HTML(
    .head(
        .title("hello")
    ),
    .body(
        .component(
            ComponentGroup{
                header
                Node.p().style("page-break-before: always;")
                List{
                    ListItem(purpose)
                    ListItem(scope)
                    ListItem(assistance)
                    ListItem(payment)
                }.environmentValue(.ordered, key: .listStyle)
        })
    )
)

print(html.render())

let generator = PDFGenerator(mainHtml: html)
let pdfData = generator.render()
//print(pdfData)

if #available(macOS 13.0, *) {
    try pdfData?.write(to: URL.init(filePath: "/Users/gradyzhuo/zz.pdf"))
} else {
    // Fallback on earlier versions
}
