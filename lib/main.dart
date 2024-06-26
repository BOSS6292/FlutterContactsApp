import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vcard_project/models/contact_model.dart';
import 'package:vcard_project/pages/contacts_details_page.dart';
import 'package:vcard_project/pages/form_page.dart';
import 'package:vcard_project/pages/home_page.dart';
import 'package:vcard_project/pages/scan_page.dart';
import 'package:vcard_project/providers/contact_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => ContactProvider(),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: _routes,
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }

  final _routes = GoRouter(debugLogDiagnostics: true, routes: [
    GoRoute(
        name: HomePage.routeName,
        path: HomePage.routeName,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            name: ContactDetailsPage.routeName,
              path: ContactDetailsPage.routeName,
          builder: (context, state) => ContactDetailsPage(id: state.extra! as int,),),
          GoRoute(
              path: ScanPage.routeName,
              name: ScanPage.routeName,
              builder: (context, state) => const ScanPage(),
              routes: [
                GoRoute(
                    path: FormPage.routeName,
                    name: FormPage.routeName,
                    builder: (context, state) => FormPage(
                          contactModel: state.extra! as ContactModel,
                        ))
              ])
        ]),
  ]);
}
