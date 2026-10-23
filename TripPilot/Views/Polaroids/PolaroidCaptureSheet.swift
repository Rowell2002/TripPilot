import SwiftUI
import PhotosUI

// MARK: - Camera / Photo Library UIKit Representable
struct ImagePickerCoordinator: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            picker.sourceType = sourceType
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerCoordinator
        
        init(_ parent: ImagePickerCoordinator) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let edited = info[.editedImage] as? UIImage {
                parent.selectedImage = edited
            } else if let original = info[.originalImage] as? UIImage {
                parent.selectedImage = original
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Polaroid Capture & Creation Sheet
struct PolaroidCaptureSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var galleryService = PolaroidGalleryService.shared
    
    // Captured / Selected Photo
    @State private var capturedImage: UIImage? = nil
    @State private var captionText: String = "Weston + Elise"
    @State private var locationText: String = "Sigiriya, Sri Lanka"
    @State private var captureDate: Date = Date()
    @State private var saveToPhotosLibrary: Bool = true
    
    // Modal states for picker
    @State private var showCameraPicker: Bool = false
    @State private var showPhotoLibraryPicker: Bool = false
    @State private var showSaveSuccessToast: Bool = false
    
    // Quick location tags
    private let quickLocations = [
        "Sigiriya Lion Rock",
        "Nine Arch Bridge, Ella",
        "Galle Fort Ramparts",
        "Mirissa Sunset",
        "Kandy Temple",
        "Yala Safari",
        "Colombo Coastline"
    ]
    
    // Theme
    @AppStorage("appSelectedTheme") private var appSelectedTheme: String = "Dark"
    private var isDarkMode: Bool { appSelectedTheme != "Light" }
    
    private var surfaceDark: Color {
        isDarkMode ? Color(red: 17/255, green: 24/255, blue: 39/255) : Color(red: 241/255, green: 245/255, blue: 249/255)
    }
    private var surfaceCard: Color {
        isDarkMode ? Color(red: 22/255, green: 31/255, blue: 48/255) : Color.white
    }
    private var darkBackground: Color {
        isDarkMode ? Color(red: 10/255, green: 14/255, blue: 22/255) : Color(red: 248/255, green: 250/255, blue: 252/255)
    }
    private var containerBorder: Color {
        isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.08)
    }
    private var slateLight: Color {
        isDarkMode ? Color(red: 226/255, green: 232/255, blue: 240/255) : Color(red: 15/255, green: 23/255, blue: 42/255)
    }
    private var slateMuted: Color {
        isDarkMode ? Color(red: 148/255, green: 163/255, blue: 184/255) : Color(red: 100/255, green: 116/255, blue: 139/255)
    }
    private let primaryCyan = Color(red: 68/255, green: 226/255, blue: 205/255)
    private let skyBlue = Color(red: 56/255, green: 189/255, blue: 248/255)
    private let amberGold = Color(red: 251/255, green: 191/255, blue: 36/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                darkBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 1. Live Polaroid Preview Frame
                        previewSection
                            .padding(.top, 10)
                        
                        // 2. Camera & Photo Source Action Buttons
                        sourceButtonsSection
                        
                        // 3. Caption & Location Customization
                        metadataInputsSection
                        
                        // 4. Save Button
                        saveActionButton
                            .padding(.top, 10)
                            .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Capture Special Moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(slateMuted)
                }
            }
            .sheet(isPresented: $showCameraPicker) {
                ImagePickerCoordinator(sourceType: .camera, selectedImage: $capturedImage)
            }
            .sheet(isPresented: $showPhotoLibraryPicker) {
                ImagePickerCoordinator(sourceType: .photoLibrary, selectedImage: $capturedImage)
            }
            .onAppear {
                if capturedImage == nil {
                    // Default to sample if user opens on simulator
                    captionText = "Sigiriya Sunset Walk"
                    locationText = "Central Province, Sri Lanka"
                }
            }
        }
    }
    
    // MARK: - 1. Live Polaroid Preview
    private var previewSection: some View {
        VStack(spacing: 8) {
            Text("POLAROID PREVIEW")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .tracking(1.2)
                .foregroundColor(primaryCyan)
            
            // Rendered Preview Card
            let previewMoment = PolaroidMoment(
                caption: captionText.isEmpty ? "Special Moment" : captionText,
                locationName: locationText,
                date: captureDate,
                rotationDegrees: 0
            )
            
            ZStack {
                if let img = capturedImage {
                    // Custom user image
                    PolaroidUserCardView(image: img, caption: previewMoment.caption, formattedDate: previewMoment.formattedDate, cardWidth: 260)
                } else {
                    // Fallback to sample photo
                    PolaroidCardView(moment: previewMoment, cardWidth: 260)
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    // MARK: - 2. Source Buttons
    private var sourceButtonsSection: some View {
        HStack(spacing: 12) {
            // Camera Button
            Button(action: {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showCameraPicker = true
                } else {
                    // Simulator fallback
                    showPhotoLibraryPicker = true
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 14, weight: .bold))
                    Text("Take Photo")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                }
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(colors: [primaryCyan, skyBlue], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
                .shadow(color: primaryCyan.opacity(0.3), radius: 8, y: 3)
            }
            
            // Photo Library Button
            Button(action: {
                showPhotoLibraryPicker = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 14, weight: .semibold))
                    Text("From Library")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                }
                .foregroundColor(slateLight)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(surfaceDark)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(containerBorder, lineWidth: 1))
            }
        }
    }
    
    // MARK: - 3. Metadata Inputs
    private var metadataInputsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Caption / Title Input
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "signature")
                        .foregroundColor(primaryCyan)
                        .font(.system(size: 13))
                    Text("Handwritten Caption / Memory Name")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(slateLight)
                }
                
                TextField("e.g. Weston + Elise or Sigiriya Citadel", text: $captionText)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(slateLight)
                    .padding(12)
                    .background(surfaceCard)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(containerBorder, lineWidth: 1))
            }
            
            // Quick Location Chips
            VStack(alignment: .leading, spacing: 8) {
                Text("Popular Ceylon Locations")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(slateMuted)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(quickLocations, id: \.self) { loc in
                            Button(action: {
                                withAnimation {
                                    captionText = loc
                                    locationText = loc
                                }
                            }) {
                                Text(loc)
                                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                                    .foregroundColor(captionText == loc ? Color.black : slateLight)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(captionText == loc ? primaryCyan : surfaceCard)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(containerBorder, lineWidth: 1))
                            }
                        }
                    }
                }
            }
            
            // Date Picker
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(amberGold)
                        .font(.system(size: 13))
                    Text("Recorded Date")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(slateLight)
                    
                    Spacer()
                    
                    DatePicker("", selection: $captureDate, displayedComponents: [.date])
                        .labelsHidden()
                        .colorScheme(isDarkMode ? .dark : .light)
                }
                .padding(12)
                .background(surfaceCard)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(containerBorder, lineWidth: 1))
            }
            
            // Save to Camera Roll Toggle
            Toggle(isOn: $saveToPhotosLibrary) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.down.fill")
                        .foregroundColor(primaryCyan)
                    Text("Also save Polaroid to iPhone Photos")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(slateLight)
                }
            }
            .padding(12)
            .background(surfaceCard)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(containerBorder, lineWidth: 1))
        }
        .padding(16)
        .background(surfaceDark)
        .cornerRadius(18)
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(containerBorder, lineWidth: 1))
    }
    
    // MARK: - 4. Save Action Button
    private var saveActionButton: some View {
        Button(action: {
            saveMoment()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 15, weight: .bold))
                Text("Save to Polaroid Album")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
            }
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                LinearGradient(colors: [primaryCyan, skyBlue], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: primaryCyan.opacity(0.35), radius: 10, y: 4)
        }
    }
    
    // MARK: - Save Logic
    private func saveMoment() {
        // If user picked/captured image, use it; otherwise create a snapshot image from preview
        let finalImage = capturedImage ?? createSampleImage()
        let finalCaption = captionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Special Moment" : captionText
        
        galleryService.addMoment(
            image: finalImage,
            caption: finalCaption,
            location: locationText,
            date: captureDate
        )
        
        if saveToPhotosLibrary {
            // Render authentic Polaroid frame matching reference example (photo + handwritten caption + date in frame)
            if let renderedPolaroid = renderPolaroidCard(image: finalImage, caption: finalCaption, date: captureDate) {
                UIImageWriteToSavedPhotosAlbum(renderedPolaroid, nil, nil, nil)
            } else {
                UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            }
        }
        
        dismiss()
    }
    
    // MARK: - Render Authentic Polaroid Frame
    @MainActor
    private func renderPolaroidCard(image: UIImage, caption: String, date: Date) -> UIImage? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        let dateString = formatter.string(from: date)
        
        let card = PolaroidUserCardView(
            image: image,
            caption: caption,
            formattedDate: dateString,
            cardWidth: 360
        )
        .padding(16)
        .background(Color.clear)
        
        let renderer = ImageRenderer(content: card)
        renderer.scale = 2.0
        return renderer.uiImage
    }
    
    private func createSampleImage() -> UIImage {
        let size = CGSize(width: 800, height: 800)
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        let ctx = UIGraphicsGetCurrentContext()!
        
        // Draw sunset gradient
        let colors = [
            UIColor(red: 251/255, green: 146/255, blue: 60/255, alpha: 1.0).cgColor,
            UIColor(red: 244/255, green: 63/255, blue: 94/255, alpha: 1.0).cgColor
        ]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0.0, 1.0])!
        ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [])
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}

// MARK: - User Image Polaroid Preview Card
struct PolaroidUserCardView: View {
    let image: UIImage
    let caption: String
    let formattedDate: String
    var cardWidth: CGFloat = 260
    
    private var photoPadding: CGFloat { cardWidth * 0.06 }
    private var photoWidth: CGFloat { cardWidth - (photoPadding * 2) }
    private var photoHeight: CGFloat { photoWidth * 0.96 }
    private var bottomChinHeight: CGFloat { cardWidth * 0.36 }
    private var totalHeight: CGFloat { photoPadding + photoHeight + bottomChinHeight }
    
    private let paperColor = Color(red: 250/255, green: 249/255, blue: 246/255)
    private let paperBorder = Color(red: 228/255, green: 225/255, blue: 218/255)
    private let inkColor = Color(red: 30/255, green: 41/255, blue: 59/255)
    private let dateColor = Color(red: 100/255, green: 116/255, blue: 139/255)
    
    var body: some View {
        VStack(spacing: 0) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: photoWidth, height: photoHeight)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.12), lineWidth: 0.8)
                )
                .padding(.top, photoPadding)
                .padding(.horizontal, photoPadding)
            
            VStack(spacing: 4) {
                Spacer()
                
                Text(caption)
                    .font(scriptFont(size: cardWidth > 250 ? 24 : 18))
                    .foregroundColor(inkColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 10)
                
                Text(formattedDate)
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
        .shadow(color: Color.black.opacity(0.22), radius: 10, x: 0, y: 6)
    }
    
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
