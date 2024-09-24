//
//  Letter.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Plot
import Foundation

public struct LetterHeader: Component{
    let to: String
    let from: String
    let content: String
    let dateString: String
    let blessings: String
    
    public init(to: String, from: String, content: String, date: Date, blessings: String) {
        self.to = to
        self.from = from
        self.content = content
        self.blessings = blessings
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let taiwanYear = dateComponents.year.map{
            $0 - 1911
        }
        self.dateString = "\(taiwanYear!).\(dateComponents.month!).\(dateComponents.day!)"
    }
    
    public var body: Component {
        ComponentGroup{
            Table{
                TableRow{
                    TableCell("To").style("font-family: Times New Roman;")
                    TableCell(to)
                }
                TableRow{
                    TableCell("From").style("font-family: Times New Roman;")
                    TableCell(from)
                }
                TableRow{
                    TableCell{
                        Node.hr()
                        Text(content)
                    }.attribute(named: "colspan", value: "2")
                }
                TableRow{
                    TableCell{
                        Text("　　")
                        Text(blessings)
                    }.attribute(named: "colspan", value: "2")
                }
                
                TableRow{
                    TableCell{
                        Text(from)
                        Node.br()
                        Text(dateString)
                    }
                        .attribute(named: "colspan", value: "2")
                        .directionality(.rightToLeft)
                }
            }
        }
    }
}
