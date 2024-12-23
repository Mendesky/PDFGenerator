//
//  PdfGenerator.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//
import PythonKit
import Foundation

@available(macOS 10.15, *)
public class PDFGenerator {
    let mainHtml: String
    var headerHtml: String? = nil
    var footerHtml: String? = nil
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
        self.headerHtml = headerHtml
        self.footerHtml = footerHtml
        self.baseUrl = baseUrl
    }
    
    
    func render(html: PythonObject, stylesheets: PythonObject...)->PythonObject{
        return html.render(stylesheets: stylesheets)
    }
    /// Generate  the Data of PDF File
    /// - Parameters:
    ///   - sideMargin: `Int` interpreted in cm, by default 2cm.
    ///   The margin to apply on the core of the rendered PDF (i.e. main_html).
    ///   - extraVerticalMargin: `Int` interpreted in pixel, by default 30 pixels.
    ///   An extra margin to apply between the main content and header and the footer.
    ///   The goal is to avoid having the content of `main_html` touching the header or the footer.
    /// - Returns: The rendered data of PDF.
    @available(macOS 13.0, *)
    public func generate(sideMargin: Float = 2, extraVerticalMargin:Float = 30) throws -> Data?{
        
        let bundles = Bundle.allBundles
        

        let pythonFilePath = Bundle.module.path(forResource: "pdf_generator", ofType: "py")!
        
        let process = Process()
        let pipe = Pipe()
        
        let uuid = UUID().uuidString
        let environment = [
            "PATH": "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
          ]
        process.environment = environment
        process.launchPath = "/opt/homebrew/bin/python3"
//        process.arguments = [
//            "\(pythonFilePath) --main='\(mainHtmlPath)' --header='\(headerHtmlPath)' --footer='\(footerHtmlPath)' --side_margin=\(Int(sideMargin)) --extra_vertical_margin=\(Int(extraVerticalMargin))",
//        ]
        
        var arguments = [
            "\(pythonFilePath)",
            "--id=\(uuid)",
            "--main=\(mainHtml)",
            "--side_margin=\(Int(sideMargin))",
            "--extra_vertical_margin=\(Int(extraVerticalMargin))"
        ]
        if let headerHtml {
            arguments.append("--header=\(headerHtml)")
        }
        
        if let footerHtml {
            arguments.append("--footer=\(footerHtml)")
        }
        process.arguments = arguments
        process.standardOutput = pipe
        process.standardError = pipe
        
//        print(command)
        try process.run()
        
        let terminal = try pipe.fileHandleForReading.readToEnd()
        print(String(data: terminal!, encoding: .utf8))
        
        print("/tmp/\(uuid).pdf")
        return try Data(contentsOf: .init(filePath: "/tmp/\(uuid).pdf"))
//        guard let pdfPath = String(data: data, encoding: .utf8) else{
//            return nil
//        }
//        
//        return try Data(contentsOf: URL(fileURLWithPath: pdfPath))
    }

}
