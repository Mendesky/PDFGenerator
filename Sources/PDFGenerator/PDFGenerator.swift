//
//  PdfGenerator.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//
import PythonKit
import Foundation

let OVERLAY_LAYOUT = "@page {size: A4 portrait; margin: 0;}"

public class PDFGenerator {
    private let weasyprint = Python.import("weasyprint")

    let mainHtml: String
    var headerHtml: PythonObject? = nil
    var footerHtml: PythonObject? = nil
    let baseUrl: String?
    
    /// PDFGenerator
    /// - Parameters:
    ///   - mainHtml: `String`,
    ///   An HTML file (most of the time a template rendered into a string) which represents the core of the PDF to generate.
    ///   - headerHtml: `String?`,
    ///   An optional header html.
    ///   - footerHtml: `String?`,
    ///   An optional footer html.
    ///   - baseUrl: `String?`
    ///     An absolute url to the page which serves as a reference to Weasyprint to fetch assets, required to get our media.
    public init(mainHtml: String, headerHtml: String? = nil, footerHtml: String? = nil, baseUrl: String? = nil){
        
        self.mainHtml = mainHtml
        
        if let headerHtml{
            self.headerHtml = weasyprint.HTML(
                string: headerHtml,
                base_url: baseUrl
            )
        }
        
        if let footerHtml{
            self.footerHtml = weasyprint.HTML(
                string: footerHtml,
                base_url: baseUrl
            )
        }
        
        self.baseUrl = baseUrl
    }
    
    
    /// Precomute the height of overlay element
    /// - Parameters:
    ///   - html: `HTML`, Either 'headerHtml' or 'footer Html'
    ///   - element: `String`,  Either 'header' or 'footer'
    /// - Returns:
    /// element_body: BlockBox
    ///     A Weasyprint pre-rendered representation of an html element
    /// element_height: float
    ///     The height of this element, which will be then translated in a html height
    private func computeOverlayElement(overlayHtml: PythonObject, element: String)->(elementBody: PythonObject?, elementHeight: Float)?{
        let elementDoc = overlayHtml.render(stylesheets: [weasyprint.CSS(string: OVERLAY_LAYOUT)])
        let elementPage = elementDoc.pages[0]
        
        guard var elementBody = Self.getElement(boxes: elementPage._page_box.all_children(), element: "body") else {
            return nil
        }
        elementBody = elementBody.copy_with_children(elementBody.all_children())
        
        guard let elementHtml = Self.getElement(boxes: elementPage._page_box.all_children(), element: element) else {
            return nil
        }
        
        let elementHeight = if element == "header" { elementHtml.height }
        else { elementPage.height - elementHtml.position_y }
            
        return (elementBody: elementBody, elementHeight: Float(elementHeight) ?? 0)
    }
        
    
    /// Given a set of boxes representing the elements of a PDF page in a DOM-like way, find the box which is named `element`.
    /// - Parameters:
    ///   - boxes: [BlockBox]
    ///   - element: [String]
    /// - Returns: [Element]
    static func getElement(boxes: PythonObject, element: String)->PythonObject?{
        for box in boxes{
            if let foundedBox = (boxes.first{ $0.element_tag == PythonObject(element)}){
                return foundedBox
            }
            return getElement(boxes: box.all_children(), element: element)
        }
        return nil
    }
        
    
    /// Insert the header and the footer in the main document.
    /// - Parameters:
    ///   - mainDoc: `Document` The top level representation for a PDF page in Weasyprint.
    ///   - headerBody: `BlockBox` A representation for an html element in Weasyprint.
    ///   - footerBody: `BlockBox` A representation for an html element in Weasyprint.
    private func applyOverlayOnMain(mainDoc: PythonObject, headerBody: PythonObject? = nil, footerBody: PythonObject? = nil){
        for page in mainDoc.pages{
            if let pageBody = Self.getElement(boxes: page._page_box.all_children(), element: "body"){
                if let headerBody {
                    pageBody.children += headerBody.all_children()
                }
                if let footerBody{
                    pageBody.children += footerBody.all_children()
                }
            }
        }
                
    }
    
    /// Generate  the Data of PDF File
    /// - Parameters:
    ///   - sideMargin: `Int` interpreted in cm, by default 2cm.
    ///   The margin to apply on the core of the rendered PDF (i.e. main_html).
    ///   - extraVerticalMargin: `Int` interpreted in pixel, by default 30 pixels.
    ///   An extra margin to apply between the main content and header and the footer.
    ///   The goal is to avoid having the content of `main_html` touching the header or the footer.
    /// - Returns: The rendered data of PDF.
    public func generate(sideMargin: Float = 2, extraVerticalMargin:Float = 30) -> Data?{
        
        var headerBody: PythonObject?
        var headerHeight: Float = 0
        
        var footerBody: PythonObject?
        var footerHeight: Float = 0
        
        if let headerHtml, let headerResult = self.computeOverlayElement(overlayHtml: headerHtml, element: "header"){
            headerBody = headerResult.elementBody
            headerHeight = headerResult.elementHeight
        }
        
        if let footerHtml, let footerResult = self.computeOverlayElement(overlayHtml: footerHtml, element: "footer"){
            footerBody = footerResult.elementBody
            footerHeight = footerResult.elementHeight
        }
        
        let margins = "\(headerHeight + extraVerticalMargin)px \(sideMargin)cm \(footerHeight + extraVerticalMargin)px \(sideMargin)cm"
        
        let contentPrintLayout = "@page {size: A4 portrait; margin: \(margins);}"
        
        let html = weasyprint.HTML(
            string: mainHtml,
            base_url: baseUrl
        )
        
        let mainDoc = html.render(stylesheets: [weasyprint.CSS(string: contentPrintLayout)])
        
        
        applyOverlayOnMain(mainDoc: mainDoc, headerBody: headerBody, footerBody: footerBody)
        
        guard let pyData: PythonBytes = PythonBytes(mainDoc.write_pdf()) else {
            return nil
        }
        
        let bytes = pyData.withUnsafeBytes{ $0.map{ $0 }}
        return Data(bytes)
    }

}
