import Foundation
import OSLog

public enum CrossPromotionCatalog {
    private struct Entry: Sendable {
        let bundleIdentifier: String
        let appStoreID: String?
        let audience: CrossPromotionAudience
        let name: String
        let subtitle: String
    }

    private static let logger = Logger(
        subsystem: "com.weisenjoy.CrossPromotionKit",
        category: "Catalog"
    )

    private static func entries(localizedBy bundle: Bundle) -> [Entry] {
        [
            Entry(
                bundleIdentifier: "weisenjoytech.mono-finance",
                appStoreID: "6670716062",
                audience: .consumer,
                name: localized("MONO Expense Tracker", from: bundle),
                subtitle: localized("Personal finance, beautifully simple", from: bundle)
            ),
            Entry(
                bundleIdentifier: "com.weisenjoytech.CodeCat",
                appStoreID: "6749771947",
                audience: .consumer,
                name: localized("Pickup Cat Pickup Codes", from: bundle),
                subtitle: localized("AI package pickup code organizer", from: bundle)
            ),
            Entry(
                bundleIdentifier: "weisenjoytech.Filmo",
                appStoreID: "6741805793",
                audience: .consumer,
                name: localized("Filmo Media Library", from: bundle),
                subtitle: localized("Books, films, and music collection", from: bundle)
            ),
            Entry(
                bundleIdentifier: "com.linliao.LastTime",
                appStoreID: "6762844702",
                audience: .consumer,
                name: localized("LastTime Days Since", from: bundle),
                subtitle: localized("Track the last time with smart reminders", from: bundle)
            ),
            // HeyCoffee is paused and intentionally excluded from cross-promotion.
            Entry(
                bundleIdentifier: "com.linliao.SupaMate",
                appStoreID: "6791957298",
                audience: .developer,
                name: localized("Supamate for Supabase", from: bundle),
                subtitle: localized("Native workspace for Supabase", from: bundle)
            ),
            // Apper is registered as a developer-tool host but intentionally remains unpublished.
            Entry(
                bundleIdentifier: "com.liaolin.apper",
                appStoreID: nil,
                audience: .developer,
                name: localized("Apper Ideas", from: bundle),
                subtitle: localized("App Store update tracker", from: bundle)
            ),
            // ScreenStudies is a consumer-audience host so the study app can
            // load the studio catalog; it stays unpublished and is never recommended.
            Entry(
                bundleIdentifier: "com.linliao.ScreenStudies",
                appStoreID: nil,
                audience: .consumer,
                name: "ScreenStudies",
                subtitle: "UI study reference"
            ),
        ]
    }

    public static func audience(
        forHostBundleIdentifier bundleIdentifier: String
    ) -> CrossPromotionAudience? {
        entries(localizedBy: .module)
            .first { $0.bundleIdentifier == bundleIdentifier }?
            .audience
    }

    public static func apps(
        forHostBundleIdentifier bundleIdentifier: String
    ) -> [CrossPromotionApp] {
        apps(forHostBundleIdentifier: bundleIdentifier, localizationBundle: .module)
    }

    /// Test seam: resolve catalog copy from a specific `.lproj` table instead of the process locale.
    static func apps(
        forHostBundleIdentifier bundleIdentifier: String,
        localizationBundle: Bundle
    ) -> [CrossPromotionApp] {
        let entries = entries(localizedBy: localizationBundle)
        guard let host = entries.first(where: {
            $0.bundleIdentifier == bundleIdentifier
        }) else {
            logger.error("Unknown host bundle identifier: \(bundleIdentifier, privacy: .public)")
            return []
        }

        return entries.compactMap { entry in
            guard entry.audience == host.audience,
                  entry.bundleIdentifier != host.bundleIdentifier,
                  let appStoreID = entry.appStoreID else {
                return nil
            }
            return CrossPromotionApp(
                bundleIdentifier: entry.bundleIdentifier,
                appStoreID: appStoreID,
                audience: entry.audience,
                name: entry.name,
                subtitle: entry.subtitle
            )
        }
    }

    public static var appsForCurrentHost: [CrossPromotionApp] {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            logger.error("Host bundle identifier is unavailable")
            return []
        }
        return apps(forHostBundleIdentifier: bundleIdentifier)
    }

    private static func localized(
        _ key: String,
        from bundle: Bundle
    ) -> String {
        bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
