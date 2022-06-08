import Foundation

struct LocWeather: Codable {
    let version: Int
    let key, type: String
    let rank: Int
    let localizedName, englishName : String
    let country: getCountry

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

struct getCountry: Codable {
    let id, localizedName, englishName: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}
