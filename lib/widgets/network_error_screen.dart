import 'package:flutter/material.dart';
import 'package:memexd/services/network_checker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkErrorScreen extends StatefulWidget {
  @override
  _NetworkErrorScreenState createState() => _NetworkErrorScreenState();
}

class _NetworkErrorScreenState extends State<NetworkErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.04,
                width: MediaQuery.of(context).size.width * 0.08,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('images/memexdlogo.png'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Center(
                child: Text(
                  'MEMEXD',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).backgroundColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    letterSpacing: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.015),
          color: Theme.of(context).backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('images/internet_connectivity.jpeg'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              ElevatedButton(
                onPressed: () {
                  context.refresh(networkResult);
                },
                child: Text(
                  'Try Again',
                  style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
