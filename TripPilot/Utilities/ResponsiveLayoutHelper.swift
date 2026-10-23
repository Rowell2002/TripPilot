import SwiftUI

// MARK: - Responsive Layout View Extension
public extension View {
    /// Constrains the view's maximum content width on iPad / Regular size classes
    /// and centers it, while keeping natural full width on iPhone / Compact size classes.
    @ViewBuilder
    func responsiveContentWidth(_ maxWidth: CGFloat = 860) -> some View {
        self.modifier(ResponsiveContentModifier(maxWidth: maxWidth))
    }
}

public struct ResponsiveContentModifier: ViewModifier {
    let maxWidth: CGFloat
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var isRegular: Bool {
        horizontalSizeClass == .regular || UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public func body(content: Content) -> some View {
        if isRegular {
            content
                .frame(maxWidth: maxWidth)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            content
        }
    }
}

// MARK: - Device Layout Helper
public enum DeviceLayout {
    public static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
