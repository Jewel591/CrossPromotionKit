import Foundation

/// A published studio app that a host may recommend. Each host app chooses which
/// products to show and in what order; the package owns their metadata.
public enum CrossPromotionProduct: String, CaseIterable, Hashable, Sendable {
    case mono
    case pickupCat
    case filmo
    case lastTime
    case supamate
}

public struct CrossPromotionApp: Identifiable, Hashable, Sendable {
    public let product: CrossPromotionProduct
    public let bundleIdentifier: String
    public let appStoreID: String
    public let name: String
    public let subtitle: String

    public var id: String { appStoreID }

    public var appStoreURL: URL? {
        URL(string: "https://apps.apple.com/app/id\(appStoreID)")
    }

    init(
        product: CrossPromotionProduct,
        bundleIdentifier: String,
        appStoreID: String,
        name: String,
        subtitle: String
    ) {
        self.product = product
        self.bundleIdentifier = bundleIdentifier
        self.appStoreID = appStoreID
        self.name = name
        self.subtitle = subtitle
    }
}
