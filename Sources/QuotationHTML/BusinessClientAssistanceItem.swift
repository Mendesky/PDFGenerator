import Plot

public struct BusinessClientAssistanceItem: Component {
    let title: String
    let content: String
    
    public var body: any Component{
        ComponentGroup{
            Paragraph(title)
            Paragraph(content).style("text-indent: 2em;")
        }
    }
    
    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}