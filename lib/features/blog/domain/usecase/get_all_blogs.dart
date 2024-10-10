import 'package:blogger/core/error/failures.dart';
import 'package:blogger/core/usecase/usecase.dart';
import 'package:blogger/features/blog/domain/entities/blog.dart';
import 'package:blogger/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogsUsecase implements Usecase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;
  GetAllBlogsUsecase(this.blogRepository);
  @override
  Future<Either<Failures, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
