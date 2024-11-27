import Foundation


public enum Organization: String, Codable, Sendable {
    case jw = "01020314" // 嘉威
    case jwTaipei = "88183980" // 嘉威-台北所
    case jwTaoyuan = "41171816" // 嘉威-桃園所
    case jwTaichung = "47575385" // 嘉威-台中所
    case jwChanghua = "82576039" // 嘉威-彰化所
    case jwChiayi = "47779732" // 嘉威-嘉義所
    case kd = "34873876" // 康達
    case jwipo = "54842985" // 捷達優

    public init(rawValue: String) {
        switch rawValue {
        case "01020314":
            self = .jw
        case "88183980":
            self = .jwTaipei
        case "41171816":
            self = .jwTaoyuan
        case "47575385":
            self = .jwTaichung
        case "82576039":
            self = .jwChanghua
        case "47779732":
            self = .jwChiayi
        case "34873876":
            self = .kd
        case "54842985":
            self = .jwipo
        default:
            self = .jw
        }
    }

    public var headerResource: String {
        return "jw-quotation-header-\(rawValue)"
    }

    public var footerResource: String {
        return "jw-quotation-footer-\(rawValue)"
    }

    public var displayName: String {
        return switch self {
        case .jw, .jwTaipei, .jwTaoyuan, .jwTaichung, .jwChanghua, .jwChiayi:
            "嘉威聯合會計師事務所"
        case .kd:
            "康達會計師事務所"
        case .jwipo:
            "捷達優企管顧問股份有限公司"
        }
    }
}