import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:unit_test/models/post_model.dart';
import 'package:unit_test/pages/edit_create_page.dart';
import 'package:unit_test/services/http_service.dart';

class HomePage extends StatefulWidget {
  static const String id = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> posts = [];

  @override
  void initState() {
    fetchList();
    super.initState();
  }

  void fetchList() {
    setState(() {
      isLoading = true;
    });
    Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => parseResponse(response));
  }

  void deletePost(Post post) {
    Network.DELETE(
            Network.API_DELETE + post.id.toString(), Network.paramsEmpty())
        .then((response) => parseResponse(response));
  }

  void parseResponse(String? response) {
    if (response != null) {
      setState(() {
       posts = List<Post>.from(Network.parsePostList(response));
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void openCreatePage() async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditCreatePage(post: Post())));
    if (result != null) {
      posts.add(result as Post);
      fetchList();
    }
  }

  void openEditPage(Post post) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditCreatePage(
                  post: post,
                )));
    if (result != null) {
      posts
          .replaceRange(posts.indexOf(post), posts.indexOf(post) + 1, [result]);
      fetchList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 4.0,
        title: const Text("set State"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return postWidget(posts[index]);
            },
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 10.0,
        onPressed: openCreatePage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget postWidget(Post post) {
    return Card(
      child: Slidable(
        /// Edit
        startActionPane: ActionPane(
          dragDismissible: true,
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: CupertinoColors.activeBlue,
              onPressed: (_) {
                openEditPage(post);
                setState(() {});
              },
              icon: Icons.edit,
            ),
          ],
        ),

        /// Delete
        endActionPane: ActionPane(
          dragDismissible: true,
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: CupertinoColors.systemRed,
              onPressed: (_) {
                deletePost(post);
                posts.remove(post);
                setState(() {});
              },
              icon: Icons.delete,
            ),
          ],
        ),

        /// Body
        child: ListTile(
          title: Text(post.title!.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(post.body!),
        ),
      ),
    );
  }
}
