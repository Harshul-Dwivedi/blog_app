import 'package:blogger/core/common/widgets/loader.dart';
import 'package:blogger/core/theme/app_pallete.dart';
import 'package:blogger/core/utils/show_snackbar.dart';
import 'package:blogger/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogger/features/blog/presentation/pages/add_new_blog.dart';
import 'package:blogger/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPages extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPages());
  const BlogPages({super.key});

  @override
  State<BlogPages> createState() => _BlogPagesState();
}

class _BlogPagesState extends State<BlogPages> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Blogger",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, AddNewBlogPage.route());
              },
              icon: const Icon(CupertinoIcons.add_circled))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const CustomLoader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                    blog: blog,
                    color: index % 3 == 0
                        ? AppPallete.gradient1
                        : index % 3 == 1
                            ? AppPallete.gradient2
                            : AppPallete.gradient3,
                  );
                });
          }
          return const SizedBox();
        },
      ),
    );
  }
}
