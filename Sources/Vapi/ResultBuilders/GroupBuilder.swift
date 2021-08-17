@resultBuilder
enum GroupBuilder {
    static func buildBlock(_ components: Block...) -> [Block] {
        return components
    }
}
