import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget{
  final void Function(BuildContext) signUserOut;
  const MenuDrawer({super.key, required this.signUserOut});

   

  @override
  Widget build(BuildContext context){
    List<Color> colors = [Colors.blue, Colors.purple];
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Column(
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                child: Text("Logo Here"),
              ),
              Spacer(),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                  ),
                title: Text(
                  "Dashboard",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: (){
                  print("Dashboard was pressed");
                    Navigator.pop(context);
                },
              ),
              Spacer(),
              ListTile(
                leading: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                title: Text(
                  "Favorites",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: (){
                  print("Favorites was pressed");
                },
              ),
              Spacer(),
              ListTile(
                leading: Icon(
                  Icons.newspaper,
                  color: Colors.white,
                ),
                title: Text(
                  "News Room",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: (){
                  print("News Room was pressed");
                },
              ),
              Spacer(),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                title: Text(
                  "Account",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: (){
                  print("Account was pressed");
                },
              ),
              Spacer(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  "Signout",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => signUserOut(context),
              ),
              Spacer(),
            ]
          ),
        ),
    );
  }
}