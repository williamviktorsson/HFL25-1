import 'package:cli_shared/src/models/result.dart';

abstract interface class RepositoryInterface<T, E> {
  Future<Result<T, E>> create(T item);
  Future<Result<List<T>, E>> getAll();
  Future<Result<T, E>> getById(String id);
  Future<Result<T, E>> update(String id, T item);
  Future<Result<T, E>> delete(String id);
}
