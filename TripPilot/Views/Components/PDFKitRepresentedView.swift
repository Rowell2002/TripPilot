//
//  PDFKitRepresentedView.swift
//  TripPilot
//

import SwiftUI
import PDFKit

public struct PDFKitRepresentedView: UIViewRepresentable {
    public let data: Data
    public var singlePage: Bool = true
    
    public init(data: Data, singlePage: Bool = true) {
        self.data = data
        self.singlePage = singlePage
    }
    
    public func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        pdfView.displayMode = singlePage ? .singlePage : .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = UIColor(red: 15/255, green: 19/255, blue: 28/255, alpha: 1.0)
        return pdfView
    }
    
    public func updateUIView(_ uiView: PDFView, context: Context) {
        if uiView.document == nil || uiView.document?.dataRepresentation() != data {
            uiView.document = PDFDocument(data: data)
            uiView.autoScales = true
        }
    }
}
