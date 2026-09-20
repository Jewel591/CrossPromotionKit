import Testing
import Foundation

@testable import CrossPromotionKit

@Suite("Cross-promotion catalog")
struct CrossPromotionCatalogTests {
    @Test("The host's selection resolves in the order given")
    func hostSelectionKeepsOrder() {
        let apps = CrossPromotionCatalog.apps(for: [.filmo, .pickupCat])

        #expect(apps.map(\.product) == [.filmo, .pickupCat])
        #expect(apps.map(\.appStoreID) == ["6741805793", "6749771947"])
    }

    @Test("A product listed twice is shown once")
    func duplicateSelectionIsShownOnce() {
        let apps = CrossPromotionCatalog.apps(for: [.mono, .filmo, .mono])

        #expect(apps.map(\.product) == [.mono, .filmo])
    }

    @Test("An empty selection yields no recommendations")
    func emptySelection() {
        #expect(CrossPromotionCatalog.apps(for: []).isEmpty)
    }

    @Test("Catalog identifiers are complete and unique")
    func catalogIdentifiersAreValid() {
        let apps = CrossPromotionCatalog.apps(for: CrossPromotionProduct.allCases)
        let ids = apps.map(\.appStoreID)
        let bundleIDs = apps.map(\.bundleIdentifier)

        #expect(apps.count == CrossPromotionProduct.allCases.count)
        #expect(ids.count == Set(ids).count)
        #expect(bundleIDs.count == Set(bundleIDs).count)
        #expect(ids.allSatisfy { !$0.isEmpty && $0.allSatisfy(\.isNumber) })
        #expect(apps.allSatisfy { !$0.name.isEmpty && !$0.subtitle.isEmpty })
    }

    @Test("Catalog names resolve through the package catalog")
    func catalogNamesUseLocalizedKeys() throws {
        let path = try #require(
            Bundle.module.path(forResource: "zh-Hans", ofType: "lproj")
        )
        let bundle = try #require(Bundle(path: path))
        let apps = CrossPromotionCatalog.apps(
            for: CrossPromotionProduct.allCases,
            localizationBundle: bundle
        )
        let names = Dictionary(uniqueKeysWithValues: apps.map { ($0.product, $0.name) })

        #expect(names[.mono] == "MONO 记账")
        #expect(names[.pickupCat] == "取件喵")
        #expect(names[.filmo] == "Filmo 书影音")
        #expect(names[.lastTime] == "LastTime 距今天数")
        #expect(names[.supamate] == "Supamate · Supabase")
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
