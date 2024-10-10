import 'dart:io';

import 'package:blogger/core/error/failures.dart';
import 'package:blogger/core/usecase/usecase.dart';
import 'package:blogger/features/blog/domain/entities/blog.dart';
import 'package:blogger/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlogUsecase implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  UploadBlogUsecase(this.blogRepository);
  @override
  Future<Either<Failures, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      posterId: params.posterId,
      content: params.content,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams(
      {required this.posterId,
      required this.title,
      required this.content,
      required this.image,
      required this.topics});
}
