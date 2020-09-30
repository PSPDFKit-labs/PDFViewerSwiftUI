//
//  PDFViewerApp.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import SwiftUI

@main
struct PDFViewerApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: PDFViewerDocument()) { file in
            ContentView(document: file.$document)
                .onAppear { setupLicense() }
        }
    }
}
