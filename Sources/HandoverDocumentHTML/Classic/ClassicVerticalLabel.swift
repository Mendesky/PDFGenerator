//
//  ClassicVerticalLabel.swift
//  PDFGenerator
//
//  區塊直書標籤：每個字各自一行堆疊（普通排版），不用 writing-mode 旋轉。
//  WeasyPrint 對 writing-mode + nowrap 支援不穩，列高不足時末字會換到被裁切的第二直行（漏字）；
//  改用逐字斷行，格子高度自然撐開、保證不裁字。
//

import Plot

struct ClassicVerticalLabel: Component {
    let text: String

    var body: any Component {
        Div {
            for ch in text {
                Div(String(ch)).class("vlabelChar")
            }
        }.class("vlabel")
    }
}
