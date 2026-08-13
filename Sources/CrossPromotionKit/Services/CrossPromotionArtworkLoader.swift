import Foundation

actor CrossPromotionArtworkLoader {
    static let shared = CrossPromotionArtworkLoader()

    private struct LookupResponse: Decodable {
        let results: [LookupApp]
    }

    private struct LookupApp: Decodable {
        let artworkUrl512: URL?
        let artworkUrl100: URL?
        let artworkUrl60: URL?

        var artworkURL: URL? {
            artworkUrl512 ?? artworkUrl100 ?? artworkUrl60
        }
    }

    private let session: URLSession

    private init() {
        let cache = URLCache(
            memoryCapacity: 8 * 1_024 * 1_024,
            diskCapacity: 64 * 1_024 * 1_024,
            diskPath: "CrossPromotionKit"
        )
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: configuration)
    }

    func artworkData(for appStoreID: String, regionCode: String?) async -> Data? {
        do {
            guard let artworkURL = try await artworkURL(
                for: appStoreID,
                preferredRegionCode: regionCode
            ) else {
                return nil
            }
            let (artworkData, artworkResponse) = try await session.data(from: artworkURL)
            guard (artworkResponse as? HTTPURLResponse)?.statusCode == 200 else {
                return nil
            }
            return artworkData
        } catch {
            return nil
        }
    }

    private func artworkURL(
        for appStoreID: String,
        preferredRegionCode: String?
    ) async throws -> URL? {
        var regionCodes: [String?] = []
        if let preferredRegionCode {
            regionCodes.append(preferredRegionCode)
        }
        if preferredRegionCode?.caseInsensitiveCompare("cn") != .orderedSame {
            regionCodes.append("cn")
        }
        regionCodes.append(nil)

        for regionCode in regionCodes {
            guard let lookupURL = lookupURL(
                appStoreID: appStoreID,
                regionCode: regionCode
            ) else {
                continue
            }
            let (lookupData, lookupResponse) = try await session.data(from: lookupURL)
            guard (lookupResponse as? HTTPURLResponse)?.statusCode == 200 else {
                continue
            }
            if let artworkURL = try JSONDecoder()
                .decode(LookupResponse.self, from: lookupData)
                .results.first?.artworkURL {
                return artworkURL
            }
        }
        return nil
    }

    private func lookupURL(
        appStoreID: String,
        regionCode: String?
    ) -> URL? {
        var components = URLComponents(string: "https://itunes.apple.com/lookup")
        var queryItems = [URLQueryItem(name: "id", value: appStoreID)]
        if let regionCode, regionCode.count == 2 {
            queryItems.append(
                URLQueryItem(name: "country", value: regionCode.lowercased())
            )
        }
        components?.queryItems = queryItems
        return components?.url
    }
}
