//
//  PdfGenerator.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//
import Foundation
import Logging

let logger = Logger(label: "PDFGenerator")

@available(macOS 10.15, *)
public class PDFGenerator {
    let mainHtml: String
    var headerHtml: String? = nil
    var footerHtml: String? = nil
    let baseUrl: String?
    let stylesheets:[String]
    
    private var pythonPath: String {
        guard let pythonPath = ProcessInfo.processInfo.environment["PYTHON_PATH"] else {
#if os(Linux)
            return "/usr/bin/python3"
#else
            return "/opt/homebrew/bin/python3"
#endif
        }
        return pythonPath
    }
    
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
    public init(mainHtml: String, headerHtml: String? = nil, footerHtml: String? = nil, stylesheets otherStylesheets:[String] = [], baseUrl: String? = nil){
        self.mainHtml = mainHtml
        self.headerHtml = headerHtml
        self.footerHtml = footerHtml
        self.baseUrl = baseUrl
        
        let fontFace: String
#if os(Linux)
        fontFace = """
            @font-face {
              font-family: 'CustomBoldFont';                
              src: url(file:///usr/local/share/fonts/特粗楷體.TTC) format('truetype')
            }        
            """
#else
        let fontPath = FileManager.default.homeDirectoryForCurrentUser.appending(path: "Library/Fonts/特粗楷體.TTC")
        fontFace = """
            @font-face {
              font-family: 'CustomBoldFont';                
              src: url(\(fontPath.absoluteString)) format('truetype')
            }        
            """
#endif
        self.stylesheets = [
            fontFace,
            """
            b { 
              font-family: 'CustomBoldFont', ser;
              font-weight: 900;
            }
            """,
            """
            .list-level-3 ol {
              list-style: none;
              /*  命名自訂標號變數  */
              counter-reset: list-index;
            }
            
            .list-level-3 ol li {
              /*  使用自訂標號  */
                counter-increment: list-index;
              /* 段落首行縮排 */
                text-indent: -1em;
            }
            
              /* 以偽元素自訂標號樣式 */
            .list-level-3 ol li::before {
              content: "("counter(list-index) ")";
              padding-right: 0.5em;
            }
            """
        ] + otherStylesheets
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
    public func generate(sideMargin: Float = 2, extraVerticalMargin:Float = 0) throws -> Data?{

        let pythonFilePath = Bundle.module.path(forResource: "pdf_generator", ofType: "py")!
        
        let process = Process()
        let pipe = Pipe()
        
        let uuid = UUID().uuidString
        let environment = [
            "PATH": "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
          ]
        process.environment = environment
        process.launchPath = pythonPath
        
        logger.info("PDFGenerator run on: \(process.launchPath ?? "")" )
        
        var arguments = [
            "\(pythonFilePath)",
            "--id=\(uuid)",
            "--main=\(mainHtml)",
            "--side_margin=\(Int(sideMargin))",
            "--extra_vertical_margin=\(Int(extraVerticalMargin))",
        ]
        
        if let headerHtml {
            arguments.append("--header=\(headerHtml)")
        }
        
        if let footerHtml {
            arguments.append("--footer=\(footerHtml)")
        }
        
        arguments.append(contentsOf: stylesheets.map{
            "--stylesheet=\($0)"
        })
        
        process.arguments = arguments
        process.standardOutput = pipe
        process.standardError = pipe
        
        try process.run()
        
        let terminalLog = try pipe.fileHandleForReading.readToEnd() ?? .init()
        logger.info("Python3 executing log: \(String(describing: String(data: terminalLog, encoding: .utf8)))")
        
        let outputPath = "/tmp/\(uuid).pdf"
        logger.info("PDF output: \(outputPath)")
        return try Data(contentsOf: .init(filePath: outputPath))
    }

}
