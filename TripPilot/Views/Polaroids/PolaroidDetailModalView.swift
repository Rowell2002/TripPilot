import SwiftUI

// MARK: - Polaroid Detail Modal View
struct PolaroidDetailModalView: View {
    let moment: PolaroidMoment
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var galleryService = PolaroidGalleryService.shared
    
    @State private var showDeleteConfirmation = false
    @State private var showSavedToast = false
    @State private var renderedPolaroidImage: UIImage? = nil
    
    // Theme
    @AppStorage("appSelectedTheme") private var appSelectedTheme: String = "Dark"
    private var isDarkMode: Bool { appSelectedTheme != "Light" }
    
    private var darkBackground: Color {
        isDarkMode ? Color(red: 10/255, green: 14/255, blue: 22/255) : Color(red: 248/255, green: 250/255, blue: 252/255)
    }
    private var surfaceDark: Color {
        isDarkMode ? Color(red: 17/255, green: 24/255, blue: 39/255) : Color(red: 241/255, green: 245/255, blue: 249/255)
    }
    private var containerBorder: Color {
        isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.08)
    }
    private var slateLight: Color {
        isDarkMode ? Color(red: 226/255, green: 232/255, blue: 240/255) : Color(red: 15/255, green: 23/255, blue: 42/255)
    }
    private var slateMuted: Color {
        isDarkMode ? Color(red: 148/255, green: 163/255, blue: 184/255) : Color(red: 100/255, green: 116/255, blue: 139/255)
    }
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)
    private let coralAccent = Color(red: 251/255, green: 113/255, blue: 133/255)
    
    var body: some View {
        ZStack {
            darkBackground.ignoresSafeArea()
            
            // Ambient subtle backlight
            Circle()
                .fill(skyBlue.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
            
            VStack(spacing: 24) {
                // Top Header Bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(slateMuted.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Text("Polaroid Memory")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(slateLight)
                    
                    Spacer()
                    
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(coralAccent)
                            .frame(width: 36, height: 36)
                            .background(coralAccent.opacity(0.12))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Authentic Polaroid Card (Centered & Large)
                PolaroidCardView(moment: moment, cardWidth: 290, isInteractive: false)
                    .rotationEffect(.degrees(moment.rotationDegrees))
                    .shadow(color: Color.black.opacity(0.4), radius: 25, x: 0, y: 14)
                
                Spacer()
                
                // Location & Details Strip
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(primaryCyan)
                            .font(.system(size: 13))
                        Text(moment.locationName)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(slateLight)
                    }
                    
                    Text("Recorded on \(moment.date.formatted(date: .long, time: .omitted))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(slateMuted)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(surfaceDark.opacity(0.7))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(containerBorder, lineWidth: 1))
                
                // Action Buttons: Save to Camera Roll & Share
                HStack(spacing: 14) {
                    // Save to Photos Button
                    Button(action: {
                        saveToPhotoAlbum()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.down.to.line.circle.fill")
                                .font(.system(size: 16, weight: .bold))
                            Text("Save to Photos")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: [primaryCyan, skyBlue], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: primaryCyan.opacity(0.35), radius: 8, y: 3)
                    }
                    
                    // Share Button
                    if let image = getShareableImage() {
                        ShareLink(item: Image(uiImage: image), preview: SharePreview(moment.caption, image: Image(uiImage: image))) {
                            HStack(spacing: 8) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 15, weight: .bold))
                                Text("Share")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(slateLight)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(surfaceDark)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(containerBorder, lineWidth: 1))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            
            // Success Toast
            if showSavedToast {
                VStack {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(primaryCyan)
                        Text("Polaroid saved to your iPhone Photos!")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(red: 22/255, green: 31/255, blue: 48/255))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(primaryCyan.opacity(0.4), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.4), radius: 10, y: 5)
                    .padding(.top, 40)
                    
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(200)
            }
        }
        .confirmationDialog(
            "Delete Polaroid?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete Forever", role: .destructive) {
                galleryService.deleteMoment(id: moment.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this special moment from your journal?")
        }
    }
    
    // MARK: - Save Rendered Polaroid to Album
    private func saveToPhotoAlbum() {
        if let polaroidImage = renderPolaroidFrame() {
            UIImageWriteToSavedPhotosAlbum(polaroidImage, nil, nil, nil)
            withAnimation(.spring()) {
                showSavedToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showSavedToast = false
                }
            }
        }
    }
    
    // MARK: - Shareable Image
    private func getShareableImage() -> UIImage? {
        renderPolaroidFrame() ?? galleryService.loadImage(for: moment)
    }
    
    // MARK: - Render Polaroid Frame to UIImage
    @MainActor
    private func renderPolaroidFrame() -> UIImage? {
        let viewToRender = PolaroidCardView(moment: moment, cardWidth: 340, isInteractive: false)
            .padding(16)
            .background(Color.clear)
        
        let renderer = ImageRenderer(content: viewToRender)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}
