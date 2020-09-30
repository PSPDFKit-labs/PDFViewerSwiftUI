//
//  PDFViewDelegates.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import Foundation
import PSPDFKit
import PSPDFKitUI

extension PDFView.Coordinator: PDFViewControllerDelegate {
    
    func pdfViewController(_ pdfController: PDFViewController, didChange viewMode: ViewMode) {
        guard let binding = pdfView.viewModeBinding else { return }
        if binding.wrappedValue != viewMode {
            DispatchQueue.main.async {
                binding.wrappedValue = viewMode
            }
        }
    }
}
