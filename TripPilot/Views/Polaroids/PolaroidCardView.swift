import SwiftUI

// MARK: - Polaroid Card View
struct PolaroidCardView: View {
    let moment: PolaroidMoment
    var cardWidth: CGFloat = 200
    var isInteractive: Bool = true
    
    // Proportional dimensions based on real Polaroid 600 format
    private var photoPadding: CGFloat { cardWidth * 0.06 }
    private var photoWidth: CGFloat { cardWidth - (photoPadding * 2) }
    private var photoHeight: CGFloat { photoWidth * 0.96 }
    private var bottomChinHeight: CGFloat { cardWidth * 0.36 }
    private var totalHeight: CGFloat { photoPadding + photoHeight + bottomChinHeight }
    
    // Authentic Polaroid paper background color
    private let paperColor = Color(red: 250/255, green: 249/255, blue: 246/255)
    private let paperBorder = Color(red: 228/255, green: 225/255, blue: 218/255)
    private let inkColor = Color(red: 30/255, green: 41/255, blue: 59/255)
    private let dateColor = Color(red: 100/255, green: 116/255, blue: 139/255)
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Photo Area with equal top/left/right border
            ZStack {
                Color(red: 235/255, green: 235/255, blue: 232/255)
                
                if let localImg = PolaroidGalleryService.shared.loadImage(for: moment) {
                    Image(uiImage: localImg)
                        .resizable()
                        .scaledToFill()
                        .frame(width: photoWidth, height: photoHeight)
                        .clipped()
                } else if let remoteUrl = moment.remoteImageUrl, let url = URL(string: remoteUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .tint(Color.gray)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: photoWidth, height: photoHeight)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo.fill")
                                .font(.system(size: 28))
                                .foregroundColor(Color.gray.opacity(0.6))
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color.gray.opacity(0.6))
                }
            }
            .frame(width: photoWidth, height: photoHeight)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.black.opacity(0.12), lineWidth: 0.8)
            )
            .padding(.top, photoPadding)
            .padding(.horizontal, photoPadding)
            
            // 2. Large Bottom Chin with handwritten caption & date
            VStack(spacing: 4) {
                Spacer()
                
                // Location / Memory Caption (Handwritten cursive script)
                Text(moment.caption)
                    .font(scriptFont(size: cardWidth > 250 ? 24 : 18))
                    .foregroundColor(inkColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 10)
                
                // Formatted Date (e.g. 10.21.2020)
                Text(moment.formattedDate)
                    .font(.system(size: cardWidth > 250 ? 12 : 9.5, weight: .bold, design: .monospaced))
                    .tracking(1.4)
                    .foregroundColor(dateColor)
                
                Spacer()
            }
            .frame(width: cardWidth, height: bottomChinHeight)
        }
        .frame(width: cardWidth, height: totalHeight)
        .background(paperColor)
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(paperBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.22), radius: 8, x: 0, y: 5)
    }
    
    // MARK: - Script Font Helper
    private func scriptFont(size: CGFloat) -> Font {
        #if canImport(UIKit)
        if UIFont(name: "Snell Roundhand", size: size) != nil {
            return Font.custom("Snell Roundhand", size: size).weight(.medium)
        } else if UIFont(name: "Bradley Hand", size: size) != nil {
            return Font.custom("Bradley Hand", size: size).weight(.bold)
        }
        #endif
        return Font.system(size: size, weight: .medium, design: .serif).italic()
    }
}
