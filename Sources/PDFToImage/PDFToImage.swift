//
//  PDFToImage.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/27.
//

import PythonKit
import Foundation

let io = Python.import("io")
let fitz = Python.import("fitz")
let PIL = Python.import("PIL")

let Image = PIL.Image
let Document = fitz.Document

public final class PDFImageConverter {
    private let format: String
    private let mode: String
    private let matrix: PythonObject

    public init(rotate: Int = 0, zoomX: Int = 4, zoomY: Int = 4, mode: String = "RGB", format: String = "PNG") {
        self.format = format
        self.mode = mode
        self.matrix = fitz.Matrix(zoomX, zoomY).prerotate(rotate)
    }
    
    private func converPILImageToData(image: PythonObject)->Data?{
        let imgBytesIO = io.BytesIO()
        image.save(imgBytesIO, format: format)
        
        guard let pyBytes: PythonBytes = PythonBytes(imgBytesIO.getvalue()) else {
            return nil
        }
        
        let bytes = pyBytes.withUnsafeBytes{ $0.map{ $0 }}
        return Data(bytes)
    }
    
    private func convertPageToPILImage(page: PythonObject) throws -> PythonObject{
        let pixelMap  = page.get_pixmap(matrix: matrix, alpha: false)
        return Image.frombytes(mode: mode,
                                        size: [pixelMap.width, pixelMap.height],
                                        data: pixelMap.samples
        )
    }
    
    
    public func convert(pyBytes pdfBytes: PythonBytes) throws -> [Data] {
        let document = fitz.open(stream: pdfBytes)
        return try document.map{ page in
            let image = try convertPageToPILImage(page: page)
            return converPILImageToData(image: image) ?? .init()
        }
    }
    
    public func convert(data pdfData: Data) throws -> [Data] {
        let pyBytes = PythonBytes(pdfData.map{ $0 })
        return try convert(pyBytes: pyBytes)
    }
    
    public func convert(url: URL) throws -> [Data] {
        let pdfData = try Data.init(contentsOf: url)
        return try convert(data: pdfData)
    }

}

