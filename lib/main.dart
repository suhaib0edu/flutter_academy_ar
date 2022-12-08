import 'package:flutter/material.dart';
import 'package:flutter_academy_ar/basic_widgets.dart';
import 'package:flutter_academy_ar/home.dart';
import 'package:flutter_academy_ar/login.dart';
import 'package:flutter_academy_ar/register.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/login',
  routes: {
    '/login' : (context) => Login(),
    '/register' : (context) => RegistrationScreen(),
    '/home' : (context) => HomeScreen(),
    '/basicWidget' : (context) => BasicWidgetsScreen(),
  },
));