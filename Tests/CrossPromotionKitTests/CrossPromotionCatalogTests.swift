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
        ])
        #expect(apps.allSatisfy { $0.audience == .consumer })
        #expect(!apps.contains { $0.bundleIdentifier == "weisenjoytech.mono-finance" })
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
    }
}
