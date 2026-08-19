# CrossPromotionKit

Public Swift Package for the studio's fixed cross-promotion catalog on Apple platforms.

## Product boundary

- The package owns the fixed consumer/developer audiences, host Bundle ID mapping, published
  app catalog, host exclusion, App Store links, artwork lookup/cache, diagnostics, localization,
  and optional SwiftUI surfaces.
- Host apps own placement and may replace row rendering through `CrossPromotionRowStyle`.
- An unknown host fails closed with an empty catalog. Never fall back to mixing audiences.
- App identity, audience membership, ordering, and publication state are not external parameters.
- Add an app only after its App Store ID is live; unpublished hosts may be registered solely so
  their audience is known while their own section remains empty.

## Engineering

- Swift 6 strict concurrency.
- Public API supports iOS 17, macOS 14, and visionOS 1.
- Use English source literals and the package String Catalog for every user-visible string.
- Standard UI uses system sections, semantic text styles, controls, and adaptive colors.
- Do not depend on a host app, analytics SDK, RevenueCat, or third-party image library.
- Catalog and cache changes require focused unit tests.
