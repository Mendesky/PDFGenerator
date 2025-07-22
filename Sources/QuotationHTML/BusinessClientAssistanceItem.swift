import Plot

public struct BusinessClientAssistanceItem {
    let title: String
    let content: String
    
    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}


extension BusinessClientAssistanceItem {
    public struct Model {
        let title: String
        let content: String
        
        public init(title: String, content: String) {
            self.title = title
            self.content = content
        }
    }
}
