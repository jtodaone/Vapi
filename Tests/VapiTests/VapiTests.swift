    import XCTest
    import XCTVapor
    @testable import Vapi
    
    struct TestResource: ContentResource {
        var test = "aaaa"
        
        static var controller = Controller {
            TestOperation(responseText: "aaaa")
        }
    }
    
    struct TestOperation: Vapi.Operation {
        var responseText = "yay"
        func register(at routes: RoutesBuilder) {
            routes.get { req in
                return req.eventLoop.makeSucceededFuture(responseText)
            }
        }
    }

    final class VapiTests: XCTestCase {
        func testExample() throws {
            let app = Application(.testing)
            defer {
                app.shutdown()
            }
            
            let testingController = Controller {
                Group {
                    TestOperation()
                }
                
                Group(path: "test") {
                    TestOperation()
                    
                    Group(path: "test2") {
                        TestOperation()
                    }
                }
            }
            
            try app.register(collection: testingController)
            
            try app.testable(method: .inMemory).test(.GET, "", afterResponse: { response in
                XCTAssertEqual(response.status, .ok)
                XCTAssertEqual(response.body.string, "yay")
            })
            
            try app.testable(method: .inMemory).test(.GET, "test", afterResponse: { response in
                XCTAssertEqual(response.status, .ok)
                XCTAssertEqual(response.body.string, "yay")
            })
            
            try app.testable(method: .inMemory).test(.GET, "test/test2", afterResponse: { response in
                XCTAssertEqual(response.status, .ok)
                XCTAssertEqual(response.body.string, "yay")
            })
    }
}
