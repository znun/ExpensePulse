enum CurrencyUnit: String {
    case dollar = "$"
    //case dong = "₫"
    case taka = "৳"
    case rupee = "₹"
    case euro = "€"
    case yen = "¥"
    case pound = "£"
    case cent = "¢"
    case kip = "₭"

    static let all: [CurrencyUnit] = [.dollar, .taka, .rupee, .euro, .yen, .pound, .cent, .kip]
}
