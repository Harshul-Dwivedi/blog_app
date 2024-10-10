import 'dart:io';

import 'package:blogger/core/usecase/usecase.dart';
import 'package:blogger/features/blog/domain/entities/blog.dart';
import 'package:blogger/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:blogger/features/blog/domain/usecase/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlogUsecase _uploadBlogUsecase;
  final GetAllBlogsUsecase _getAllBlogsUsecase;
  BlogBloc({
    required UploadBlogUsecase uploadBlogUsecase,
    required GetAllBlogsUsecase getAllBlogUsecase,
  })  : _uploadBlogUsecase = uploadBlogUsecase,
        _getAllBlogsUsecase = getAllBlogUsecase,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlogUsecase(UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics));
    res.fold((l) {
      emit(BlogFailure(l.message));
    }, (r) {
      emit(BlogUploadSuccess());
    });
  }

  void _onFetchAllBlogs(
      BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogsUsecase(NoParams());
    res.fold((l) {
      emit(BlogFailure(l.message));
    }, (r) {
      emit(BlogDisplaySuccess(r));
    });
  }
}
