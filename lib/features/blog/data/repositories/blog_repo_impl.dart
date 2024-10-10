import 'dart:io';
import 'package:blogger/core/constants/constants.dart';
import 'package:blogger/core/error/exception.dart';
import 'package:blogger/core/network/connection_checker.dart';
import 'package:blogger/features/auth/data/sources/blog_local_datasource.dart';
import 'package:blogger/features/blog/data/sources/blog_remote_datasource.dart';
import 'package:uuid/uuid.dart';
import 'package:blogger/core/error/failures.dart';
import 'package:blogger/features/blog/data/models/blog_model.dart';
import 'package:blogger/features/blog/domain/entities/blog.dart';
import 'package:blogger/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDatasource blogRemoteDatasource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(
    this.blogRemoteDatasource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );
  @override
  Future<Either<Failures, Blog>> uploadBlog({
    required File image,
    required String title,
    required String posterId,
    required String content,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures(Constants.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
          id: const Uuid().v1(),
          posterId: posterId,
          title: title,
          content: content,
          imageUrl: 'imageUrl',
          topics: topics,
          updatedAt: DateTime.now());

      final imageUrl = await blogRemoteDatasource.uploadBlogImage(
          image: image, blog: blogModel);

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await blogRemoteDatasource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDatasource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);

      return right(blogs);
    } on ServerException catch (e) {
      return left(Failures(e.toString()));
    }
  }
}
