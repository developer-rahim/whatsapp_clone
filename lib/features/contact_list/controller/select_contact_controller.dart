import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/contact_list/repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});
final selectContactControllerProvider = Provider((ref) {
  final selectedContactRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(
      ref: ref, selecteContactRepository: selectedContactRepository);
});

class SelectContactController {
  ProviderRef? ref;
  SelecteContactRepository? selecteContactRepository;
  SelectContactController({
    required this.ref,
    required this.selecteContactRepository,
  });

  void selectContact(
    Contact selectedContact,
    BuildContext context,
  ) {
    selecteContactRepository!.selectContact(selectedContact, context);
  }
}
