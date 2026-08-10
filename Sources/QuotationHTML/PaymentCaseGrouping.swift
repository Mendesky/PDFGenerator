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

    /// 「單 bundle 不顯示 bundle 名」規則 per-case 套用：每個 case **總共**只有 1 個 bundle 時
    /// 隱藏其 bundle 名（該 case 的 case 標題已足夠識別；單一 case 亦同——單 bundle 隱藏、多 bundle 照顯示）。
    /// 用「per-caseName 總數」而非連續 run 數，避免同 case bundle 在輸入中非連續時被誤判為各自單 bundle。
    static func hidingSingleBundleNames(_ payments: [Payment]) -> [Payment] {
        let bundleCountByCase = Dictionary(grouping: payments, by: \.caseName).mapValues(\.count)
        return payments.map { payment in
            (bundleCountByCase[payment.caseName] ?? 0) == 1 ? payment.hideName() : payment
        }
    }
}
