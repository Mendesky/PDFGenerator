//
//  PDFToImage.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/27.
//

import PythonKit
import Foundation

@available(macOS 10.15, *)
public final class PDFImageConverter {
    private let format: String
    private let mode: String
    private let zoomX: Int
    private let zoomY: Int
    private let rotate: Int 

    public init(rotate: Int = 0, zoomX: Int = 4, zoomY: Int = 4, mode: String = "RGB", format: String = "PNG") {
        self.format = format
        self.mode = mode
        self.zoomX = zoomX
        self.zoomY = zoomY
        self.rotate = rotate
    }
    
    private func converPILImageToData(image: PythonObject) ->Data?{
        let io = Python.import("io")
        let fitz = Python.import("fitz")
        let PIL = Python.import("PIL")
        
        let imgBytesIO = io.BytesIO()
        image.save(imgBytesIO, format: format)
        
        guard let pyBytes: PythonBytes = PythonBytes(imgBytesIO.getvalue()) else {
            return nil
        }
        
        let bytes = pyBytes.withUnsafeBytes{ $0.map{ $0 }}
        return Data(bytes)
    }
    
    private func convertPageToPILImage(page: PythonObject) throws -> PythonObject{
        let PIL = Python.import("PIL")
        let fitz = Python.import("fitz")
        let Image = PIL.Image
        let matrix = fitz.Matrix(zoomX, zoomY).prerotate(rotate)
        let pixelMap  = page.get_pixmap(matrix: matrix, alpha: false)
        return Image.frombytes(mode: mode,
                                        size: [pixelMap.width, pixelMap.height],
                                        data: pixelMap.samples
        )
    }
    
    
    public func convert(pyBytes pdfBytes: PythonBytes) async throws -> [Data] {
        return try await MainActor.run {
            let fitz = Python.import("fitz")
            let document = fitz.open(stream: pdfBytes)
            return try document.map{ page in
                let image = try convertPageToPILImage(page: page)
                return converPILImageToData(image: image) ?? .init()
            }
        }
    }
    
    @available(macOS 13.0, *)
    public func convert(data pdfData: Data) throws -> [Data] {
        
        let pythonFilePath = Bundle.module.path(forResource: "pdf_to_image", ofType: "py")!
        
        let process = Process()
        let pipe = Pipe()
        let uuid = UUID().uuidString
        
        try pdfData.write(to: URL.init(filePath: "/tmp/\(uuid).pdf"))
        
        let environment = [
            "PATH": "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
        ]
        process.environment = environment
        process.launchPath = "/usr/bin/python3"
        process.arguments = [
            pythonFilePath,
            "--id=\(uuid)"
        ]
        
        process.standardOutput = pipe
        process.standardError = pipe
        
        
        try process.run()
        
        let data = try pipe.fileHandleForReading.readToEnd() ?? Data()
        print(String(data: data, encoding: .utf8))
        
        let pngPaths = try FileManager.default.contentsOfDirectory(atPath: "/tmp/\(uuid)")
        let datas = try (0..<pngPaths.count).map{ try Data.init(contentsOf: .init(filePath: "/tmp/\(uuid)/\($0).png")) }
        print(datas)
        return datas
    }
    
    @available(macOS 13.0, *)
    public func convert(url: URL) async throws -> [Data] {
        let pdfData = try Data.init(contentsOf: url)
        return try convert(data: pdfData)
    }

}

