//
//  PaymentCaseGrouping.swift
//  PDFGenerator
//
//  酬金 payments 依 `caseName` 分組的 presentation 規則，供 `PaymentBlock` /
//  `ReplyFormPaymentBlock` 共用。caller（OC）只忠實提供每個 bundle 的 `caseName`；
//  「是否顯示 case 標題」是版面判斷，集中在此。
//

enum PaymentCaseGrouping {
    /// 依 `caseName` 把連續同 case 的 payments 收成一段（OC 以 case→bundle 順序送入，故連續分組即可）。
    /// 回傳順序與輸入一致。
    static func runs(_ payments: [Payment]) -> [(caseName: String?, payments: [Payment])] {
        var result: [(caseName: String?, payments: [Payment])] = []
        for payment in payments {
            if let lastIndex = result.indices.last, result[lastIndex].caseName == payment.caseName {
                result[lastIndex].payments.append(payment)
            } else {
                result.append((caseName: payment.caseName, payments: [payment]))
            }
        }
        return result
    }

    /// ≥2 個不同 case 分段時才顯示 case 名稱標題；單一 case（含 `caseName` 全 nil）不顯示，
    /// 沿用各 block 既有的單/多 bundle 行為。
    static func showsCaseNames(_ payments: [Payment]) -> Bool {
        runs(payments).count > 1
    }
}
