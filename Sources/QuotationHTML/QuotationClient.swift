//
//  QuotationClient.swift
//  PDFGenerator
//
//  報價單的客戶方（受文者 / 立約人）—— 單一公司或集團多家。
//

/// 報價單的客戶方。
///
/// **刻意傳結構、不傳預先組好的字串**：同一個客戶方在不同 section 的呈現不同 ——
/// 受文者用頓號串接並附「共N家」，同意函簽名區則逐家換行。單一字串無法同時服務兩者，
/// 這也是 `AuditQuotation` 原本 `receiver: String` 被兩個 component 共用時撞到的限制。
///
/// **呈現規則歸 component**：頓號 / 換行 / 「共N家」屬版面設計，會隨版面調整而變，
/// 故由各 component 自行決定；呼叫端只負責提供「有哪幾家、順序、有沒有自訂集團名」這些資料。
/// 這與 `Purpose.Model` / `ServiceScope.Model` 等其他 section 的既有做法一致。
///
/// **`mergedDisplayName` 放在 `.group` 內而非與 party 平行**：它只對集團有意義。放頂層會讓
/// 「單一公司卻帶集團名」這種矛盾狀態可被表達（且舊版實作會真的印出集團名）。
///
/// ⚠️ **`.group` 的 `names` 必須至少一個**。型別無法強制（enum case 無法帶 invariant），
/// 空陣列會讓受文者印出「共0家」、簽名區留白。呼叫端有責任先擋掉
/// （OC 的 `resolveClientParty` 以 `guard !caseIds.isEmpty` 把關）。
public enum QuotationClient: Equatable, Sendable {
    /// 單一公司。
    case single(name: String)
    /// 集團多家。
    /// - Parameters:
    ///   - names: **順序即呈現順序**，由呼叫端決定（通常照 grouping 的 case 顯示順序）。至少一個。
    ///   - mergedDisplayName: 集團合併顯示名稱（選填）。有值時**所有 section 一律以它取代羅列** ——
    ///     使用者明確指定了集團要怎麼稱呼，就不該再列出各家公司。
    case group(names: [String], mergedDisplayName: String?)
}

extension QuotationClient {

    /// 逐行呈現用的名稱列（同意函簽名區）。
    ///
    /// 有 `mergedDisplayName` → 單一行；否則單一公司一行、集團每家一行。
    var displayLines: [String] {
        switch self {
        case .single(let name):
            return [name]
        case .group(let names, let mergedDisplayName):
            if let mergedDisplayName {
                return [mergedDisplayName]
            }
            return names
        }
    }

    /// 頓號串接呈現用（受文者）。
    ///
    /// 集團在末尾附「共N家」以明示涵蓋家數；有 `mergedDisplayName` 時不附
    /// （使用者給的集團名本身就代表整體，再加家數是贅述）。
    ///
    /// **不含「（以下簡稱 貴公司）」**——那是 `ContractHeader` 的公文樣板，屬該 component 職責。
    ///
    /// ⚠️ 信件「致」欄與內文的集團呈現**不走這裡**——那兩處的文字在 OC 端就已由
    /// template variable 替換成成品字串（`QuotationPdfHelpers.applyingConglomerateCompanyNames`），
    /// PDFGenerator 只收到結果。**同樣的頓號 / 換行規則因此在 OC 端另有一份實作**，
    /// 改動分隔符或優先序時兩邊都要改。詳見 OC 的
    /// `.ai/decisions/2026-08-conglomerate-company-name-presentation.md`。
    var inlineJoinedText: String {
        switch self {
        case .single(let name):
            return name
        case .group(let names, let mergedDisplayName):
            if let mergedDisplayName {
                return mergedDisplayName
            }
            return "\(names.joined(separator: "、"))共\(names.count)家"
        }
    }
}
