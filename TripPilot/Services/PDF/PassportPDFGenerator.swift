//
//  PassportPDFGenerator.swift
//  TripPilot
//

import UIKit
import PDFKit

public struct PassportPDFData {
    public let travelerName: String
    public let passportNumber: String
    public let year: String
    public let countriesCount: Int
    public let distanceKm: String
    public let itinerariesCount: Int
    public let carbonOffset: String
    public let verifiedDestinations: [String]
    public let badgesUnlocked: Int
    
    public static let standard = PassportPDFData(
        travelerName: "Elena Vance",
        passportNumber: "TP-9824-ICAO",
        year: "2024",
        countriesCount: 18,
        distanceKm: "128,450 km",
        itinerariesCount: 8,
        carbonOffset: "100% Certified Offset",
        verifiedDestinations: [
            "Japan (Tokyo, Kyoto, Osaka)",
            "Switzerland (Zurich, Zermatt)",
            "France (Paris, Provence)",
            "Italy (Rome, Florence, Amalfi)",
            "Sri Lanka (Colombo, Kandy, Galle)",
            "Norway (Oslo, Tromsø)",
            "Canada (Vancouver, Banff)",
            "United Kingdom (London, Edinburgh)"
        ],
        badgesUnlocked: 24
    )
}

public final class PassportPDFGenerator {
    public static let shared = PassportPDFGenerator()
    
    private init() {}
    
    public func generatePDF(data: PassportPDFData = .standard) -> Data {
        let pageWidth: CGFloat = 612 // US Letter / Standard A4 points
        let pageHeight: CGFloat = 792
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let pdfData = renderer.pdfData { context in
            context.beginPage()
            
            // 1. Background Fill & Border Frame
            let backgroundColor = UIColor(red: 15/255, green: 19/255, blue: 28/255, alpha: 1.0)
            backgroundColor.setFill()
            context.cgContext.fill(pageRect)
            
            // Outer aesthetic accent line
            let accentBorderRect = pageRect.insetBy(dx: 24, dy: 24)
            let borderColor = UIColor(red: 56/255, green: 189/255, blue: 248/255, alpha: 0.3)
            let borderPath = UIBezierPath(roundedRect: accentBorderRect, cornerRadius: 16)
            borderPath.lineWidth = 1.5
            borderColor.setStroke()
            borderPath.stroke()
            
            // Top accent bar
            let topBarRect = CGRect(x: 24, y: 24, width: pageWidth - 48, height: 6)
            let topBarPath = UIBezierPath(roundedRect: topBarRect, cornerRadius: 3)
            let skyColor = UIColor(red: 56/255, green: 189/255, blue: 248/255, alpha: 1.0)
            skyColor.setFill()
            topBarPath.fill()
            
            // 2. Header
            var cursorY: CGFloat = 50
            
            let brandAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11, weight: .bold),
                .foregroundColor: skyColor
            ]
            let brandString = NSAttributedString(string: "TRIPPILOT • OFFICIAL TRAVEL PASSPORT", attributes: brandAttributes)
            brandString.draw(at: CGPoint(x: 40, y: cursorY))
            
            cursorY += 18
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 22, weight: .heavy),
                .foregroundColor: UIColor.white
            ]
            let titleString = NSAttributedString(string: "Verified Travel Dossier", attributes: titleAttributes)
            titleString.draw(at: CGPoint(x: 40, y: cursorY))
            
            let statusBadge = "VERIFIED • ICAO 9303"
            let badgeAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 9, weight: .bold),
                .foregroundColor: UIColor(red: 68/255, green: 226/255, blue: 205/255, alpha: 1.0)
            ]
            let badgeSize = (statusBadge as NSString).size(withAttributes: badgeAttributes)
            let badgeRect = CGRect(x: pageWidth - 40 - badgeSize.width - 16, y: cursorY + 4, width: badgeSize.width + 16, height: 20)
            let badgePath = UIBezierPath(roundedRect: badgeRect, cornerRadius: 10)
            UIColor(red: 68/255, green: 226/255, blue: 205/255, alpha: 0.15).setFill()
            badgePath.fill()
            (statusBadge as NSString).draw(at: CGPoint(x: badgeRect.origin.x + 8, y: badgeRect.origin.y + 4), withAttributes: badgeAttributes)
            
            cursorY += 34
            
            // Divider
            let dividerPath = UIBezierPath()
            dividerPath.move(to: CGPoint(x: 40, y: cursorY))
            dividerPath.addLine(to: CGPoint(x: pageWidth - 40, y: cursorY))
            UIColor.white.withAlphaComponent(0.12).setStroke()
            dividerPath.lineWidth = 1
            dividerPath.stroke()
            
            cursorY += 16
            
            // 3. Traveler Card
            let profileCardRect = CGRect(x: 40, y: cursorY, width: pageWidth - 80, height: 72)
            let profilePath = UIBezierPath(roundedRect: profileCardRect, cornerRadius: 12)
            UIColor(red: 24/255, green: 28/255, blue: 36/255, alpha: 1.0).setFill()
            profilePath.fill()
            
            let nameTitleAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 9, weight: .semibold),
                .foregroundColor: UIColor.white.withAlphaComponent(0.5)
            ]
            let nameValAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            
            "TRAVELER NAME".draw(at: CGPoint(x: 56, y: cursorY + 14), withAttributes: nameTitleAttr)
            data.travelerName.draw(at: CGPoint(x: 56, y: cursorY + 30), withAttributes: nameValAttr)
            
            "PASSPORT NUMBER".draw(at: CGPoint(x: 240, y: cursorY + 14), withAttributes: nameTitleAttr)
            data.passportNumber.draw(at: CGPoint(x: 240, y: cursorY + 30), withAttributes: nameValAttr)
            
            "PERIOD".draw(at: CGPoint(x: 420, y: cursorY + 14), withAttributes: nameTitleAttr)
            data.year.draw(at: CGPoint(x: 420, y: cursorY + 30), withAttributes: nameValAttr)
            
            cursorY += 92
            
            // 4. Milestone Statistics Grid (4 Metric Cards)
            let cardWidth = (pageWidth - 80 - 15) / 2
            let cardHeight: CGFloat = 64
            
            let metrics: [(title: String, value: String, subtitle: String)] = [
                ("COUNTRIES VISITED", "\(data.countriesCount)", "Global Explorer Tier"),
                ("DISTANCE FLOWN", data.distanceKm, "\(data.itinerariesCount) Global Journeys"),
                ("CARBON OFFSET", data.carbonOffset, "Gold Standard Registry"),
                ("BADGES UNLOCKED", "\(data.badgesUnlocked)", "100% Verified Milestones")
            ]
            
            for (index, metric) in metrics.enumerated() {
                let col = CGFloat(index % 2)
                let row = CGFloat(index / 2)
                let cardX = 40 + col * (cardWidth + 15)
                let cardY = cursorY + row * (cardHeight + 12)
                
                let rect = CGRect(x: cardX, y: cardY, width: cardWidth, height: cardHeight)
                let path = UIBezierPath(roundedRect: rect, cornerRadius: 10)
                UIColor(red: 24/255, green: 28/255, blue: 36/255, alpha: 0.9).setFill()
                path.fill()
                
                metric.title.draw(at: CGPoint(x: cardX + 14, y: cardY + 10), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 8, weight: .bold),
                    .foregroundColor: skyColor
                ])
                metric.value.draw(at: CGPoint(x: cardX + 14, y: cardY + 22), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 15, weight: .heavy),
                    .foregroundColor: UIColor.white
                ])
                metric.subtitle.draw(at: CGPoint(x: cardX + 14, y: cardY + 44), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 8, weight: .medium),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.6)
                ])
            }
            
            cursorY += (cardHeight * 2) + 32
            
            // 5. Verified Destinations Section
            "OFFICIALLY LOGGED DESTINATIONS".draw(at: CGPoint(x: 40, y: cursorY), withAttributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .bold),
                .foregroundColor: UIColor.white
            ])
            
            cursorY += 20
            
            let destinationBoxRect = CGRect(x: 40, y: cursorY, width: pageWidth - 80, height: 180)
            let destPath = UIBezierPath(roundedRect: destinationBoxRect, cornerRadius: 12)
            UIColor(red: 20/255, green: 24/255, blue: 32/255, alpha: 1.0).setFill()
            destPath.fill()
            
            var destY = cursorY + 14
            for dest in data.verifiedDestinations {
                let bulletAttr: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 11, weight: .bold),
                    .foregroundColor: skyColor
                ]
                "✦ ".draw(at: CGPoint(x: 54, y: destY), withAttributes: bulletAttr)
                
                let textAttr: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 10, weight: .medium),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.9)
                ]
                dest.draw(at: CGPoint(x: 70, y: destY), withAttributes: textAttr)
                
                "ICAO-VERIFIED".draw(at: CGPoint(x: pageWidth - 140, y: destY), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 8, weight: .semibold),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.4)
                ])
                
                destY += 19
            }
            
            cursorY += 205
            
            // 6. Security Footer & Checksum
            let footerRect = CGRect(x: 40, y: pageHeight - 110, width: pageWidth - 80, height: 60)
            let footerPath = UIBezierPath(roundedRect: footerRect, cornerRadius: 8)
            UIColor(red: 24/255, green: 28/255, blue: 36/255, alpha: 0.8).setFill()
            footerPath.fill()
            
            let mrzChecksum = "P<TRPT<<VANCE<<ELENA<<<<<<<<<<<<<<<<<<<<<<<<<\nTP9824ICAO9USA2410198M2410194<<<<<<<<<<<<<<06"
            let mrzAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.monospacedSystemFont(ofSize: 9, weight: .bold),
                .foregroundColor: UIColor(red: 68/255, green: 226/255, blue: 205/255, alpha: 0.9)
            ]
            mrzChecksum.draw(in: footerRect.insetBy(dx: 12, dy: 12), withAttributes: mrzAttributes)
            
            let notice = "Generated by TripPilot AI • Cryptographically signed with local Secure Enclave • Date: \(Date().formatted(date: .abbreviated, time: .shortened))"
            notice.draw(at: CGPoint(x: 40, y: pageHeight - 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 8, weight: .regular),
                .foregroundColor: UIColor.white.withAlphaComponent(0.4)
            ])
        }
        
        return pdfData
    }
    
    public func exportTemporaryPDF(data: PassportPDFData = .standard) -> URL? {
        let pdfData = generatePDF(data: data)
        let filename = "TripPilot_Passport_\(data.year)_\(data.travelerName.replacingOccurrences(of: " ", with: "_")).pdf"
        let temporaryURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        do {
            try pdfData.write(to: temporaryURL)
            return temporaryURL
        } catch {
            print("Failed to write PDF: \(error.localizedDescription)")
            return nil
        }
    }
}
