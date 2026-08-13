import SwiftUI

@MainActor
public struct CrossPromotionRowStyleConfiguration {
    public let app: CrossPromotionApp
    public let icon: Image?
    public let open: () -> Void

    init(app: CrossPromotionApp, icon: Image?, open: @escaping () -> Void) {
        self.app = app
        self.icon = icon
        self.open = open
    }
}

@MainActor
public protocol CrossPromotionRowStyle {
    associatedtype Body: View

    @ViewBuilder
    func makeBody(configuration: CrossPromotionRowStyleConfiguration) -> Body
}

public struct SystemCrossPromotionRowStyle: CrossPromotionRowStyle {
    public init() {}

    public func makeBody(
        configuration: CrossPromotionRowStyleConfiguration
    ) -> some View {
        Button(action: configuration.open) {
            HStack {
                icon(configuration.icon)

                VStack(alignment: .leading) {
                    Text(configuration.app.name)
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(configuration.app.subtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Text(String(localized: "Get", bundle: .module))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tint)
                    .padding(.horizontal)
                    // The compact vertical inset is part of the App Store-style Get badge.
                    .padding(.vertical, 6)
                    .background(.quaternary, in: Capsule())
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(
            Text(String(localized: "Opens in the App Store", bundle: .module))
        )
    }

    @ViewBuilder
    private func icon(_ image: Image?) -> some View {
        let dimension: CGFloat = 50
        let shape = RoundedRectangle(
            cornerRadius: dimension * 0.22,
            style: .continuous
        )

        if let image {
            image
                .resizable()
                .scaledToFit()
                .frame(width: dimension, height: dimension)
                .clipShape(shape)
        } else {
            shape
                .fill(.quaternary)
                .frame(width: dimension, height: dimension)
                .overlay {
                    Image(systemName: "app.fill")
                        .foregroundStyle(.secondary)
                }
        }
    }
}

