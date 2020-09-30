//
//  PDFViewControllerExtensions.swift
//  PDFViewer
//
//  Created by Peter Steinberger on 27.09.20.
//

import Foundation
import Combine
import PSPDFKit
import PSPDFKitUI

func setupLicense() {
    #if targetEnvironment(macCatalyst)
    // Activate PSPDFKit for com.steipete.PDFViewer
    SDK.setLicenseKey("Vz05RE5y41+ihwqw0b/CWOtuUewY36mK6/qM/Rn6e3to5ikog3f13k4KHWs16kPPhYQ+txWMejVQaO4UQ+eB31ubJGTuffLIlzmtBJcEUeJfR/i75KGlZflRz2TNVrgt58CdOMudmZJjiGAT/dVuComzq4vDdH9zRFCSLlI3e+QZz9fZjyyar12RnWnhwfs9uls3kLRONGW3KFHVZLBSp0V94lTTQhb9rTtGAWtvwtZkJ3O8SlZ+o+Bvl3MkHziX66r40OqBDrADs8Iqz68jr79SwICC0JxO3Num3GOlUaxtqwceM1NCP8sN1sllO29wRfMYLzU4bObqe5MtsOyjHvk9WJ4dFOla+D0ciT9mLPIqVCA94K1kRfCqAXWy+UPhvvPa4AdvcWw+FAk12+WoSRES/49zGSHz8zaq3OePmv+aHHsxg3xWB7AzH16TAEeygSlHoJOZnIlhREPAmC2Y7zsNcF+LV0hP3ks8Ca3aFrGvzwJ4SXHytHybgTuIUe8qgaBx2Dz/WkABCk1v8abGMVy+6V0jEmFhrDt/cr2sho5OXj/Or5lrOvaDHpjIXR2CQPzkodrVukS3DE/7xhhoTes0CszpnGJjxtL5t8tnP06eQw+zMEYCiQiu/umtUAEWHkOSGjKiPAffmViWD454K5nSaIRXdRO3d/sOIDSMvh2KytomscNSKDhzbG+HJnuwCbfky/SY4blCG3khY4zuY3ScZGZtVQwvCnMiPYYhTIEtF2LS+6dztB1sxEOFoLzZ7ewomS11ifxRCP2sc6rd9d6nhRXFY9GYZa6RGCL4vfg=")
    #else
    // Activate PSPDFKit for iOS demo license key for com.steipete.PDFViewer until 31 Dec 2020
    SDK.setLicenseKey(
        "GL+yFH4O3yz85Aj8+411B5GEfPNbq5ybCfCctVUUAylfvpKpWDozApBPMBIKpi/qTNgSs8NvmIJNNqXLv1xFPpl9RZKdhD0Md9CbRfxoHSrpKxFczFwXtNbVVk++dRRsi9rjT+MmzDFT62N9RO60htQsMSUT7CQf+3E0Lha8RVE4U2zuYeFesiJJ7ClnZ9UCijmztHvFZbkw2+zAl3BzabXFXcMl+uz/XYXqHa/IIYhzQoW1U6VWVp6PkON0toRarqtRxgPYTibJX3P/GV1hhFlWW2MZm9PVrlHeRosGM4vyMLHp/XleAEw9ajs1oryFZsyIL5al+wipQhJ9cW60UVB8fSkaHWMt/XWDKsAArLR78cOXWtPS5JA4TSGnbDrcfyn4FfThVGbKrKpzkXth4uI8rtcqGhQdyYOlLH72Cwb583vDbS9A8P0+b86iE1WCtjJRV8xrHr5cu1JuZ97EKP2IeeNMKTW9eEMVgk2RfMC21fz/E1zbv1SZREMggI30qnCcy9ictU5TFGEaUduTLxGC/TUQIV1zxkDNa38xctDYZmvbvaSYikniAUZzv6MytKPFtHVSDSUjIEb7lp4BOXXwOG+Q51XtGAWSjXHXJE4LWdR9E9X5djTa9zy3F2WHxcyQb5KPXYjO5ETV1QNKOuEsYyAk2djGiU6KRD9B4qP9ccOc1fXuS2sBKaZxvHg0zYQPwusVnQbAkc9jtJKGbwR2hpTh+6Df/eDU7TMxH9oWwWFaoeqxyVZk9CY/UO+mKtzYx87JVeZh9XbDc1VrCJlx58dfyobXXL8cIFwVVQfXOsUGaA+PUd2nd8pYNo6KIlWGqkT7IchdIrYN55xw1JWQhgKw9wanyhO+H/7eh7vjUk4LRiVmp2j8HrkVvdMvpCC51zgk0/PRLpSndIsQAhj2C7jyHyyedvhPmdPQbk0=")
    #endif
}

public extension PDFViewController {
    /// A publisher that fires whenever the `pageIndex` changes. (Simplified)
    var pageIndexPublisher: AnyPublisher<PageIndex, Never> {
        NotificationCenter.default.publisher(for: .PSPDFDocumentViewControllerSpreadIndexDidChange,
                                             object: documentViewController)
            .compactMap { notification in
                let documentViewController = notification.object as! PDFDocumentViewController
                guard documentViewController == self.documentViewController,
                      let spreadIndex = notification.userInfo!["PSPDFDocumentViewControllerSpreadIndexKey"] as? Int
                else { return nil }

                return PageIndex(documentViewController.layout.pageRangeForSpread(at: spreadIndex).location)
            }.eraseToAnyPublisher()
    }
}

public extension Document {
    /// Convenience initializer that takes data and checks it for validity.
    convenience init(data: Data) {
        self.init(dataProviders: [DataContainerProvider(data: data)])
    }

    /// Change event to indicate addition, removal or change events.
    enum AnnotationChangeEvent {
        case added(anntations: [Annotation])
        case removed(anntations: [Annotation])
        case changed(anntations: [Annotation])
    }

    /// Fires with an `AnnotationChangeEvent` whenever an annotation is added, removed or changed.
    var annotationChangePublisher: AnyPublisher<AnnotationChangeEvent, Never> {
        let filtered = { [weak self] (annotations: [Annotation]) -> [Annotation] in
            guard let self = self else { return [] }
            return annotations.filter { $0.document === self }
        }
        let addedPublisher = NotificationCenter.default.publisher(for: .PSPDFAnnotationsAdded, object: nil)
            .map { filtered($0.object as! [Annotation]) }
            .filter { !$0.isEmpty }
            .map { AnnotationChangeEvent.added(anntations: $0) }
        let removedPublisher = NotificationCenter.default.publisher(for: .PSPDFAnnotationsRemoved, object: nil)
            .map { filtered($0.object as! [Annotation]) }
            .filter { !$0.isEmpty }
            .map { AnnotationChangeEvent.removed(anntations: $0) }
        let changedPublisher = NotificationCenter.default.publisher(for: .PSPDFAnnotationChanged, object: nil)
            .map { filtered([$0.object as! Annotation]) }
            .filter { !$0.isEmpty }
            .map { AnnotationChangeEvent.changed(anntations: $0) }

        return Publishers.MergeMany(addedPublisher, removedPublisher, changedPublisher).eraseToAnyPublisher()
    }
}
