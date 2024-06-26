import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vcard_project/models/contact_model.dart';
import 'package:vcard_project/pages/form_page.dart';
import 'package:vcard_project/utils/constants.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
  static const String routeName = 'scan';
}

class _ScanPageState extends State<ScanPage> {
  bool isScanOver = false;
  List<String> lines = [];
  String name = '',
      address = '',
      mobile = '',
      email = '',
      company = '',
      designation = '',
      website = '',
      image = '';

  void CreateContact() {
    final contact = ContactModel(
      name: name,
      mobile: mobile,
      email: email,
      address: address,
      company: company,
      designation: designation,
      website: website,
      image: image,
    );
    context.goNamed(FormPage.routeName,extra: contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Page'),
        actions: [
          IconButton(
              onPressed: image.isEmpty ? null : CreateContact,
              icon: const Icon(Icons.arrow_forward)),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Camera'),
              ),
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo_album),
                label: const Text('Gallery'),
              )
            ],
          ),
          if (isScanOver)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    DragTargetItem(
                        onDrop: getPropertyValue,
                        Property: ContactProperties.name),
                    DragTargetItem(
                        onDrop: getPropertyValue,
                        Property: ContactProperties.mobile),
                    DragTargetItem(
                        onDrop: getPropertyValue,
                        Property: ContactProperties.email),
                    DragTargetItem(
                        onDrop: getPropertyValue,
                        Property: ContactProperties.company),
                    DragTargetItem(
                        onDrop: getPropertyValue,
                        Property: ContactProperties.designation),
                    DragTargetItem(
                        onDrop: getPropertyValue,
                        Property: ContactProperties.website),
                    DragTargetItem(
                        onDrop: getPropertyValue,
                        Property: ContactProperties.address)
                  ],
                ),
              ),
            ),
          if (isScanOver)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(hint),
            ),
          Wrap(
            children: lines.map((line) => LineItem(line: line)).toList(),
          )
        ],
      ),
    );
  }

  void getImage(ImageSource camera) async {
    EasyLoading.show(status: 'Getting Image');
    final xFile = await ImagePicker().pickImage(source: camera);
    EasyLoading.dismiss();
    EasyLoading.show(status: 'Extracting Text from the Image');
    if (xFile != null) {
      setState(() {
        image = xFile.path;
      });
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer
          .processImage(InputImage.fromFile(File(xFile.path)));
      EasyLoading.dismiss();
      final tempList = <String>[];
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          tempList.add(line.text);
        }
      }
      setState(() {
        isScanOver = true;
        lines = tempList;
      });
    }
  }

  getPropertyValue(String property, String value) {
    switch (property) {
      case ContactProperties.name:
        name = value;
        break;
      case ContactProperties.address:
        address = value;
        break;
      case ContactProperties.website:
        website = value;
        break;
      case ContactProperties.designation:
        designation = value;
        break;
      case ContactProperties.company:
        company = value;
        break;
      case ContactProperties.mobile:
        mobile = value;
        break;
      case ContactProperties.email:
        email = value;
        break;
    }
  }
}

class LineItem extends StatelessWidget {
  final String line;

  const LineItem({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: line,
      dragAnchorStrategy: childDragAnchorStrategy,
      feedback: Container(
          key: GlobalKey(),
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.black45,
          ),
          child: Text(
            line,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          )),
      child: Chip(
        label: Text(line),
      ),
    );
  }
}

class DragTargetItem extends StatefulWidget {
  final String Property;
  final Function(String, String) onDrop;

  const DragTargetItem(
      {super.key, required this.onDrop, required this.Property});

  @override
  State<DragTargetItem> createState() => _DragTargetItemState();
}

class _DragTargetItemState extends State<DragTargetItem> {
  String dragItem = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(widget.Property),
        ),
        Expanded(
          flex: 2,
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) => Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: candidateData.isNotEmpty
                    ? Border.all(color: Colors.red, width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(dragItem.isEmpty ? 'Drop Here' : dragItem),
                  ),
                  if (dragItem.isNotEmpty)
                    InkWell(
                      onTap: () {
                        setState(() {
                          dragItem = '';
                        });
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 15,
                      ),
                    )
                ],
              ),
            ),
            /*onAccept: (value) {
              setState(() {
                if (dragItem.isEmpty) {
                  dragItem = value;
                } else {
                  dragItem += ' $value';
                }
              });
              widget.onDrop(widget.Property, dragItem);
            },*/
            onAcceptWithDetails: (DragTargetDetails<String> details) {
              setState(() {
                if (dragItem.isEmpty) {
                  dragItem = details.data; // Access data from details
                } else {
                  dragItem += ' ${details.data}';
                }
              });
              widget.onDrop(widget.Property, dragItem);
            },
          ),
        )
      ],
    );
  }
}
