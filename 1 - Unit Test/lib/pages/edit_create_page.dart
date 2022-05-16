import 'package:flutter/material.dart';
import 'package:unit_test/models/post_model.dart';
import 'package:unit_test/services/http_service.dart';

class EditCreatePage extends StatefulWidget {
  static const String id = "edit_create_page";
  Post? post;

  EditCreatePage({Key? key, this.post}) : super(key: key);

  @override
  _EditCreatePageState createState() => _EditCreatePageState();
}

class _EditCreatePageState extends State<EditCreatePage> {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  void saveAndExit() async {
    setState(() {
      isLoading = true;
    });
    String title = titleController.text.toString().trim();
    String body = bodyController.text.toString().trim();
    if(widget.post!.title!=null && widget.post!.body!=null){
      Post postUpdate = Post(
          id: widget.post!.id,
          title: title,
          body: body,
          userId: widget.post!.userId);
      await Network.PUT(
          Network.API_UPDATE + postUpdate.id.toString(), Network.paramsUpdate(postUpdate));
      Navigator.pop((context), postUpdate);
    } else {
      Post postCreate = Post(title: title, body: body, userId: title.hashCode);
      await Network.POST(Network.API_CREATE, Network.paramsCreate(postCreate));
      Navigator.pop((context), postCreate);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 4.0,
        title: Text(widget.post!.title!=null && widget.post!.body!=null?"Edit post":"Create post"),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: saveAndExit,
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 18),
              ))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: titleController..text = widget.post!.title?.toUpperCase() ?? titleController.text,
                    maxLines: null,
                    style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10, top: 10),
                        hintText: "Title"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller:  bodyController..text = widget.post!.body??bodyController.text,
                    maxLines: null,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "Body",
                        border: OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Container(),
        ],
      ),
    );
  }
}