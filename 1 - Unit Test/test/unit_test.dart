import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test/models/post_model.dart';
import 'package:unit_test/services/http_service.dart';

void main(){

  test('Posts are not null', () async{
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    var posts = List<Post>.from(Network.parsePostList(response!));
    expect(posts, isNotNull);
  });

  test('Posts are more than zero', () async{
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    var posts = List<Post>.from(Network.parsePostList(response!));
    expect(posts.length, greaterThan(0));
  });

  test('Posts are 100', () async{
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    var posts = List<Post>.from(Network.parsePostList(response!));
    expect(posts.length, equals(100));
  });

  test('The second post\'s title is QUI EST ESSE', () async{
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    var posts = List<Post>.from(Network.parsePostList(response!));
    expect(posts[1].title!.toUpperCase(), equals('QUI EST ESSE'));
  });
}