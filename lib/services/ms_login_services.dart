import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minecraft_realms/services/xboxlive_services.dart';
import 'package:msal_js/msal_js.dart';
import 'package:http/http.dart' as http;

import '../models/device_code.dart';

Future<void> msAuth() async {
  // Create an MSAL PublicClientApplication
  final publicClientApp = PublicClientApplication(Configuration()
    ..auth = (BrowserAuthOptions()
      ..authority = 'https://login.microsoftonline.com/consumers'
      // Give MSAL our client ID
      ..clientId = dotenv.env['CLIENT_ID']));

  try {
    // Handle redirect flow
    final AuthenticationResult? redirectResult =
        await publicClientApp.handleRedirectFuture();

    if (redirectResult != null) {
      // Just came back from a successful redirect flow
      print('Redirect login successful. name: ${redirectResult.account!.name}');

      // Set the account as active for convienence
      publicClientApp.setActiveAccount(redirectResult.account);
    } else {
      // Normal page load (not from an auth redirect)

      // Check if an account is logged in
      final List<AccountInfo> accounts = publicClientApp.getAllAccounts();

      if (accounts.isNotEmpty) {
        // An account is logged in, set the first one as active for convienence
        publicClientApp.setActiveAccount(accounts.first);
      }
    }
  } on AuthException catch (ex) {
    // Redirect auth failed
    print('MSAL: ${ex.message}');
  }

  if (publicClientApp.getAllAccounts().isEmpty) {
    redirectRequest(publicClientApp);
  } else {
    getSilentToken(publicClientApp);
  }
}

Future<void> getSilentToken(PublicClientApplication publicClientApp) async {
  try {
    await publicClientApp
        .acquireTokenSilent(SilentRequest()..scopes = [dotenv.env['SCOPE']!])
        .then((value) => {xboxAuth(value.accessToken!)});

    // Successful popup login
  } on AuthException catch (ex) {
    debugPrint(ex.errorMessage);
  }
}

Future<void> redirectRequest(PublicClientApplication publicClientApp) async {
  // Initiate redirect login
  final loginRequest = RedirectRequest()..scopes = [dotenv.env['SCOPE']!];

  publicClientApp.loginRedirect(loginRequest);
}

Future<void> popupRequest(PublicClientApplication publicClientApp) async {
  try {
    publicClientApp.loginPopup(PopupRequest()..scopes = [dotenv.env['SCOPE']!]);

    // Successful popup login
  } on AuthException catch (ex) {
    // Popup auth failed, ex contains the details of
    // why auth failed
  }
}
