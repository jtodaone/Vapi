import Vapor
import Fluent

protocol Resource: ResponseEncodable {
    static var controller: Controller { @ControllerBuilder get }
}
protocol ContentResource: Resource, Content {}
protocol DatabaseResource: ContentResource, Model {}

protocol Block {
    func register(at routes: RoutesBuilder)
}

extension Array: Block where Element == Block {
    func register(at routes: RoutesBuilder) {
        self.forEach { $0.register(at: routes) }
    }
}

protocol Operation: Block {}

struct Create<ModelType>: Operation where ModelType: DatabaseResource {
    func register(at routes: RoutesBuilder) {
        routes.post { request -> EventLoopFuture<ModelType> in
            let payload = try request.content.decode(ModelType.self)
            return payload.save(on: request.db).map { payload }
        }
    }
}

struct Controller: RouteCollection {
    var groups: [Block]
    
    init(groups: [Block]) {
        self.groups = groups
    }
    
    init(@GroupBuilder _ groups: () -> ([Block])) {
        self.groups = groups()
    }

    func boot(routes: RoutesBuilder) throws {
        groups.register(at: routes)
    }
}

