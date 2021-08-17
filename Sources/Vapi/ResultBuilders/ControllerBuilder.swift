@resultBuilder
enum ControllerBuilder {
    static func buildBlock(_ components: Block...) -> Controller {
        return Controller(groups: components)
    }
}
