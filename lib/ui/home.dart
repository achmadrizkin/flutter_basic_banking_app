import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transaction_banking_app/ui/addTransactionCostumer.dart';
import 'package:awesome_card/awesome_card.dart';

class HomePage extends StatefulWidget {
  // List<DocumentSnapshot> ashiap;

  // HomePage({ashiap});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  showSnackbar() {
    final snackbar = new SnackBar(
      content: Text('Transaction Success!'),
      duration: Duration(seconds: 2),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference costumer = firestore.collection('costumer');

    //
    final db = FirebaseFirestore.instance;
    String transfer2Costumer;

    void showdialog(bool isUpdate, DocumentSnapshot ds) {
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
                    // focusColor: Colors.white,
                    // hoverColor: Colors.white,
                    // fillColor: Colors.white,
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Cant be a Empty!';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    transfer2Costumer = val;
                    // balanceController.text = _val;
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
                    // Collection     |     Document    |       Field
                    //  Costumer      |   snofnsdifone  | name: Achmad Rizki
                    //                                  | email: fauzie.rz@gmail.com
                    //                                  | balance: 9999999

                    // contoh ADD DATA
                    // add dari collection [Costumer] => [Document][Field][balance]
                    // db.collection('costumer').add({'balance': transfer2Costumer});

                    // Validation
                    if (formKey.currentState.validate()) {
                      // UPDATE DATA
                      db.collection('costumer').doc(ds.id).update({
                        'balance': transfer2Costumer ?? 0,
                      });

                      showSnackbar();
                      Navigator.of(context).pop();
                    }
                  },
                  child:
                      Text("Transfer", style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Banking',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'PoppinsBold')),
              TextSpan(
                  text: 'App',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF016DF7),
                      fontFamily: 'PoppinsBold')),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionCostumer()),
          );
        },
        backgroundColor: Color(0xFF016DF7),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: MediaQuery.of(context).size.height / 3.5,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20.0),
              //       color: Colors.black),
              //   child: StreamBuilder<DocumentSnapshot>(
              //     stream: costumer.doc("cveFGVwtOFhKubD8MBrG").snapshots(),
              //     builder: (_, snapshot) {
              //       if (snapshot.hasData) {
              //         return Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             Text('Name: ${snapshot.data.data()['name']}',
              //                 style: TextStyle(color: Colors.white)),
              //             Text('Email: ${snapshot.data.data()['email']}',
              //                 style: TextStyle(color: Colors.white)),
              //             Text('Balance: ${snapshot.data.data()['balance']}',
              //                 style: TextStyle(color: Colors.white)),
              //           ],
              //         );
              //       } else {
              //         return Text("Loading..");
              //       }
              //     },
              //   ),
              // ),
              CreditCard(
                cardNumber: "5450 7879 4864 7854",
                cardExpiry: "10/25",
                cardHolderName: "Achmad Rizki",
                cvv: "456",
                bankName: "Flutter Bank",
                cardType: CardType
                    .other, // Optional if you want to override Card Type
                showBackSide: false,
                frontBackground: CardBackgrounds.black,
                backBackground: CardBackgrounds.white,
                showShadow: false,
              ),

              SizedBox(height: 10.0),
              Text("Transaction History",
                  style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 18)),
              SizedBox(
                height: 10.0,
              ),
              //note: sync
              StreamBuilder<QuerySnapshot>(
                stream:
                    costumer.where("balance", isGreaterThan: '0').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.blue,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, int index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];

                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 5.0,
                                bottom: 5.0,
                              ),
                              child: Card(
                                color: Colors.blue,
                                elevation: 0.0,
                                child: ListTile(
                                  leading: Icon(Icons.account_circle_rounded,
                                      size: 38, color: Colors.white),
                                  trailing: Icon(
                                    Icons.arrow_circle_up_sharp,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  title: Text(ds['name'],
                                      style: TextStyle(
                                          fontFamily: 'PoppinsBold',
                                          color: Colors.white)),
                                  subtitle: Text('€${ds['balance']}',
                                      style: TextStyle(
                                          fontFamily: 'PoppinsReg',
                                          color: Colors.white)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Text('');
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("List Costumer",
                  style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 18)),
              SizedBox(
                height: 10.0,
              ),
              //note: sync
              StreamBuilder<QuerySnapshot>(
                stream: costumer
                    .where("name", isNotEqualTo: "Achmad Rizki Nur Fauzie")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, int index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];

                            return Card(
                              child: ListTile(
                                leading: Icon(Icons.account_circle_rounded,
                                    size: 38, color: Colors.black),
                                trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 28,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      // Delete Data
                                      db
                                          .collection('costumer')
                                          .doc(ds.id)
                                          .delete();
                                    }),
                                title: Text(ds['name'],
                                    style:
                                        TextStyle(fontFamily: 'PoppinsBold')),
                                subtitle: Text(ds['email'],
                                    style: TextStyle(
                                        fontFamily: 'PoppinsReg',
                                        fontSize: 14)),
                                onTap: () {
                                  // -- Update Data
                                  showdialog(true, ds);

                                  // ini bener juga tpi ga dynamic
                                  // db.collection('costumer').doc(ds.id).update({
                                  //   'balance': '1000',
                                  // });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Text('');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
