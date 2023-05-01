import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class _HomePageState extends State<HomePage> {
  GoogleSignInAccount? _currentUser;

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((event) {
      setState(() {
        _currentUser = event;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentUser == null ? 'Login' : 'Sign In'),
      ),
      body: _currentUser == null
          ? Container(
              margin: const EdgeInsets.all(50),
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () => _handleSignIn(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          child: Image.network(
                              'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Sign in with google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  )),
            )
          : Container(
              child: ListTile(
                leading: GoogleUserCircleAvatar(identity: _currentUser!),
                title: Text(_currentUser!.displayName ?? ''),
                subtitle: Text(_currentUser!.email),
                trailing: IconButton(
                  onPressed: () {
                    _googleSignIn.disconnect();
                  },
                  icon: const Icon(Icons.logout),
                ),
              ),
            ),
    );
  }
}
