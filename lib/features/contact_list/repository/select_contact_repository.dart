import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelecteContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelecteContactRepository {
  FirebaseFirestore? firestore;
  SelecteContactRepository({
    required this.firestore,
  });
  getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContacts, BuildContext context) async {
    try {
      var userCollection = await firestore!.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());

        String selectedPhoneNum = selectedContacts.phones[0].number.replaceAll(
          ' ',
          '',
        );

        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
       
        }
        if (!isFound) {
          print(userData.phoneNumber);
          print(selectedPhoneNum);
          showSnackBar(context: context, content: 'contact not found');
        }
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
