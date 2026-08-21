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

    private static var entries: [Entry] {
        [
            Entry(
                bundleIdentifier: "weisenjoytech.mono-finance",
                appStoreID: "6670716062",
                audience: .consumer,
                name: localized("MONO Expense Tracker"),
                subtitle: localized("Personal finance, beautifully simple")
            ),
            Entry(
                bundleIdentifier: "com.weisenjoytech.CodeCat",
                appStoreID: "6749771947",
                audience: .consumer,
                name: localized("Pickup Cat Pickup Codes"),
                subtitle: localized("AI package pickup code organizer")
            ),
            Entry(
                bundleIdentifier: "weisenjoytech.Filmo",
                appStoreID: "6741805793",
                audience: .consumer,
                name: localized("Filmo Media Library"),
                subtitle: localized("Books, films, and music collection")
            ),
            Entry(
                bundleIdentifier: "com.linliao.LastTime",
                appStoreID: "6762844702",
                audience: .consumer,
                name: localized("LastTime Days Since"),
                subtitle: localized("Track the last time with smart reminders")
            ),
            // HeyCoffee is paused and intentionally excluded from cross-promotion.
            Entry(
                bundleIdentifier: "com.linliao.SupaMate",
                appStoreID: "6791957298",
                audience: .developer,
                name: localized("Supamate for Supabase"),
                subtitle: localized("Native workspace for Supabase")
            ),
            // Apper is registered as a developer-tool host but intentionally remains unpublished.
            Entry(
                bundleIdentifier: "com.liaolin.apper",
                appStoreID: nil,
                audience: .developer,
                name: localized("Apper Ideas"),
                subtitle: localized("App Store update tracker")
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
        entries.first { $0.bundleIdentifier == bundleIdentifier }?.audience
    }

    public static func apps(
        forHostBundleIdentifier bundleIdentifier: String
    ) -> [CrossPromotionApp] {
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

    private static func localized(_ key: String.LocalizationValue) -> String {
        String(localized: key, bundle: .module)
    }
}
