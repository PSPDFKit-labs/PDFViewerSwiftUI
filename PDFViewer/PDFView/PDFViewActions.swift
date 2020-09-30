//
//  PDFViewActions.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import Foundation
import SwiftUI
import PSPDFKit
import PSPDFKitUI

extension PDFView {

    enum ActionEvent {
        case showOutline(sender: AnyObject?)
    }

    static func execute(actionEvent: ActionEvent, controller: PDFViewController) {
        switch actionEvent {
        case .showOutline(let sender):
            _ = controller.outlineButtonItem.target?.perform(controller.outlineButtonItem.action!, with: sender)
        }
    }
}
