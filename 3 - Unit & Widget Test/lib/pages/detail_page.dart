import 'package:flutter/material.dart';
import 'package:unit_widget_testing/models/post_model.dart';
import 'package:unit_widget_testing/services/http_service.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Post post = Post();
  bool isLoading = true;

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    String? response = await Network.GET(
        Network.API_ONE + widget.id.toString(), Network.paramsEmpty());

    if (response != null) {
      post = Network.parsePost(response.toString());
      setState(() {});
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 4.0,
        title: const Text('Detail Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: isLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Text(
                    post.title!.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.body!.replaceRange(0, 1, post.body![0].toUpperCase()),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                    ),
                    maxLines: null,
                  ),
                ],
              ),
      ),
    );
  }
}
