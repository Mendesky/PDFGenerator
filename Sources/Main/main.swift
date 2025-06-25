//
//  main.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Foundation
import QuotationHTML
import Plot
import PDFGenerator

let lettetHeader = LetterHeader(to: "全家人健康事業股份有限公司", from: "嘉威聯合會計師事務所", content: "茲將附上全家人健康事業股份有限公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證暨財會委外處理作業之專業服務公費報價單。 我們希望以最專業多元的服務與 貴公司長久配合，公費內容若經確認，煩請將最後一頁同意函簽章並回傳至敝事務所（FAX：2299-9901），謝謝您的合作。", date: Date(), blessings: "順頌 商祺")

//print(lettetHeader.render())


let purpose = ContentItem(title: "目的", content: "貴公司委託本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務，以協助　貴公司提升整體會計帳務品質，並符合相關稅務法令和企業會計準則等之規定。")
//print(purpose.render())
//
//print("\n")
let scope = ServiceScope(title: "服務範圍及內容", heading: "本項專案作業之服務範圍將根據相關稅務法令、企業會計準則與會計師查核簽證準則之規定，由  貴公司委託本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務，俾能符合相關法令規定與提升整體會計帳務品質。具體服務事項如下：", items: [
    QuotingServiceTerm(title: "營利事業所得稅查核簽證", term: "營利事業所得稅查核簽證主要係包括執行營利事業所得稅結算申報程序及依照「所得稅法」規定進行會計師查核簽證作業。", termStrings: ["平時稅務會計帳務作業，包括:憑證整理、\n傳票登打、\n相關帳簿與財務報表之編製。", "資金流程作業。", "成本表編製作業。"])
])
//print(scope.render())


//print("\n")
let assistance = BusinessClientAssistance(title: "貴公司之協助辦理事項", items: [
    ContentItem(title: "指派專責會計人員", content: "為期本專業服務能順利完成，爰建議  貴公司應指派熟悉公司會計作業流程之人員，以作為與本事務所溝通協調及對內對外之窗口。"),
    ContentItem(title: "網路銀行申請", content: "為方便本事務所執行出納事務，故請 貴公司配合申請網路銀行，以利運作順暢。(請提供編輯與審核帳號各一組)"),
    ContentItem(title: "配合及時提供相關資訊", content: "為順利達成上述服務，委任人應提供相關之會計資訊、文件及憑證等，供受任人審閱，並答覆有關問題之詢問。委任人會計人員應對財會委外工作儘量協助，此項協助包括憑證蒐集、對帳、提供有關文件資料、相關問題詢問等；至於其具體配合事項，將由受任人之服務人員於工作開始前，提供應備資料清單，商請委任人有關人員惠予配合。")
])
//print(assistance.render())


//print("\n")
let paymentItems: [PaymentItem] = [
    .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證", "民國 115 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"], fee: "1,4000 元/年"),
    .init(names: ["會計帳務處理作業（113 年 5 月開始）"], fee: "優惠免收")
]
let paymentItems2: [PaymentItem] = [
    .init(names: ["會計帳務處理作業（113 年 5 月開始）"], fee: "5000 元/月"),
]
let payment = PaymentBlock(title: "酬金", payments: [
    Payment(name: "財務會計委外作業(112 年度)", items: paymentItems),
    Payment(name: "財務會計委外作業(113 年起)", items: paymentItems2)
])

let contents: [String] = [
    "報價依照年度營收狀況及資產總額狀況評估，若有巨額變動時，將另與 貴公司民國112年以後依照附表一、專屬全家人健康事業(股) 會計帳務及稅務申報處理作業級距表討論報價金額。簽證公費請於當年底時支付半數，另外半數請於交付報告時支付；財會委外會計帳務暨稅務處申報理作業費用一年以十四個月計算，並請於次月底前支付前一個月之公費。合約執行期間不得低於二年，解除合約須提前三個月告知。",
    """
    出納事務處理作業內容包含：
    A.國內轉帳30 筆；每加一筆多50 元。
    B.國外轉帳10 筆；每加一筆多100 元。
    C.一次薪資轉帳。
    """,
    "薪資人力支援處理作業500元/人/月；基本收費3,000/月。"
]
let notes = Note(contents: contents)


let receiver = "全家人健康事業股份有限公司"
let sender = "88183980"
let subject = "本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。"
let additionalServices: [AdditionalService] = [
    AdditionalService(name: "代辦年度CTP申報(每年3月；加收2,000元/家)", isSelected: false),
    AdditionalService(name: "二代健保申報作業", isSelected: true) 
]
let quotationNo = "111112101"

let replyForm = ReplyForm(receiver: receiver, sender: sender, subject: subject, payments: payment.payments, additionalServices: additionalServices, quotationNo: quotationNo, showCompanyStamp: false)


let contractSubject = "承 貴公司委任本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證暨財會委外處理作業之專業服務，至深感荷。謹將服務內容及酬金等分別說明如後，敬請卓察賜覆為禱。"
let content = "感謝 貴公司對本事務所的支持與愛護，本事務所本著積極服務顧客的熱忱，以及專業智慧的多元服務，特將本事務所受託辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務內容概述如後，期盼此項合作能協助 貴公司提升會計帳務品質，俾能符合相關稅務法令和企業會計準則之規定。茲將委任之目的、服務範圍、 貴公司協助事項、酬金、權利義務事項及同意函列示如下："
let contractHeader = ContractHeader(receiver: receiver, sender: sender, subject: contractSubject, content: content)

let quotation = AuditQuotation(no: quotationNo, purpose: purpose, paymentBlock: payment, serviceScope: scope, letterHeader: lettetHeader, assistance: assistance, notes: notes, replyForm: replyForm, contractHeader: contractHeader)
let html = quotation.render()
let htmlUrl = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test.html")
try html.write(to: htmlUrl, atomically: true, encoding: .utf8)

let generator = PDFGenerator(mainHtml: quotation, headerHtml: quotation.headerHTML, footerHtml: quotation.footerHTML)
let pdfData = try generator.generate()
//print(pdfData)




let pdfUrl = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test.pdf")
try pdfData?.write(to: pdfUrl)

//import PDFToImage
//
//let converter = PDFImageConverter()
//let imageDatas = try converter.convert(data: pdfData!)
////let imageData = try converter.convertToData(url: URL(string: "file:///Users/gradyzhuo/test.pdf")!)
//
//let folderURL = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test", directoryHint: .isDirectory)
//for (index,imgData) in imageDatas.enumerated(){
//    let url = folderURL.appending(path: "\(index).jpg")
//    try imgData.write(to: url)
//}
