import Plot

public struct AdditionalService: Component{
    let name: String
    let isSeleted: Bool
    
    public init(name: String, isSeleted: Bool) {
        self.name = name
        self.isSeleted = isSeleted
    }
    
    public var body: any Component {
        ComponentGroup{
            Paragraph(name).style("text-indent: 2em;")
        }
    }
}