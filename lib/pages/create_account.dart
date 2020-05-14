import 'dart:async';
import 'package:flutter/material.dart';
import 'package:instalite/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username;

  submit(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Welcome $username")));
      Timer(Duration(seconds: 2),(){
        Navigator.pop(context,username);
      });
    }
  }
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, isTitle: false, dispTitle: "Create Account"),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Text(
                    "Create a UserName",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autovalidate: true,
                      // ignore: missing_return
                      validator: (val){
                        if(val.trim().length <3 || val.trim().isEmpty){
                          return "UserName too Short";
                        }else if(val.trim().length>13){
                          return "UserName too long";
                        }else{
                          return null;
                        }
                      },
                      onSaved: (val)=> username=val,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "UserName",
                        labelStyle: TextStyle(
                          fontSize: 15.0
                        ),
                        hintText: "Must be atleast 3 characters",
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
