//
//  ContentView.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import SwiftUI
import PSPDFKit
import PSPDFKitUI
import Combine

struct ContentView: View {
    @Binding var document: PDFViewerDocument
    @State var pageIndex = PageIndex(0)
    @State var viewMode = ViewMode.document
    @State var actions = PassthroughSubject<PDFView.ActionEvent, Never>()

    var body: some View {
        ZStack {
            PDFView(document: $document,
                    pageIndex: $pageIndex,
                    viewMode: $viewMode,
                    actions: actions)
                .pageTransition(.scrollContinuous)
                .scrollDirection(.vertical)
                .updateConfiguration {
                    $0.userInterfaceViewMode = .always
                }
            PageLabel(pageIndex: $pageIndex)
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AnchorButton {
                    actions.send(.showOutline(sender: $0))
                } label: {
                    Image(systemName: "book")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewMode == .document {
                    Button {
                        viewMode = .thumbnails
                    } label: {
                        Image(systemName: "square.grid.2x2")
                    }
                } else {
                    Button {
                        viewMode = .document
                    } label: {
                        Image(systemName: "square.grid.2x2.fill")
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

