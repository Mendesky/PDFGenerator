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
        return switch self {
            case .jw:
                "jw-quotation-header"
            case .jwTaipei:
                "jwTaipei-quotation-header"
            case .jwTaoyuan:
                "jwTaoyuan-quotation-header"
            case .jwTaichung:
                "jwTaichung-quotation-header"
            case .jwChanghua:
                "jwChanghua-quotation-header"
            case .jwChiayi:
                "jwChiayi-quotation-header"
            case .kd:
                "kd-quotation-header"
            case .jwipo:
                "jwipo-quotation-header"
        }
    }

    public var footerResource: String {
        return switch self {
            case .jw:
                "jw-quotation-footer"
            case .jwTaipei:
                "jwTaipei-quotation-footer"
            case .jwTaoyuan:
                "jwTaoyuan-quotation-footer"
            case .jwTaichung:
                "jwTaichung-quotation-footer"
            case .jwChanghua:
                "jwChanghua-quotation-footer"
            case .jwChiayi:
                "jwChiayi-quotation-footer"
            case .kd:
                "kd-quotation-footer"
            case .jwipo:
                "jwipo-quotation-footer"
        }
    }

    public var displayName: String {
        return switch self {
        case .jw:
            "嘉威聯合會計師事務所"
        case .jwTaipei:
            "嘉威聯合會計師事務所-台北所"
        case .jwTaoyuan:
            "嘉威聯合會計師事務所-桃園所"
        case .jwTaichung:
            "嘉威聯合會計師事務所-台中所"
        case .jwChanghua:
            "嘉威聯合會計師事務所-彰化所"
        case .jwChiayi:
            "嘉威聯合會計師事務所-嘉義所"
        case .kd:
            "康達會計師事務所"
        case .jwipo:
            "捷達優企管顧問股份有限公司"
        }
    }
}