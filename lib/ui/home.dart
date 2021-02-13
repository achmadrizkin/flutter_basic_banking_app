import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:transaction_banking_app/ui/costumerDetails.dart';

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

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference costumer = firestore.collection('costumer');
    CollectionReference transactionHistory =
        FirebaseFirestore.instance.collection('transactionHistory');
    //
    final db = FirebaseFirestore.instance;
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CreditCard(
                cardNumber: "5450 7879 4864 7854",
                cardExpiry: "10/25",
                cardHolderName: "Achmad Rizki",
                cvv: "456",
                bankName: "Flutter Bank",
                cardType: CardType.other,
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
                stream: transactionHistory.snapshots(),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CostumerDetails(
                                          name: '${ds['name']}',
                                          email: '${ds['email']}'),
                                    ),
                                  );
                                  // showdialog(true, ds);
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
