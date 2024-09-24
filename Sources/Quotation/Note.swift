//
//  Note.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//

import Plot

public struct Note: Component {
    let components: [Component]
    
    public init(components: [Component]) {
        self.components = components
    }
    
    public init(contents: [String]) {
        self.components = contents.map{ Text($0) }
    }
    
    public var body: any Component{
        ComponentGroup{
            Table{
                for (index,component) in components.enumerated(){
                    TableRow{
                        TableCell("註\(toChineseNumber(index: index))：").style("width: 3rem;vertical-align: top;")
                        TableCell(component)
                    }
                }
                
            }
        }
    }
}
