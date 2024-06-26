import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vcard_project/models/contact_model.dart';
import 'package:vcard_project/pages/home_page.dart';
import 'package:vcard_project/providers/contact_provider.dart';
import 'package:vcard_project/utils/constants.dart';
import 'package:vcard_project/utils/helper_functions.dart';

class FormPage extends StatefulWidget {
  static const String routeName = 'form';
  final ContactModel contactModel;

  const FormPage({super.key, required this.contactModel});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final companyController = TextEditingController();
  final designationController = TextEditingController();
  final webController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.contactModel.name;
    mobileController.text = widget.contactModel.mobile;
    emailController.text = widget.contactModel.email;
    addressController.text = widget.contactModel.address;
    companyController.text = widget.contactModel.company;
    designationController.text = widget.contactModel.designation;
    webController.text = widget.contactModel.website;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Page'),
        actions: [
          IconButton(
              onPressed: saveContact,
              icon: const Icon(Icons.save))
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Name', prefixIcon: Icon(Icons.man)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyErrMsgField;
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: mobileController,
              decoration: const InputDecoration(
                  labelText: 'Mobile', prefixIcon: Icon(Icons.phone)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return emptyErrMsgField;
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.email)),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.home), // Use prefixIcon or suffixIcon
              ),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: companyController,
              decoration: const InputDecoration(
                labelText: 'Company',
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: designationController,
              decoration: const InputDecoration(
                labelText: 'Designation',
                prefixIcon: Icon(Icons.account_circle),
              ),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: webController,
              decoration: const InputDecoration(
                labelText: 'Website',
                prefixIcon: Icon(Icons.web_sharp),
              ),
              validator: (value) {
                return null;
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    companyController.dispose();
    designationController.dispose();
    webController.dispose();
    super.dispose();
  }

  void saveContact() {
    if (_formKey.currentState!.validate()) {
      widget.contactModel.name = nameController.text;
      widget.contactModel.mobile = mobileController.text;
      widget.contactModel.email = emailController.text;
      widget.contactModel.address = addressController.text;
      widget.contactModel.company = companyController.text;
      widget.contactModel.designation = designationController.text;
      widget.contactModel.website = webController.text;
      Provider.of<ContactProvider>(context, listen: false)
          .insertContact(widget.contactModel)
          .then((value) {
        if(value>0){
          showMsg(context, 'Saved');
          context.goNamed(HomePage.routeName);
        }
      })
          .catchError((error){
        showMsg(context, 'Failes to Save !');
      });
    }
  }
}
