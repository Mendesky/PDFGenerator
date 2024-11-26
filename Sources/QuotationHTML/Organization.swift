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
}