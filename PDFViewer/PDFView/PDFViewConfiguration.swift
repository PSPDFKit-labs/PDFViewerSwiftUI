//
//  PDFViewConfiguration.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 30.09.20.
//

import UIKit
import SwiftUI
import PSPDFKitUI

extension PDFView {
    private func config(_ config: @escaping ((PDFConfigurationBuilder) -> Void)) -> Self {
        then({ $0.configurationModifiers.append(config) })
    }

    /// Update arbitrary configuration properties via a `PDFConfigurationBuilder` closure.
    public func updateConfiguration(builder builderBlock: @escaping (PDFConfigurationBuilder) -> Void) -> Self {
        config({ builderBlock($0) })
    }

    /// Defines the page transition. Defaults to `.scrollPerSpread`.
    public func pageTransition(_ pageTransition: PageTransition) -> Self {
        config({ $0.pageTransition = pageTransition })
    }

    /// Page scrolling direction. Defaults to `.horizontal`. Only relevant for scrolling page transitions.
    public func scrollDirection(_ scrollDirection: ScrollDirection) -> Self {
        config({ $0.scrollDirection = scrollDirection })
    }

    /// Background color behind the page view.
    public func backgroundColor(_ backgroundColor: UIColor) -> Self {
        config({ $0.backgroundColor = backgroundColor })
    }
}


extension View {
    /// Helper to simplify the copy, mutate and return pattern.
    public func then(_ body: (inout Self) -> Void) -> Self {
        var result = self
        body(&result)
        return result
    }
}
