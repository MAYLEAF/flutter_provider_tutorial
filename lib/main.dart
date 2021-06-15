import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_exam/database/database_provider.dart';
import 'package:provider_exam/model/user.dart' as Users;

typedef FirebaseUser = FirebaseAuth.User;
typedef User = Users.User;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var fb = await Firebase.initializeApp();

  runApp((LoginApp()));
}

class LoginApp extends StatelessWidget {
  DatabaseProvider db = DatabaseProvider();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser?>.value(
          value: FirebaseAuth.FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        StreamProvider<List<User>>.value(
          value: db.getUsers(),
          initialData: [],
        )
      ],
      child: MaterialApp(
        title: '인증 프로바이더',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  Map data = Map();

  var auth = FirebaseAuth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser?>(context);
    var loggedIn = user != null;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '로그인 페이지',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(children: [
          if (loggedIn) ...[
            ElevatedButton(
              child: Text('Sign out'),
              onPressed: auth.signOut,
            ),
          ],
          if (!loggedIn) ...[
            TextFormField(
              controller: emailCtrl,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: '이메일을 적어주세요.',
              ),
            ),
            TextFormField(
              controller: passwordCtrl,
              decoration: InputDecoration(
                icon: Icon(Icons.password),
                hintText: '비밀번호를 적어주세요',
              ),
            ),
            ElevatedButton(
              child: Text("Sign up"),
              onPressed: signUp,
            )
          ],
        ]));
  }

  void signUp() {
    String email = emailCtrl.text;
    String password = passwordCtrl.text;
    auth.createUserWithEmailAndPassword(email: email, password: password);

    emailCtrl.clear();
    passwordCtrl.clear();
  }
}
