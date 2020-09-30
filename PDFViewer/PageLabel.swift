//
//  PageLabel.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import SwiftUI
import PSPDFKit

struct PageLabel: View {
    @Binding var pageIndex: PageIndex

    @Environment(\.colorScheme) var colorScheme
    @State var showOverlayTime = 2
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("Page \(pageIndex + 1)")
            .font(.largeTitle)
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(25)
            .opacity(showOverlayTime == 0 ? 0 : 1)
            .scaleEffect(showOverlayTime == 0 ? 0.9 : 1)
            .blur(radius: showOverlayTime == 0 ? 3 : 0)
            .onChange(of: pageIndex) { newValue in
                showOverlayTime = 2
            }
            .onReceive(timer) { _ in
                if self.showOverlayTime > 0 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.showOverlayTime -= 1
                    }
                }
            }
    }
}
