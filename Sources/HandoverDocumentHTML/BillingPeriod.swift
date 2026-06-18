//
//  BillingPeriod.swift
//  PDFGenerator
//
//  計費週期 — 對應報價來源的 pricing period
//  (oneTime | monthly11 | monthly12 | monthly13 | monthly14 | yearly)，
//  顯示文字對齊 Frontend 的 asPeriodText(longText) pipe。
//

public enum BillingPeriod: String, Sendable {
    case oneTime
    case monthly11
    case monthly12
    case monthly13
    case monthly14
    case yearly

    /// 對應 Frontend `asPeriodText` 的 longText 樣式（不含金額單位）。
    public var text: String {
        switch self {
        case .oneTime: return "次"
        case .yearly: return "年"
        case .monthly11: return "月 ( 11 個月 )"
        case .monthly12: return "月 ( 12 個月 )"
        case .monthly13: return "月 ( 13 個月 )"
        case .monthly14: return "月 ( 14 個月 )"
        }
    }
}
