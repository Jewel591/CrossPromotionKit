# CrossPromotionKit

`CrossPromotionKit` is a public Swift Package for the studio's “More from Us” surfaces on
Apple platforms. It keeps one fixed product catalog, separates consumer apps from developer
tools, selects the correct audience from the host Bundle ID, and always removes the host app.

## Fixed audiences

- `consumer`: MONO, Pickup Cat, Filmo, LastTime, and unpublished hosts such as ScreenStudies.
- `developer`: Supamate and unpublished developer tools such as Apper.

An unknown host receives an empty catalog. This intentionally prevents a consumer app from
showing developer tools after a registration mistake.

## Standard UI

```swift
import CrossPromotionKit

Form {
    CrossPromotionSection()
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

CrossPromotionSection(style: BrandCrossPromotionStyle())
```

For a custom section container, place `CrossPromotionRows(style:)` inside the host's own
`Section` or card. Apps do not pass catalog entries or audience values.

## Requirements

- iOS 17+
- macOS 14+
- visionOS 1+
- Swift 6

