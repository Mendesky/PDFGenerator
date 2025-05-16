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
    let from: Organization
    let content: String
    let dateString: String
    let blessings: String
    
    public init(to: String, from: String, content: String, date: Date, blessings: String) {
        self.to = to
        self.from = Organization(rawValue: from)
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
            Div{
                Table{
                    TableRow{
                        TableCell("To").style("font-family: Times New Roman;width: 5rem; font-size: 1.1rem;")
                        TableCell(to).style("text-align: left; font-size: 1.1rem;")
                    }.style("height: 3rem;")
                    TableRow{
                        TableCell("From").style("font-family: Times New Roman; font-size: 1.1rem;")
                        TableCell(from.displayName).style("text-align: left; font-size: 1.1rem;")
                    }.style("height: 3rem;")
                }
            }.style("width: 100%;padding: 25px 25px 40px 25px;")
            Table{
                TableRow{
                    TableCell{
                        Node.hr()
                        Paragraph(content).style("text-indent: 2em;")
                    }.attribute(named: "colspan", value: "2")
                }
                TableRow{
                    TableCell(blessings)
                        .style("text-indent: 2em;")
                        .attribute(named: "colspan", value: "2")
                }
                
                TableRow{
                    TableCell{
                        Text(from.displayName)
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
