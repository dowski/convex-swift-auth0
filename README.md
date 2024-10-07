# Convex Swift - Auth0 Integration

This library works with the core
[Convex Swift](https://github.com/get-convex/convex-swift)
library and provides support for using Auth0 in `ConvexClientWithAuth`.

The integration uses Auth0's
[Universal Login](https://auth0.com/docs/hosted-pages/login). Users are
prompted to authenticate via a browser window and then seamlessly returned to
your app UI.

## Getting Started

First of all, if you haven't started a Convex application yet, head over to the
[Convex Swift quickstart](https://docs.convex.dev/quickstart/swift) to get the 
basics down. It will get you up and running with a Convex dev deployment and a
basic Swift application that communicates with it.

Once you have a working Convex + Swift application, you're ready to take the
following steps to integrate with Auth0.

> [!NOTE]
> There are a lot of moving parts to getting auth set up. If you run into trouble
> check out the [Convex auth docs](https://docs.convex.dev/auth) and join our 
> [Discord community](https://convex.dev/community) to get help.

1. Follow the first three steps of the official
   [Auth0 iOS quickstart](https://auth0.com/docs/quickstart/native/ios-swift)
   ("Configure Auth0", "Install the SDK" and "Configure the SDK").

2. Update your Convex application to support auth. Create a `convex/auth.config.ts`
   file with the following content:
    ```
    export default {
      providers: [
        {
          domain: "your-domain.us.auth0.com",
          applicationID: "yourclientid",
        },
      ]
    };
    ```
3. Run `npx convex dev` to sync the config change.

4. Add a dependency on this library to your Xcode project.

5. Then, wherever you have setup your Convex client with `ConvexClient`, switch to using
   `ConvexClientWithAuth` and pass `Auth0Provider` you created.

    ```swift
    let client = ConvexClientWithAuth(deploymentUrl: "$YOUR_DEPLOYMENT_URL", authProvider: Auth0Provider())
    ```

6. Ensure that you update other references where `ConvexClient` is defined as a parameter or field
   to `ConvexClientWithAuth`.

At this point you should be able to use the `login` and `logout` methods on the client to perform
authentication with Auth0. Your Convex backend will receive the ID token from Auth0 and you'll be
able to
[use authentication details in your backend functions](https://docs.convex.dev/auth/functions-auth).

### Reacting to authentication state

The `ConvexClientWithAuth.authState` field is a `Publisher` that contains the latest authentication
state from the client. You can setup your UI to react to new `authState` values and show the
appropriate screens (e.g. login/logout buttons, loading screens, authenticated content).

The `AuthState.authenticated` value will contain the 
[`Credentials`](https://auth0.github.io/Auth0.swift/documentation/auth0/credentials)
object received from Auth0 and you can use the data that it contains to customize the user
experience in your app.

### Auto sign-in

If you would like your users to be able to launch your app directly into a signed in state after an
initial authentication, you can enable that via a flag on the `Auth0Provider` constructor.

```swift
let auth0 = Auth0Provider(enableCachedLogins: true)
```

This uses Auth0's
[`CredentialsManager`](https://auth0.github.io/Auth0.swift/documentation/auth0/credentialsmanager/)
behind the scenes to store tokens in the Keychain after successful authentication and to retrieve
previously stored tokens.

With `enableCachedLogins` you can call the `ConvexClientWithAuth.loginFromCache` method and it will
automatically sign the user back in if prior valid credentials are available. It will update the
`authState` flow just like calls to `login` and `logout` do for interactive operations.
