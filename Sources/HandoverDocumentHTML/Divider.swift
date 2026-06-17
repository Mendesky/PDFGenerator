//
//  Divider.swift
//  PDFGenerator
//
//  區塊分隔線 — 對應 Frontend print-page 的水平 divider（#D3D3D3）。
//

import Plot

public struct Divider: Component {
    public var body: any Component {
        Div().class("divider").style("border-top: 1px solid #D3D3D3; width: 100%; margin: 4px 0;")
    }

    public init() {}
}
