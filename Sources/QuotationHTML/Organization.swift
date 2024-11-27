import Foundation


public enum Organization: String, Codable, Sendable {
    public static var `default`: Organization  { return .jw }
    case jw = "嘉威聯合會計師事務所"
    case jwTaipei = "嘉威聯合會計師事務所-台北所"
    case jwTaoyuan = "嘉威聯合會計師事務所-桃園所"
    case jwTaichung = "嘉威聯合會計師事務所-台中所"
    case jwChanghua = "嘉威聯合會計師事務所-彰化所"
    case jwChiayi = "嘉威聯合會計師事務所-嘉義所"
    case kd = "康達會計師事務所"
    case jwipo = "捷達優企管顧問股份有限公司"

    public init(rawValue: String) {
        switch rawValue {
        case "嘉威聯合會計師事務所":
            self = .jw
        case "嘉威聯合會計師事務所-台北所":
            self = .jwTaichung
        case "嘉威聯合會計師事務所-桃園所":
            self = .jwTaoyuan
        case "嘉威聯合會計師事務所-台中所":
            self = .jwTaichung
        case "嘉威聯合會計師事務所-彰化所":
            self = .jwChanghua
        case "嘉威聯合會計師事務所-嘉義所":
            self = .jwChiayi
        case "康達會計師事務所":
            self = .kd
        case "捷達優企管顧問股份有限公司":
            self = .jwipo
        default:
            self = .jw
        }
    }

    public var resource: String {
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
}