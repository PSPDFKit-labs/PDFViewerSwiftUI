//
//  BarButtonWatcher.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import Foundation
import UIKit
import InterposeKit

final class BarButtonWatcher {
    static let shared = BarButtonWatcher()

    static private(set) weak var lastBarButtonItem: UIBarButtonItem? {
        didSet {
            // reset in next runloop
            if lastBarButtonItem != nil {
                DispatchQueue.main.async { self.lastBarButtonItem = nil }
            }
        }
    }

    init() {
        _ = try? UIApplication.shared.hook(#selector(UIApplication.sendAction(_:to:from:for:)),
        methodSignature: (@convention(c) (AnyObject, Selector, Selector, Any?, Any?, UIEvent?) -> Bool).self,
        hookSignature: (@convention(block) (AnyObject, Selector, Any?, Any?, UIEvent?) -> Bool).self) {
        store in { _self, action, target, sender, event in
            if let barButtonItem = sender as? UIBarButtonItem {
                BarButtonWatcher.lastBarButtonItem = barButtonItem
            }
            return store.original(_self, store.selector, action, target, sender, event)
            }
        }
    }
}
