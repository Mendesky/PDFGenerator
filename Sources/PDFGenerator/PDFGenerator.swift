//
//  PdfGenerator.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//
import PythonKit
import Foundation

let weasyprint = Python.import("weasyprint")

let OVERLAY_LAYOUT = "@page {size: A4 portrait; margin: 0;}"

public class PDFGenerator {
    let mainHtml: String
    var headerHtml: PythonObject? = nil
    var footerHtml: PythonObject? = nil
    let baseUrl: String?
    let sideMargin: PythonObject
    let extraVerticalMargin: PythonObject
    
    public init(mainHtml: String, headerHtml: String? = nil, footerHtml: String? = nil, baseUrl: String? = nil, sideMargin: Int = 2, extraVerticalMargin:Int = 30){
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
        self.sideMargin = .init(sideMargin)
        self.extraVerticalMargin = .init(extraVerticalMargin)
        
    }
    
    
//            """
//            Parameters
//            ----------
//            element: str
//                Either 'header' or 'footer'
//
//            Returns
//            -------
//            element_body: BlockBox
//                A Weasyprint pre-rendered representation of an html element
//            element_height: float
//                The height of this element, which will be then translated in a html height
//            """
    private func computeOverlayElement(html: PythonObject, element: String)->(elementBody: PythonObject, elementHeight: PythonObject)?{
        let elementDoc = html.render(stylesheets: [weasyprint.CSS(string: OVERLAY_LAYOUT)])
        let elementPage = elementDoc.pages[0]
        
        guard var elementBody = Self.getElement(boxes: elementPage._page_box.all_children(), element: "body") else {
            return nil
        }
        elementBody = elementBody.copy_with_children(elementBody.all_children())
        
        guard let elementHtml = Self.getElement(boxes: elementPage._page_box.all_children(), element: PythonObject(element)) else {
            return nil
        }
        
        let elementHeight = if element == "header"{
            elementHtml.height
        }else {
            elementPage.height - elementHtml.position_y
        }
            
        return (elementBody: elementBody, elementHeight: elementHeight)
    }
        
        
    static func getElement(boxes: PythonObject, element: PythonObject)->PythonObject?{
//                """
//                Given a set of boxes representing the elements of a PDF page in a DOM-like way, find the
//                box which is named `element`.
//
//                Look at the notes of the class for more details on Weasyprint insides.
//                """
        for box in boxes{
            if box.element_tag == element{
                return box
            }
            return Self.getElement(boxes: box.all_children(), element: element)
        }
        
        return nil
    }
        
        
    private func applyOverlayOnMain(mainDoc: PythonObject, headerBody: PythonObject? = nil, footerBody: PythonObject? = nil){
//        """
//        Insert the header and the footer in the main document.
//
//        Parameters
//        ----------
//        main_doc: Document
//            The top level representation for a PDF page in Weasyprint.
//        header_body: BlockBox
//            A representation for an html element in Weasyprint.
//        footer_body: BlockBox
//            A representation for an html element in Weasyprint.
//        """
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
    
    public func render()->Data?{
//        """
//        Returns
//        -------
//        pdf: a bytes sequence
//            The rendered PDF.
//        """
        var headerBody: PythonObject?
        var headerHeight: PythonObject
        
        var footerBody: PythonObject?
        var footerHeight: PythonObject
        
        if let headerHtml{
            (headerBody, headerHeight) = self.computeOverlayElement(html: headerHtml, element: "header")!
        }else{
            (headerBody, headerHeight) = (nil, 0)
        }
        
        if let footerHtml{
            (footerBody, footerHeight) = self.computeOverlayElement(html: footerHtml, element: "footer")!
        }else{
            (footerBody, footerHeight) = (nil, 0)
        }
            
        let margins = "\(headerHeight + extraVerticalMargin)px \(footerHeight + extraVerticalMargin)px \(sideMargin)cm"
        
        let contentPrintLayout = "@page {size: A4 portrait; margin: \(margins);}"
        
        let html = weasyprint.HTML(
            string: mainHtml,
            base_url: baseUrl
        )
        
        let mainDoc = html.render(stylesheets: [weasyprint.CSS(string: contentPrintLayout)])
        
        
        applyOverlayOnMain(mainDoc: mainDoc, headerBody: headerBody, footerBody: footerBody)
        let pdfData: PythonBytes? = PythonBytes(mainDoc.write_pdf())
        guard let bytes = pdfData?.withUnsafeBytes({ pointer in
            pointer.map{ $0 }
        }) else {
            return nil
        }
        
        return Data(bytes)
    }
}
