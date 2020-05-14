import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instalite/pages/activity_feed.dart';
import 'package:instalite/pages/create_account.dart';
import 'package:instalite/pages/profile.dart';
import 'package:instalite/pages/search.dart';
import 'package:instalite/pages/timeline.dart';
import 'package:instalite/pages/upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final userRef = Firestore.instance.collection("users");
final timeStamp = DateTime.now();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  User currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print(err);
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }, onError: (err) {
      print(err);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void handleSignIn(account) {
    if (account != null) {
      setState(() {
        isAuth = true;
        createAccount();
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createAccount() async {
    final user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userRef.document(user.id).get();

    if (!doc.exists) {
      final userName = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      userRef.document(user.id).setData({
        'id': user.id,
        'userName': userName,
        'photoUrl': user.photoUrl,
        'email': user.email,
        'displayName': user.displayName,
        'bio': '',
        'timeStamp': timeStamp,
      });
      doc = await userRef.document(user.id).get();
    }

    currentUser = User.fromDocument(doc);
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
//          TimeLine(),
            RaisedButton(
              onPressed: logout,
              child: Text(
                'logout',
              ),
            ),
            ActivityFeed(),
            Upload(),
            Search(),
            Profile()
          ],
          controller: pageController,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.grey,
          currentIndex: pageIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.whatshot), title: Text('')),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active), title: Text('')),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.camera_alt,
                  size: 35,
                ),
                title: Text('')),
            BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), title: Text('')),
          ],
          onTap: (page) {
            setState(() {
              pageController.animateToPage(page,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              pageIndex = page;
            });
          },
        ));
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Insta lite",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Signatra",
                fontSize: 90,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
