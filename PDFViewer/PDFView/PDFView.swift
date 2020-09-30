//
//  PDFView.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import SwiftUI
import PSPDFKit
import PSPDFKitUI
import Combine

struct PDFView: UIViewControllerRepresentable {
    @Binding var document: PDFViewerDocument
    var pageIndexBinding: Binding<PageIndex>?
    var viewModeBinding: Binding<ViewMode>?
    var actionEventPublisher: PassthroughSubject<PDFView.ActionEvent, Never>?

    let baseConfiguration: PDFConfiguration
    var configurationModifiers = [((PDFConfigurationBuilder) -> Void)]()

    init(document: Binding<PDFViewerDocument>,
         pageIndex: Binding<PageIndex>? = nil,
         viewMode: Binding<ViewMode>? = nil,
         actions: PassthroughSubject<PDFView.ActionEvent, Never>? = nil,
         configuration: PDFConfiguration = PDFConfiguration.default()) {
        _document = document
        pageIndexBinding = pageIndex
        viewModeBinding = viewMode
        baseConfiguration = configuration
        actionEventPublisher = actions
    }

    func makeUIViewController(context: Context) -> PDFViewController {
        PDFViewController(document: document.referencedDocument, configuration: baseConfiguration)
    }

    func updateUIViewController(_ controller: PDFViewController, context: Context) {
        controller.document = document.referencedDocument
        controller.delegate = context.coordinator
        if context.coordinator.pdfController != controller {
            context.coordinator.pdfController = controller
        }

        let newConfiguration = baseConfiguration.configurationUpdated { builder in
            configurationModifiers.forEach { $0(builder) }
        }
        if newConfiguration != controller.configuration {
            controller.updateConfiguration { builder in
                configurationModifiers.forEach { $0(builder) }
            }
        }

        if let viewModeBinding = viewModeBinding, controller.viewMode != viewModeBinding.wrappedValue {
            controller.setViewMode(viewModeBinding.wrappedValue, animated: true)
        }

        if let pageIndexBinding = pageIndexBinding,
           controller.pageIndex != pageIndexBinding.wrappedValue {
            controller.pageIndex = pageIndexBinding.wrappedValue
        }


    }

    func makeCoordinator() -> Coordinator {
        Coordinator(document: $document, pdfView: self)
    }
}
