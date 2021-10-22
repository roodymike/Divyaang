import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:vibration/vibration.dart';

import 'BiometricAuthScreen.dart';

class PaymentForDeaf extends StatefulWidget {
  @override
  _PaymentForDeafState createState() => _PaymentForDeafState();
}


class _PaymentForDeafState extends State<PaymentForDeaf> {

  @override
  initState() {
    super.initState();
      }
  @override

  Widget build(BuildContext context) {
    double screenHieght = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  _buildHeader(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/40,
                  ),
                  GestureDetector(
                      onTap: () {
                        Vibration.vibrate(duration: 100);
                      },
                      onDoubleTap: () {
                      },
                      child: _buildGradientBalanceCard(screenHieght)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/35,
                  ),
                  _buildCategories(context),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/50,
            ),
            _buildTransactionList()
          ],
        ),
      ),
    );
  }
}

Container _buildTransactionList() {
  return Container(
    height: 400,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 5,
          color: Colors.grey.withOpacity(0.1),
          offset: Offset(0, -10),
        ),
      ],
    ),
    child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0 * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Transaction",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.0 * 2),
              _buildTransactionItem(
                color: Colors.deepPurpleAccent,
                iconData: Icons.photo_size_select_actual,
                title: "Electric Bill",
                date: "Today",
                amount: 11.5,
              ),
              SizedBox(height: 24),
              _buildTransactionItem(
                color: Colors.green,
                iconData: Icons.branding_watermark,
                title: "Water Bill",
                date: "Today",
                amount: 15.8,
              ),
              SizedBox(height: 24),
              _buildTransactionItem(
                color: Colors.orange,
                iconData: Icons.music_video,
                title: "Spotify",
                date: "Yesterday",
                amount: 05.5,
              ),
              SizedBox(height: 24),
              _buildTransactionItem(
                color: Colors.red,
                iconData: Icons.wifi,
                title: "Internet",
                date: "Yesterday",
                amount: 10.0,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Row _buildCategories(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      GestureDetector(
        onTap: (){
          Vibration.vibrate(duration: 400);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BiometricAuthScreen()));
        },
        child: _buildCategoryCard(
          bgColor: Constants.sendBackgroundColor,
          iconColor: Constants.sendIconColor,
          iconData: Icons.send,
          text: "Send",
        ),
      ),
      _buildCategoryCard(
        bgColor: Constants.paymentBackgroundColor,
        iconColor: Constants.paymentIconColor,
        iconData: Icons.payment,
        text: "Payment",
      ),
    ],
  );
}

Container _buildGradientBalanceCard(double screenHeight) {
  return Container(
    height: screenHeight/4,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.purpleAccent.withOpacity(0.9),
          Constants.deepBlue,
        ],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "\$8,458.00",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 28,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Total Balance",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}

Row _buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Peripherally Impaired,",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Test Deaf User",
            style: TextStyle(
              fontSize: 28,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  );
}

Row _buildTransactionItem(
    {required Color color,
      required IconData iconData,
      required String date,
      required String title,
      required double amount}) {
  return Row(
    children: <Widget>[
      Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
      SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          )
        ],
      ),
      Spacer(),
      Text(
        "-\$ $amount",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ],
  );
}

Column _buildCategoryCard(
    {required Color bgColor,
      required Color iconColor,
      required IconData iconData,
      required String text}) {
  return Column(
    children: <Widget>[
      Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          iconData,
          color: iconColor,
          size: 36,
        ),
      ),
      SizedBox(height: 8),
      Text(text),
    ],
  );
}
