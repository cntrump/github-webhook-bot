import Vapor

extension Environment {

    static var secret: Environment {
        .custom(name: "SECRET_TOKEN")
    }
}

// configures your application
public func configure(_ app: Application) throws {
    app.routes.defaultMaxBodySize = "512kb"

    // register routes
    try routes(app)
}
