import 'package:dio/dio.dart';
import 'package:my_new_app/models/posts_model.dart';

class PostService {
  Future<List<PostsModel>> getPost() async {
    List<PostsModel> postsList = [];
    try {
      Response<dynamic> response =
          await Dio().get('https://jsonplaceholder.typicode.com/posts');
      dynamic data = response.data;
      data.forEach((element) {
        PostsModel post = PostsModel.fromJson(element);
        postsList.add(post);
      });
    } catch (e) {
      print(e);
    }
    return postsList;
  }
}
