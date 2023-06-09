import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_clone/screens/mobile_layout_screen.dart';
import 'package:whatsapp_clone/utils/colors.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/widgets/error.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userDataAuthProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: currentUser.when(
          data: (user) {
            if (user == null) {
              return const LandingScreen();
            }
            return const MobileLayoutScreen();
          },
          error: (error, trace) {
            return ErrorScreen(error: error.toString());
          },
          loading: () => const CircularProgressIndicator()),
    );
  }
}
