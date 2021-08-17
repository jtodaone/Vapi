import Vapor

struct Group: Block {
    var path: [PathComponent]
    var middleware: [Middleware]
    var blocks: [Block]
    
    init(path: PathComponent..., middleware: Middleware..., @GroupBuilder builder: () -> [Block]) {
        self.path = path
        self.middleware = middleware
        self.blocks = builder()
    }
    
    func register(at routes: RoutesBuilder) {
        let newRoutes = routes.grouped(path).grouped(middleware)
        blocks.register(at: newRoutes)
    }
}

@resultBuilder
enum GroupBuilder {
    static func buildBlock(_ components: Block...) -> [Block] {
        return components
    }
}


