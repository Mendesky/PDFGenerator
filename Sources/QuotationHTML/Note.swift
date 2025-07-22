//
//  Note.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//

import Plot

public struct Note: Component {
    let contents: [String]
    
    
    public init(models: [Model]){
        self.init(contents: models.map(\.content))
    }
    
    public init(contents: [String]) {
        self.contents = contents
    }
    
    public var body: any Component{
        ComponentGroup{
            Table{
                for (index, content) in contents.enumerated(){
                    TableRow{
                        TableCell("註\((index+1).representToChineseString())：").style("width: 5rem; vertical-align: top; font-size: 0.89rem;")
                        TableCell{
                            Div{
                                for string in content.split(separator: "\n"){
                                    Div(String(string)).style("font-size: 0.89rem;")
                                }
                            }
                        }
                    }.style("break-inside: avoid-page;")
                }
            }
        }
    }
}

extension Note {
    public struct Model {
        let content: String
        
        public init(content: String) {
            self.content = content
        }
    }
}
