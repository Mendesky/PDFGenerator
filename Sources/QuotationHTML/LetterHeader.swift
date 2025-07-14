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
    let quotingOrganization: Organization
    let content: String
    let dateString: String
    let blessings: String
    
    var toLines: [String] {
        to.split(separator: "\n").map{ String($0) }
    }
    
    var fromLines: [String] {
        from.split(separator: "\n").map{ String($0) }
    }
    
    public init(to: String, from: String, quotingOrganization: Organization, content: String, date: Date, blessings: String) {
        self.to = to
        self.from = from
        self.content = content
        self.blessings = blessings
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let taiwanYear = dateComponents.year.map{
            $0 - 1911
        }
        self.dateString = "\(taiwanYear!).\(dateComponents.month!).\(dateComponents.day!)"
        self.quotingOrganization = quotingOrganization
    }
    
    public var body: Component {
        ComponentGroup{
            Div{
                Table{
                    TableRow{
                        TableCell("To").style("font-family: Times New Roman;width: 5rem; font-size: 1.1rem; vertical-align: top;")
                        TableCell{
                            for line in toLines {
                                Div(line)
                            }
                        }.style("text-align: left; font-size: 1.1rem;")
                    }.style("height: 3rem;")
                    TableRow{
                        TableCell()
                            .style("height: 1rem;")
                            .attribute(named: "colspan", value: "2")
                    }
                    TableRow{
                        TableCell("From").style("font-family: Times New Roman; font-size: 1.1rem; vertical-align: top;")
                        TableCell{
                            for line in fromLines {
                                Div(line)
                            }
                        }.style("text-align: left; font-size: 1.1rem;")
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
                        Text(quotingOrganization.displayName)
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
