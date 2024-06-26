import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vcard_project/pages/contacts_details_page.dart';
import 'package:vcard_project/pages/scan_page.dart';
import 'package:vcard_project/providers/contact_provider.dart';
import 'package:vcard_project/utils/helper_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  static const String routeName = '/';
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(ScanPage.routeName);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
              _fetchData();
            },
            currentIndex: selectedIndex,
            backgroundColor: Colors.blue[100],
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'All'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'favorite'),
            ]),
      ),
      body: Consumer<ContactProvider>(
          builder:
              (BuildContext context, ContactProvider provider, Widget? child) =>
                  ListView.builder(
                    itemCount: provider.contactList.length,
                    itemBuilder: (context, index) {
                      final contact = provider.contactList[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.only(right: 20),
                          alignment: FractionalOffset.centerRight,
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        confirmDismiss: _showDismissDialog,
                        onDismissed: (_)async{
                          await provider.deleteContact(contact.id);
                          showMsg(context, 'Delete');
                        },
                        child: ListTile(
                          onTap: () => context.goNamed(ContactDetailsPage.routeName,extra: contact.id),
                          title: Text(contact.name),
                          trailing: IconButton(
                            onPressed: () {
                              provider.updateFavorite(contact);
                            },
                            icon: Icon(contact.favorite
                                ? Icons.favorite
                                : Icons.favorite_border),
                          ),
                        ),
                      );
                    },
                  )),
    );
  }

  Future<bool?> _showDismissDialog(DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Contact'),
              content: const Text('Are you sure to delete this contact?'),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      context.pop(false);
                    },
                    child: const Text('No')),
                OutlinedButton(
                    onPressed: () {
                      context.pop(true);
                    },
                    child: const Text('Yes'))
              ],
            ));
  }

  void _fetchData() {
    switch(selectedIndex){
      case 0:
        Provider.of<ContactProvider>(context,listen: false).getAllContacts();
        break;
      case 1:
        Provider.of<ContactProvider>(context,listen: false).getAllFavoriteContacts();
        break;

    }
  }
}