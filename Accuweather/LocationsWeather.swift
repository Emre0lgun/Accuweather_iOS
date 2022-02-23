
import Foundation

struct LocationsWeather: Codable {
    let version: Int
    let key, type: String
    let rank: Int
    let localizedName, englishName : String
    let country: Country

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case type = "Type"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case country = "Country"
    }
}

struct Country: Codable {
    let id, localizedName, englishName: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}
