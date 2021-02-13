import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CostumerDetails extends StatelessWidget {
  String name;
  String email;
  CostumerDetails({this.name, this.email});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  showSnackbar() {
    final snackbar = new SnackBar(
      content: Text('Transaction Success!'),
      duration: Duration(seconds: 2),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  CollectionReference transactionHistory =
      FirebaseFirestore.instance.collection('transactionHistory');

  String transfer2Costumer;
  final db = FirebaseFirestore.instance;

  void showdialog(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title:
                Text("Transfer Money", style: TextStyle(color: Colors.black)),
            content: Form(
              key: formKey,
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "00.00",
                  prefixIcon: Icon(
                    Icons.euro,
                    color: Colors.black,
                  ),
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Cant be a Empty!';
                  }
                  return null;
                },
                onChanged: (val) {
                  transfer2Costumer = val;
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel", style: TextStyle(color: Colors.black)),
              ),
              FlatButton(
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    // ADD DATA
                    transactionHistory.add({
                      'name': name,
                      'balance': transfer2Costumer ?? 0,
                      // 'balance': balanceController.text ?? 0,
                    });
                    showSnackbar();
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Transfer", style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Transfer',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'PoppinsBold')),
              TextSpan(
                  text: 'Money',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF016DF7),
                      fontFamily: 'PoppinsBold')),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(child: Icon(Icons.account_circle_rounded, size: 250)),
                Text('Name: ${name}',
                    style: TextStyle(
                        fontFamily: 'PoppinsBold',
                        color: Colors.black,
                        fontSize: 24)),
                Text('Email: ${email}',
                    style: TextStyle(
                        fontFamily: 'PoppinsReg',
                        color: Colors.black,
                        fontSize: 16)),
                SizedBox(height: 20),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.black,
                  child: Text('Transfer Money',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    showdialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
