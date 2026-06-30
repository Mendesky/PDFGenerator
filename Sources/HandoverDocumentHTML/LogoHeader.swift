//
//  LogoHeader.swift
//  PDFGenerator
//
//  每頁固定置頂的事務所 logo running header，交給 PDFGenerator 的 headerHtml 參數。
//  做法對齊報價單 headerHTML：<header position:fixed>，WeasyPrint 量測其高度後自動
//  讓出對應上邊距，logo 因此出現在每一頁頂端（靠左上）。
//

import Foundation
import Plot

public struct LogoHeader: Component {
    /// logo 左側內縮，對齊內文側邊距（cm）。
    let sideMarginCM: Float

    public init(sideMarginCM: Float = 1.5) {
        self.sideMarginCM = sideMarginCM
    }

    public var body: any Component {
        ComponentGroup {
            Header {
                if let logoUrl = Bundle.module.url(forResource: "header_logo", withExtension: "png") {
                    Image(logoUrl).class("runningLogo")
                }
            }
            // header 高度需明確指定：python 端以此高度換算內文上邊距（header_height + extra_vertical_margin）。
            Node<String>.element(named: "style", text: """
            header {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 52px;
                box-sizing: border-box;
                padding-left: \(sideMarginCSS)cm;
                display: flex;
                align-items: center;
            }
            header .runningLogo { height: 40px; width: auto; }
            """)
        }
    }

    private var sideMarginCSS: String {
        sideMarginCM.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sideMarginCM)) : String(sideMarginCM)
    }
}
