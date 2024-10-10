import 'dart:io';

import 'package:blogger/core/error/failures.dart';
import 'package:blogger/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failures, Blog>> uploadBlog({
    required File image,
    required String title,
    required String posterId,
    required String content,
    required List<String> topics,
  });

  Future<Either<Failures, List<Blog>>> getAllBlogs();
}
