//
//  PDFViewCoordinator.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import SwiftUI
import PSPDFKit
import PSPDFKitUI
import Combine

extension PDFView {
    class Coordinator: NSObject {
        @Binding var document: PDFViewerDocument
        var cancelSet = Set<AnyCancellable>()
        var pdfView: PDFView

        weak var pdfController: PDFViewController? {
            didSet {
                // Bind page index publisher -> page index binding
                guard let controller = pdfController, oldValue != pdfController else { return }

                if let binding = pdfView.pageIndexBinding {
                    controller.pageIndexPublisher.sink { pageIndex in
                        DispatchQueue.main.async {
                            binding.wrappedValue = pageIndex
                        }
                    }.store(in: &cancelSet)
                }

                if let actions = pdfView.actionEventPublisher {
                    actions.sink { [weak controller] actionEvent in
                        guard let controller = controller else { return }
                        PDFView.execute(actionEvent: actionEvent, controller: controller)
                    }.store(in: &cancelSet)
                }
            }
        }

        init(document: Binding<PDFViewerDocument>, pdfView: PDFView) {
            _document = document
            self.pdfView = pdfView

            let referencedDocument = document.wrappedValue.referencedDocument
            referencedDocument.annotationChangePublisher.sink { _ in
                document.wrappedValue.referencedDocument = referencedDocument
            }.store(in: &cancelSet)
        }
    }
}
