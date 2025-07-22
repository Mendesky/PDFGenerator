import Plot

public struct AdditionalService: Component{
    let name: String
    let isSelected: Bool
    
    public init(name: String, isSelected: Bool) {
        self.name = name
        self.isSelected = isSelected
    }
    
    public var body: any Component {
        ComponentGroup{
            Paragraph(name).style("text-indent: 2em;")
        }
    }
}

extension AdditionalService {
    public struct Model {
        let name: String
        let isSelected: Bool
        
        public init(name: String, isSelected: Bool) {
            self.name = name
            self.isSelected = isSelected
        }
    }
}
