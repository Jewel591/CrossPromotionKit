# CrossPromotionKit

Public Swift Package for the studio's cross-promotion catalog and surfaces on Apple platforms.

## Product boundary

- The package owns the published product catalog (`CrossPromotionProduct` and its Bundle ID,
  App Store ID, localized name and subtitle), App Store links, artwork lookup/cache,
  diagnostics, localization, and optional SwiftUI surfaces.
- Each host app decides which products it shows and in what order, and passes that selection
  to `CrossPromotionSection` / `CrossPromotionRows`. The package has no audiences, no host
  Bundle ID mapping, and no automatic selection or host exclusion.
- Host apps own placement and may replace row rendering through `CrossPromotionRowStyle`.
- Hosts reference products only through `CrossPromotionProduct`; App Store IDs, names, and
  links are not external parameters.
- Add a product only after its App Store ID is live.

## Engineering

- Swift 6 strict concurrency.
- Public API supports iOS 17, macOS 14, and visionOS 1.
- Use English source literals and the package String Catalog for every user-visible string.
- Standard UI uses system sections, semantic text styles, controls, and adaptive colors.
- Do not depend on a host app, analytics SDK, RevenueCat, or third-party image library.
- Catalog and cache changes require focused unit tests.
