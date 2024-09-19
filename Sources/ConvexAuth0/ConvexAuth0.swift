// The Swift Programming Language
// https://docs.swift.org/swift-book

import Auth0
import ConvexMobile

private let SCOPES = "openid profile email offline_access"

public class Auth0Provider: AuthProvider {
  private let credentialsManager: CredentialsManager?

  public init(enableCachedLogins: Bool = false) {
    if enableCachedLogins {
      credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    } else {
      credentialsManager = nil
    }
  }

  public func login() async throws -> Credentials {
    let credentials = try await Auth0.webAuth().scope(SCOPES).start()
    _ = credentialsManager?.store(credentials: credentials)
    return credentials
  }

  public func loginFromCache() async throws -> Credentials {
    guard credentialsManager != nil else {
      fatalError("Can't call loginFromCache when not enabled")
    }
    return try await credentialsManager!.credentials()
  }

  public func extractIdToken(authResult: Credentials) -> String {
    return authResult.idToken
  }

  public typealias T = Credentials

  public func logout() async throws {
    try await Auth0.webAuth().clearSession()
    await credentialsManager?.clear()
  }
}
