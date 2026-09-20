# CrossPromotionKit

`CrossPromotionKit` is a public Swift Package for the studio's “More from Us” surfaces on
Apple platforms. The package owns the metadata of every published app; each host app chooses
which products it recommends and in what order.

## Products

`CrossPromotionProduct` lists the published apps: `.mono`, `.pickupCat`, `.filmo`, `.lastTime`,
and `.supamate`. A product joins the enum only after its App Store ID is live.

The host passes its own selection. Products render in the order given, and a product listed
twice renders once.

## Standard UI

```swift
import CrossPromotionKit

Form {
    CrossPromotionSection([.pickupCat, .filmo])
}
```

The standard section uses a system list row, localized title/subtitle, App Store artwork, and a
system-adaptive Get badge. Artwork lookup and image responses use a package-owned disk cache.

## Custom UI

Implement `CrossPromotionRowStyle` to replace a row without copying catalog or lookup logic:

```swift
struct BrandCrossPromotionStyle: CrossPromotionRowStyle {
    func makeBody(configuration: CrossPromotionRowStyleConfiguration) -> some View {
        Button(action: configuration.open) {
            // Render configuration.app and configuration.icon.
        }
    }
}

CrossPromotionSection([.pickupCat, .filmo], style: BrandCrossPromotionStyle())
```

For a custom section container, place `CrossPromotionRows(_:style:)` inside the host's own
`Section` or card. Hosts reference products by `CrossPromotionProduct`; they never pass App
Store IDs, names, or links.

## Requirements

- iOS 17+
- macOS 14+
- visionOS 1+
- Swift 6

