import Foundation

/// Metadata for every published studio app. Which products a host shows is the
/// host's decision; this type only resolves the chosen products to catalog entries.
public enum CrossPromotionCatalog {
    /// Resolves the host's selection in the given order. A product listed twice is shown once.
    public static func apps(for products: [CrossPromotionProduct]) -> [CrossPromotionApp] {
        apps(for: products, localizationBundle: .module)
    }

    /// Test seam: resolve catalog copy from a specific `.lproj` table instead of the process locale.
    static func apps(
        for products: [CrossPromotionProduct],
        localizationBundle bundle: Bundle
    ) -> [CrossPromotionApp] {
        var seen = Set<CrossPromotionProduct>()
        return products
            .filter { seen.insert($0).inserted }
            .map { app(for: $0, localizedBy: bundle) }
    }

    // HeyCoffee is paused and Apper is unpublished; a product joins the catalog
    // only after its App Store ID is live.
    private static func app(
        for product: CrossPromotionProduct,
        localizedBy bundle: Bundle
    ) -> CrossPromotionApp {
        switch product {
        case .mono:
            CrossPromotionApp(
                product: product,
                bundleIdentifier: "weisenjoytech.mono-finance",
                appStoreID: "6670716062",
                name: String(localized: "MONO Expense Tracker", bundle: bundle),
                subtitle: String(localized: "Personal finance, beautifully simple", bundle: bundle)
            )
        case .pickupCat:
            CrossPromotionApp(
                product: product,
                bundleIdentifier: "com.weisenjoytech.CodeCat",
                appStoreID: "6749771947",
                name: String(localized: "Pickup Cat Pickup Codes", bundle: bundle),
                subtitle: String(localized: "AI package pickup code organizer", bundle: bundle)
            )
        case .filmo:
            CrossPromotionApp(
                product: product,
                bundleIdentifier: "weisenjoytech.Filmo",
                appStoreID: "6741805793",
                name: String(localized: "Filmo Media Library", bundle: bundle),
                subtitle: String(localized: "Books, films, and music collection", bundle: bundle)
            )
        case .lastTime:
            CrossPromotionApp(
                product: product,
                bundleIdentifier: "com.linliao.LastTime",
                appStoreID: "6762844702",
                name: String(localized: "LastTime Days Since", bundle: bundle),
                subtitle: String(localized: "Track the last time with smart reminders", bundle: bundle)
            )
        case .supamate:
            CrossPromotionApp(
                product: product,
                bundleIdentifier: "com.linliao.SupaMate",
                appStoreID: "6791957298",
                name: String(localized: "Supamate for Supabase", bundle: bundle),
                subtitle: String(localized: "Native workspace for Supabase", bundle: bundle)
            )
        }
    }
}
