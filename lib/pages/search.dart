import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instalite/models/user.dart';
import '../widgets/progress.dart';

final userRef = Firestore.instance.collection('users');

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> searchResultsFuture;
  TextEditingController controller = TextEditingController();

  getResults(String query) {
    final Future<QuerySnapshot> users =
        userRef.where("displayName", isGreaterThan: query).getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  AppBar buildSearchBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.account_box,
            size: 25,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
             setState(() {
               controller.clear();
               searchResultsFuture=null;
             });
            },
          ),
          filled: true,
          hintText: "Search For users",
        ),
        onFieldSubmitted: getResults,
      ),
    );
  }

  Container buildEmptyBody() {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300 : 200,
            ),
            Text(
              "Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                fontSize: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder buildSearchResults() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResultsFuture,
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgress();
        }
        List<UserResult> searchResults = [];

        for (DocumentSnapshot doc in snapshot.data.documents) {
          User user = User.fromDocument(doc);
          UserResult userResult=UserResult(user: user,);
          searchResults.add(userResult);
        }
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchBar(),
      body:
          searchResultsFuture == null ? buildEmptyBody() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;
  UserResult({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: GestureDetector(
        onTap: () => print('yooo'),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
          ),
          title: Text(
            user.displayName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            user.userName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
