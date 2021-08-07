import 'package:flutter/material.dart';

AppBar customAppbar(BuildContext context) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    leading: IconButton(
      icon: Icon(
        Icons.chevron_left_outlined,
        color: Theme.of(context).backgroundColor,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.16,
          ),
        ],
      ),
    ),
  );
}
