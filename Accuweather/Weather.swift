

import Foundation
struct Weather: Codable {
    let version: Int
    let key, type, localizedName, englishName: String
    let country: Country

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case type = "Type"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case country = "Country"
    }
    
    struct Country: Codable {
        let id, localizedName, englishName: String

        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case localizedName = "LocalizedName"
            case englishName = "EnglishName"
        }
    }
}
