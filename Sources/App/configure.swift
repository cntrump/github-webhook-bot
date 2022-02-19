import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.routes.defaultMaxBodySize = "512kb"

    // register routes
    try routes(app)
}
