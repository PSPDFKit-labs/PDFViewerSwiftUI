//
//  PDFViewerDocument.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import SwiftUI
import UniformTypeIdentifiers
import PSPDFKit

struct PDFViewerDocument: FileDocument {
    var referencedDocument: Document

    init(data: Data = blankPDFData()) {
        self.referencedDocument = Document(data: data)
    }

    static var readableContentTypes: [UTType] { [.pdf] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.referencedDocument = Document(data: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return .init(regularFileWithContents: referencedDocument.data!)
    }
}

private func blankPDFData() -> Data {
    let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 210, height: 297),
                                         format: UIGraphicsPDFRendererFormat())
    return renderer.pdfData {
        $0.beginPage()
    }
}
