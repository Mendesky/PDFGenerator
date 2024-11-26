import Foundation


public enum Organization: String, Codable, Sendable {
    public static var `default`: Organization  { return .jw }
    case jw = "01020314" // 嘉威
    case jwTaipei = "88183980" // 嘉威-台北所
    case jwTaoyuan = "41171816" // 嘉威-桃園所
    case jwTaichung = "47575385" // 嘉威-台中所
    case jwChanghua = "82576039" // 嘉威-彰化所
    case jwChiayi = "47779732" // 嘉威-嘉義所
    case kd = "34873876" // 康達
    case jwipo = "54842985" // 捷達優
}