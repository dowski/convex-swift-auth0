// The Swift Programming Language
// https://docs.swift.org/swift-book

import ConvexMobile
import Auth0

public class Auth0Provider : AuthProvider {
  public init() {}
  public func login() async throws -> Auth0.Credentials {
    return try await Auth0.webAuth().start()
  }
  
  public func extractIdToken(authResult: Auth0.Credentials) -> String {
    return authResult.idToken
  }
  
  public typealias T = Credentials
  
  public func logout() async throws {
    try await Auth0.webAuth().clearSession()
  }
}
