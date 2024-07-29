import Foundation

extension Bundle {
    
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let name:String = dictionary["CFBundleName"] as? String {
            return name
        } else {
            return ""
        }
    }
    
}
