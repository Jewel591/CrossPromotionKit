import Testing
import Foundation

@testable import CrossPromotionKit

@Suite("Cross-promotion catalog")
struct CrossPromotionCatalogTests {
    @Test("Consumer hosts see only published consumer apps and not themselves")
    func consumerAudienceAndHostExclusion() {
        let apps = CrossPromotionCatalog.apps(
            forHostBundleIdentifier: "weisenjoytech.mono-finance"
        )

        #expect(apps.map(\.appStoreID) == [
            "6749771947",
            "6741805793",
            "6762844702",
        ])
        #expect(apps.allSatisfy { $0.audience == .consumer })
        #expect(!apps.contains { $0.bundleIdentifier == "weisenjoytech.mono-finance" })
    }

    @Test("LastTime is a registered consumer host and excludes itself")
    func lastTimeRegistrationAndHostExclusion() {
        let apps = CrossPromotionCatalog.apps(
            forHostBundleIdentifier: "com.linliao.LastTime"
        )

        #expect(apps.map(\.appStoreID) == [
            "6670716062",
            "6749771947",
            "6741805793",
        ])
        #expect(apps.allSatisfy { $0.audience == .consumer })
        #expect(!apps.contains { $0.bundleIdentifier == "com.linliao.LastTime" })
    }

    @Test("Developer hosts never receive consumer apps")
    func developerAudienceIsolation() {
        let apps = CrossPromotionCatalog.apps(
            forHostBundleIdentifier: "com.liaolin.apper"
        )

        #expect(apps.map(\.appStoreID) == ["6791957298"])
        #expect(apps.allSatisfy { $0.audience == .developer })
    }

    @Test("Unpublished apps are not recommendations")
    func unpublishedEntriesAreHidden() {
        let apps = CrossPromotionCatalog.apps(
            forHostBundleIdentifier: "com.linliao.SupaMate"
        )

        #expect(apps.isEmpty)
    }

    @Test("Unknown hosts fail closed")
    func unknownHostFailsClosed() {
        #expect(
            CrossPromotionCatalog.apps(
                forHostBundleIdentifier: "com.example.unknown"
            ).isEmpty
        )
    }

    @Test("ScreenStudies is an unpublished consumer host")
    func screenStudiesRegistration() {
        let apps = CrossPromotionCatalog.apps(
            forHostBundleIdentifier: "com.linliao.ScreenStudies"
        )

        #expect(apps.map(\.appStoreID) == [
            "6670716062",
            "6749771947",
            "6741805793",
            "6762844702",
        ])
        #expect(apps.allSatisfy { $0.audience == .consumer })
        #expect(!apps.contains { $0.bundleIdentifier == "com.linliao.ScreenStudies" })
    }

    @Test("Published identifiers are complete and unique")
    func publishedIdentifiersAreValid() {
        let consumerApps = CrossPromotionCatalog.apps(
            forHostBundleIdentifier: "weisenjoytech.mono-finance"
        )
        let developerApps = CrossPromotionCatalog.apps(
            forHostBundleIdentifier: "com.liaolin.apper"
        )
        let apps = consumerApps + developerApps
        let ids = apps.map(\.appStoreID)

        #expect(ids.count == Set(ids).count)
        #expect(ids.allSatisfy { !$0.isEmpty && $0.allSatisfy(\.isNumber) })
        #expect(apps.allSatisfy { !$0.name.isEmpty && !$0.subtitle.isEmpty })
    }

    @Test("Published catalog names resolve through the package catalog")
    func publishedCatalogNamesUseLocalizedKeys() throws {
        let path = try #require(
            Bundle.module.path(forResource: "zh-Hans", ofType: "lproj")
        )
        let bundle = try #require(Bundle(path: path))
        let consumerApps = CrossPromotionCatalog.apps(
            forHostBundleIdentifier: "com.linliao.ScreenStudies",
            localizationBundle: bundle
        )
        let developerApps = CrossPromotionCatalog.apps(
            forHostBundleIdentifier: "com.liaolin.apper",
            localizationBundle: bundle
        )
        let names = Dictionary(
            uniqueKeysWithValues: (consumerApps + developerApps).map {
                ($0.appStoreID, $0.name)
            }
        )

        #expect(names["6670716062"] == "MONO 记账")
        #expect(names["6749771947"] == "取件喵")
        #expect(names["6741805793"] == "Filmo 书影音")
        #expect(names["6762844702"] == "LastTime 距今天数")
        #expect(names["6791957298"] == "Supamate · Supabase")
    }
}

@Suite("Package localization")
struct CrossPromotionLocalizationTests {
    @Test("Simplified Chinese resources render package copy")
    func simplifiedChineseResource() throws {
        let path = try #require(
            Bundle.module.path(forResource: "zh-Hans", ofType: "lproj")
        )
        let bundle = try #require(Bundle(path: path))

        #expect(
            bundle.localizedString(
                forKey: "Our Other Apps",
                value: nil,
                table: nil
            ) == "我们的其他作品"
        )
        #expect(
            bundle.localizedString(
                forKey: "MONO Expense Tracker",
                value: nil,
                table: nil
            ) == "MONO 记账"
        )
        #expect(
            bundle.localizedString(
                forKey: "Filmo Media Library",
                value: nil,
                table: nil
            ) == "Filmo 书影音"
        )
        #expect(
            bundle.localizedString(
                forKey: "LastTime Days Since",
                value: nil,
                table: nil
            ) == "LastTime 距今天数"
        )
        #expect(
            bundle.localizedString(
                forKey: "Pickup Cat Pickup Codes",
                value: nil,
                table: nil
            ) == "取件喵"
        )
    }

    @Test("Japanese resources render package copy")
    func japaneseResource() throws {
        let path = try #require(
            Bundle.module.path(forResource: "ja", ofType: "lproj")
        )
        let bundle = try #require(Bundle(path: path))

        #expect(
            bundle.localizedString(
                forKey: "Get",
                value: nil,
                table: nil
            ) == "入手"
        )
        #expect(
            bundle.localizedString(
                forKey: "MONO Expense Tracker",
                value: nil,
                table: nil
            ) == "MONO 家計簿"
        )
        #expect(
            bundle.localizedString(
                forKey: "Filmo Media Library",
                value: nil,
                table: nil
            ) == "Filmo 映画・本・音楽"
        )
        #expect(
            bundle.localizedString(
                forKey: "LastTime Days Since",
                value: nil,
                table: nil
            ) == "LastTime 経過日数"
        )
        #expect(
            bundle.localizedString(
                forKey: "Pickup Cat Pickup Codes",
                value: nil,
                table: nil
            ) == "Pickup Cat 受取コード"
        )
    }
}
