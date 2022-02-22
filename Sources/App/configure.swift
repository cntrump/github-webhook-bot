import Vapor
import NIOSSL

extension Environment {

    static var secret: Environment {
        .custom(name: "SECRET_TOKEN")
    }

    /// Path of `fullchain.pem`
    static var cert_fullchain: Environment {
        .custom(name: "CERT_FULLCHAIN")
    }

    /// Path of `privkey.pem`
    static var cert_privkey: Environment {
        .custom(name: "CERT_PRIVKEY")
    }

    /// Certificate subject name
    static var cert_host: Environment {
        .custom(name: "CERT_HOST")
    }
}

// configures your application
public func configure(_ app: Application) throws {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    ContentConfiguration.global.use(decoder: decoder, for: .json)

    app.routes.defaultMaxBodySize = "512kb"

    if let fullchain = Environment.get(Environment.cert_fullchain.name),
       let privkey = Environment.get(Environment.cert_privkey.name),
       FileManager.default.fileExists(atPath: fullchain),
       FileManager.default.fileExists(atPath: privkey) {
        let certChain = try NIOSSLCertificate.fromPEMFile(fullchain).map { NIOSSLCertificateSource.certificate($0) }
        let tlsConfig = TLSConfiguration.makeServerConfiguration(certificateChain: certChain, privateKey: .file(privkey))
        app.http.server.configuration = HTTPServer.Configuration(
            responseCompression: .enabled,
            requestDecompression: .enabled(limit: .size(1024)),
            supportVersions: Set<HTTPVersionMajor>([ .one, .two ]),
            tlsConfiguration: tlsConfig,
            serverName: Environment.get(Environment.cert_host.name)
        )
    }

    app.middleware.use(GitHubMiddleware())

    // register routes
    try routes(app)
}
