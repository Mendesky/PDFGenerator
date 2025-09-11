//
//  PDFToImage.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/27.
//

import Foundation
import Logging

let logger = Logger(label: "PDFToImage")

@available(macOS 10.15, *)
public final class PDFImageConverter {
    private let format: String
    private let mode: String
    private let zoomX: Int
    private let zoomY: Int
    private let rotate: Int 

    
    private var pythonPath: String {
        guard let pythonPath = ProcessInfo.processInfo.environment["PYTHON_PATH"] else {
            return "/usr/bin/python3"
        }
        return pythonPath
    }
    
    public init(rotate: Int = 0, zoomX: Int = 4, zoomY: Int = 4, mode: String = "RGB", format: String = "PNG") {
        self.format = format
        self.mode = mode
        self.zoomX = zoomX
        self.zoomY = zoomY
        self.rotate = rotate
    }
    
    @available(macOS 13.0, *)
    public func convert(data pdfData: Data) throws -> [Data] {
        
        let pythonFilePath = Bundle.module.path(forResource: "pdf_to_image", ofType: "py")!
        
        let process = Process()
        let pipe = Pipe()
        let uuid = UUID().uuidString
        
        try pdfData.write(to: URL.init(filePath: "/tmp/\(uuid).pdf"))
        
        let environment = [
            "PATH": ":/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
        ]
        process.environment = environment
        process.launchPath = pythonPath
        
        logger.info("PDFImageConverter run on: \(process.launchPath ?? "")" )
        
        process.arguments = [
            pythonFilePath,
            "--id=\(uuid)"
        ]
        
        process.standardOutput = pipe
        process.standardError = pipe
        
        
        try process.run()
        
        let terminalLog = try pipe.fileHandleForReading.readToEnd() ?? .init()
        logger.info("Python3 executing log: \(String(describing: String(data: terminalLog, encoding: .utf8)))")
        
        let pngPaths = try FileManager.default.contentsOfDirectory(atPath: "/tmp/\(uuid)")
        return try (0..<pngPaths.count).map{ try Data.init(contentsOf: .init(filePath: "/tmp/\(uuid)/\($0).png")) }
    }
    
    @available(macOS 13.0, *)
    public func convert(url: URL) async throws -> [Data] {
        let pdfData = try Data.init(contentsOf: url)
        return try convert(data: pdfData)
    }

}

