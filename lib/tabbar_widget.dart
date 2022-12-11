import 'package:flutter/material.dart';
import 'package:flutter_academy_ar/login.dart';
import 'package:flutter_academy_ar/register.dart';

class TabbarWidget extends StatefulWidget {
  const TabbarWidget({Key? key}) : super(key: key);

  @override
  State<TabbarWidget> createState() => _TabbarWidgetState();
}

class _TabbarWidgetState extends State<TabbarWidget> with TickerProviderStateMixin{

  TabController? myController;
  List myTitle = ['Login','Register'];
  int myIndex = 0;

  @override
  void initState() {
      myController = TabController( initialIndex: 0,length: 2, vsync: this);
      myController!.addListener(() { 
        setState(() {
              myIndex = myController!.index;
        });
      });
    super.initState();
  }

  @override
  void dispose(){
    myController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(myTitle[myIndex]),
            bottom:  TabBar(
              controller: myController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.login),
                  text: 'Login'),
                Tab(
                    icon: Icon(Icons.app_registration),
                    text: 'Register'),
              ],
            ),
          ),
          body: TabBarView(
            controller: myController,
            children: const [
              Login(),
              RegistrationScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
