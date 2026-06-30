//
//  DocumentHeader.swift
//  PDFGenerator
//
//  文件頂部 — 對應 Frontend print-page header.component 的基本識別資訊
//  （公司名稱、統編、負責人、成交日期）。日期格式由呼叫端決定（傳入字串）。
//

import Foundation
import Plot
import QRCodeGenerator

public struct DocumentHeader: Component {
    let model: Model

    public var body: any Component {
        Div {
            // 外網/內網連結（事務所 logo 改由每頁固定 running header 呈現，見 LogoHeader）
            Div {
                Div {
                    Div {
                        Span(html: Self.linkIconSVG).class("urlIcon")
                        Link("外網連結", url: model.externalURL ?? "#")
                    }.class("url")
                    Div {
                        Span(html: Self.linkIconSVG).class("urlIcon")
                        Link("內網連結", url: model.internalURL ?? "#")
                    }.class("url")
                }.class("shareUrlContainer")
            }.class("logo")

            Div {
                if let businessId = model.businessId {
                    Div(Paragraph(businessId)).class("label")
                }
                Div {
                    Paragraph(model.companyName).class("bold")
                    if let representative = model.representative {
                        Div(Paragraph("負責人 \(representative)")).class("padding4TopBottom")
                    }
                }.class("name")
                Div {
                    if let dealDate = model.dealDate {
                        Div {
                            Paragraph("成交日期").class("dealDateText")
                            Paragraph(dealDate)
                        }.class("dealDate")
                    }
                    if model.externalURL != nil || model.shareToken != nil {
                        Div {
                            // QR 由外網連結生成（純 Swift，Linux 相容），分享碼顯示於下方
                            if let externalURL = model.externalURL,
                               let qr = try? QRCode.encode(text: externalURL, ecl: .high) {
                                Span(html: qr.toSVGString(border: 1)).class("qrImage")
                            }
                            if let shareToken = model.shareToken {
                                Paragraph(shareToken).class("token")
                            }
                        }.class("qrcodeInfo")
                    }
                }.class("gap8")
            }.class("companyContainer")
        }.class("printHeader")
    }

    public init(model: Model) {
        self.model = model
    }
}

extension DocumentHeader {
    /// 連結圖示（鏈結 icon），對應 Frontend header urlIcon，著色配合按鈕白字 #F1F3F5。
    static let linkIconSVG = """
    <svg xmlns="http://www.w3.org/2000/svg" width="11" height="11" viewBox="0 0 12 12" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M6.38676 1.37339C6.95257 0.826911 7.71037 0.524528 8.49696 0.531363C9.28355 0.538199 10.036 0.853705 10.5922 1.40993C11.1484 1.96615 11.4639 2.71859 11.4708 3.50518C11.4776 4.29177 11.1752 5.04958 10.6288 5.61539L10.6227 5.62158L9.12273 7.12152C8.8186 7.42576 8.45259 7.66104 8.04954 7.81139C7.64648 7.96174 7.21581 8.02365 6.78672 7.99292C6.35764 7.96219 5.94018 7.83954 5.56266 7.63328C5.18515 7.42703 4.85641 7.142 4.59873 6.79752C4.43333 6.57639 4.4785 6.26305 4.69963 6.09765C4.92075 5.93224 5.2341 5.97742 5.3995 6.19854C5.57128 6.42819 5.79044 6.61821 6.04212 6.75572C6.2938 6.89322 6.5721 6.97499 6.85816 6.99547C7.14421 7.01596 7.43133 6.97469 7.70003 6.87445C7.96874 6.77422 8.21274 6.61737 8.4155 6.41454L9.91232 4.91772C10.2748 4.54083 10.4754 4.0369 10.4708 3.51387C10.4663 2.98948 10.2559 2.48785 9.8851 2.11704C9.51429 1.74622 9.01266 1.53588 8.48827 1.53133C7.96502 1.52678 7.46087 1.72748 7.08393 2.0903L6.22664 2.94261C6.03081 3.1373 5.71423 3.13638 5.51953 2.94055C5.32484 2.74472 5.32577 2.42814 5.5216 2.23345L6.38159 1.37845L6.38676 1.37339Z" fill="#F1F3F5"/><path fill-rule="evenodd" clip-rule="evenodd" d="M3.94869 4.18467C4.35175 4.03432 4.78242 3.97241 5.21151 4.00314C5.64059 4.03387 6.05805 4.15652 6.43557 4.36278C6.81308 4.56903 7.14183 4.85406 7.3995 5.19854C7.5649 5.41967 7.51973 5.73301 7.2986 5.89841C7.07748 6.06382 6.76414 6.01864 6.59873 5.79752C6.42695 5.56787 6.20779 5.37785 5.95611 5.24034C5.70444 5.10284 5.42613 5.02107 5.14007 5.00059C4.85402 4.9801 4.5669 5.02137 4.2982 5.12161C4.02949 5.22184 3.78549 5.37869 3.58274 5.58152L2.08592 7.07834C1.7234 7.45523 1.52287 7.95916 1.52742 8.48219C1.53197 9.00658 1.74231 9.50821 2.11313 9.87902C2.48394 10.2498 2.98557 10.4602 3.50996 10.4647C4.03298 10.4693 4.53692 10.2688 4.9138 9.90624L5.76556 9.05448C5.96082 8.85921 6.27741 8.85921 6.47267 9.05448C6.66793 9.24974 6.66793 9.56632 6.47267 9.76158L5.61767 10.6166L5.61147 10.6227C5.04567 11.1691 4.28786 11.4715 3.50127 11.4647C2.71468 11.4579 1.96225 11.1424 1.40602 10.5861C0.849799 10.0299 0.534292 9.27747 0.527457 8.49088C0.520622 7.70429 0.823005 6.94648 1.36948 6.38067L1.37557 6.37448L2.8755 4.87454C3.17962 4.57033 3.54567 4.33501 3.94869 4.18467Z" fill="#F1F3F5"/></svg>
    """

    public struct Model {
        let companyName: String
        let businessId: String?
        let representative: String?
        let dealDate: String?
        let shareToken: String?
        let externalURL: String?
        let internalURL: String?

        public init(companyName: String, businessId: String? = nil, representative: String? = nil, dealDate: String? = nil, shareToken: String? = nil, externalURL: String? = nil, internalURL: String? = nil) {
            self.companyName = companyName
            self.businessId = businessId
            self.representative = representative
            self.dealDate = dealDate
            self.shareToken = shareToken
            self.externalURL = externalURL
            self.internalURL = internalURL
        }
    }
}
