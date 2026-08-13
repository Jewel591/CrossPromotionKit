import Foundation

public enum CrossPromotionAudience: String, CaseIterable, Sendable {
    case consumer
    case developer
}

public struct CrossPromotionApp: Identifiable, Hashable, Sendable {
    public let bundleIdentifier: String
    public let appStoreID: String
    public let audience: CrossPromotionAudience
    public let name: String
    public let subtitle: String

    public var id: String { appStoreID }

    public var appStoreURL: URL? {
        URL(string: "https://apps.apple.com/app/id\(appStoreID)")
    }

    init(
        bundleIdentifier: String,
        appStoreID: String,
        audience: CrossPromotionAudience,
        name: String,
        subtitle: String
    ) {
        self.bundleIdentifier = bundleIdentifier
        self.appStoreID = appStoreID
        self.audience = audience
        self.name = name
        self.subtitle = subtitle
    }
}
