import 'dart:io';

import 'package:blogger/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogger/core/common/widgets/loader.dart';
import 'package:blogger/core/constants/constants.dart';
import 'package:blogger/core/theme/app_pallete.dart';
import 'package:blogger/core/utils/pick_image.dart';
import 'package:blogger/core/utils/show_snackbar.dart';
import 'package:blogger/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogger/features/blog/presentation/pages/blog_pages.dart';
import 'package:blogger/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final List<String> selectedTopics = [];
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;

  void selectNewImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(BlogUpload(
            posterId: posterId,
            title: titleController.text.trim(),
            content: contentController.text.trim(),
            image: image!,
            topics: selectedTopics,
          ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                uploadBlog();
              },
              icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPages.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const CustomLoader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectNewImage,
                            child: SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          )
                        : GestureDetector(
                            onTap: selectNewImage,
                            child: DottedBorder(
                                color: AppPallete.borderColor,
                                dashPattern: const [10, 4],
                                radius: const Radius.circular(14),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Select your Image",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopics.contains(e)) {
                                        selectedTopics.remove(e);
                                      } else {
                                        selectedTopics.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                        color: selectedTopics.contains(e)
                                            ? const WidgetStatePropertyAll(
                                                AppPallete.gradient1)
                                            : null,
                                        side: selectedTopics.contains(e)
                                            ? null
                                            : const BorderSide(
                                                color: AppPallete.borderColor),
                                        label: Text(e)),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                        controller: titleController, hintText: "Blog Title"),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                        controller: contentController,
                        hintText: "Blog Content"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}