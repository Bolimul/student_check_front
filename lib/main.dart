import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:student_check/UI/Pages/home_page.dart';
import 'package:student_check/UI/Providers/user_provider.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  await dotenv.load();
  runApp(MultiProvider(
    providers: [
    ChangeNotifierProvider(create: (context) => UserProvider())
    ],
    child: MaterialApp(
    title: 'Flutter App',
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Student Check'),
  )),
  );
}

