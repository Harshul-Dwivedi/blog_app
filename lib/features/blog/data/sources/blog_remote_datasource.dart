import 'dart:io';

import 'package:blogger/core/error/exception.dart';
import 'package:blogger/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDatasource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog});
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDatasourceImpl implements BlogRemoteDatasource {
  final SupabaseClient supabaseClient;
  BlogRemoteDatasourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog}) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();

      ///above code will get you all data from blogs table as  well as the name
      ///from profiles table (user who posted it)
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
