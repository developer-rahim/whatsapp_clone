import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_layout_screen.dart';
import 'package:whatsapp_clone/utils/utils.dart';

final authRepositoryProvider = Provider(
  (ref) {
    return AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  },
);

class AuthRepository {
  final FirebaseAuth? auth;
  final FirebaseFirestore? firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });
  void signInWithPhone(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      await auth!.verifyPhoneNumber(
          timeout: const Duration(minutes: 2),
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential? credential) async {
            await auth!.signInWithCredential(credential!);
            print("......$credential");
          },
          verificationFailed: (e) {
            showSnackBar(
              context: context,
              content: e.message!,
            );

            throw Exception(e.message);
          },
          codeSent: ((
            String? verificationId,
            int? resendToken,
          ) async {
            print("......$verificationId......................");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (contex) => OTPScreen(verificationId: verificationId!),
              ),
            );
          }),
          codeAutoRetrievalTimeout: (String? verificationId) {
            showSnackBar(
              context: context,
              content: 'Time ',
            );

            return print("......$verificationId");
          });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth!.signInWithCredential(credential);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserInformationScreen(),
          ));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth!.currentUser!.uid;
      String photoUrl =
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8HOgf6tN6loVe53X3OsBY7fGPyDNupQKVLhrud82L&s';
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profile/$uid',
              profilePic,
            );
      }

      UserModel user = UserModel(
          groupId: [],
          phoneNumber: auth!.currentUser!.uid,
          profilePic: photoUrl,
          name: name,
          isOnline: true,
          uid: uid);
      await firestore!.collection('users').doc(uid).set(user.toMap());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
