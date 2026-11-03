//
//  ShrinkableText.swift
//  PDFGenerator
//
//  「這一塊要擠在一頁內」的排版約定：HTML 標出哪個元素要整個落在第 1 頁、哪段文字可以縮短，
//  由 PDFGenerator 的 pdf_generator.py（`_fit_single_page`）依實際排版結果決定縮到幾個字。
//
//  - 容器：帶 `data-fit-single-page` 的元素，內容要全部落在第 1 頁。
//  - 可縮短的文字：帶 `data-fit-text`（原文）、`data-fit-suffix`（截斷後接的字）、
//    `data-fit-fallback`（一個字都放不下時改印的字）的元素。一份文件只認第一個。
//    三個值都以 base64（UTF-8）放：Plot 不跳脫屬性值，原文裡的引號會弄壞 HTML。
//
//  第 1 頁放得下就不動；放不下就找「原文前 n 字＋suffix」放得下的最大 n，一個字都放不下印 fallback；
//  fallback 也放不下就維持原內容（接受超過一頁），python 端記一筆 log。
//

import Foundation
import Plot

public struct ShrinkableText: Sendable, Equatable {
    /// 原文（已是呼叫端願意印的最長版本；含 \n 時逐行斷行）
    public let text: String
    /// 截斷後接在後面的字，例：「…(詳見補充頁)」
    public let suffix: String
    /// 一個字都放不下時改印的字，例：「詳補充頁」
    public let fallback: String

    public init(text: String, suffix: String, fallback: String) {
        self.text = text
        self.suffix = suffix
        self.fallback = fallback
    }
}

enum FitSinglePage {
    static let containerAttribute = "data-fit-single-page"
    static let textAttribute = "data-fit-text"
    static let suffixAttribute = "data-fit-suffix"
    static let fallbackAttribute = "data-fit-fallback"

    static func encoded(_ value: String) -> String {
        Data(value.utf8).base64EncodedString()
    }
}

extension Component {
    /// 標成「整個要落在第 1 頁」的容器（見 `ShrinkableText`）。
    func fitSinglePageContainer() -> Component {
        attribute(named: FitSinglePage.containerAttribute, value: "true")
    }

    /// 標成第 1 頁放不下時可以縮短的文字；nil 不加任何標記。
    func shrinkable(_ shrinkable: ShrinkableText?) -> Component {
        guard let shrinkable else { return self }
        return attribute(named: FitSinglePage.textAttribute, value: FitSinglePage.encoded(shrinkable.text))
            .attribute(named: FitSinglePage.suffixAttribute, value: FitSinglePage.encoded(shrinkable.suffix))
            .attribute(named: FitSinglePage.fallbackAttribute, value: FitSinglePage.encoded(shrinkable.fallback))
    }
}
