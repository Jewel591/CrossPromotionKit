import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct CrossPromotionSection<Style: CrossPromotionRowStyle>: View {
    private let style: Style
    private let apps: [CrossPromotionApp]

    /// - Parameter products: The apps this host recommends, in display order.
    public init(_ products: [CrossPromotionProduct], style: Style) {
        self.style = style
        apps = CrossPromotionCatalog.apps(for: products)
    }

    public var body: some View {
        if !apps.isEmpty {
            Section {
                CrossPromotionRows(apps: apps, style: style)
            } header: {
                Text(String(localized: "Our Other Apps", bundle: .module))
            }
        }
    }
}

public extension CrossPromotionSection where Style == SystemCrossPromotionRowStyle {
    init(_ products: [CrossPromotionProduct]) {
        self.init(products, style: SystemCrossPromotionRowStyle())
    }
}

public struct CrossPromotionRows<Style: CrossPromotionRowStyle>: View {
    private let apps: [CrossPromotionApp]
    private let style: Style

    /// - Parameter products: The apps this host recommends, in display order.
    public init(_ products: [CrossPromotionProduct], style: Style) {
        apps = CrossPromotionCatalog.apps(for: products)
        self.style = style
    }

    init(apps: [CrossPromotionApp], style: Style) {
        self.apps = apps
        self.style = style
    }

    public var body: some View {
        ForEach(apps) { app in
            CrossPromotionRow(app: app, style: style)
        }
    }
}

public extension CrossPromotionRows where Style == SystemCrossPromotionRowStyle {
    init(_ products: [CrossPromotionProduct]) {
        self.init(products, style: SystemCrossPromotionRowStyle())
    }
}

private struct CrossPromotionRow<Style: CrossPromotionRowStyle>: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.locale) private var locale

    let app: CrossPromotionApp
    let style: Style

    @State private var artworkData: Data?

    var body: some View {
        style.makeBody(
            configuration: CrossPromotionRowStyleConfiguration(
                app: app,
                icon: platformImage,
                open: {
                    if let appStoreURL = app.appStoreURL {
                        openURL(appStoreURL)
                    }
                }
            )
        )
        .task(id: app.appStoreID) {
            artworkData = await CrossPromotionArtworkLoader.shared.artworkData(
                for: app.appStoreID,
                regionCode: locale.region?.identifier
            )
        }
    }

    private var platformImage: Image? {
        guard let artworkData else { return nil }
        #if canImport(UIKit)
        // playbook-lint:disable-next-line swift-remote-image-suspect
        // reason: 图片数据来自 CrossPromotionArtworkLoader 的 64 MB URLCache 磁盘缓存。
        guard let image = UIImage(data: artworkData) else { return nil }
        return Image(uiImage: image)
        #elseif canImport(AppKit)
        // playbook-lint:disable-next-line swift-remote-image-suspect
        // reason: 图片数据来自 CrossPromotionArtworkLoader 的 64 MB URLCache 磁盘缓存。
        guard let image = NSImage(data: artworkData) else { return nil }
        return Image(nsImage: image)
        #else
        return nil
        #endif
    }
}
