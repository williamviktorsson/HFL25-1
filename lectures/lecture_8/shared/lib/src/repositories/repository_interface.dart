abstract interface class RepositoryInterface<T> {
  Future<T> create(T item);
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<T> update(String id, T item);
  Future<T> delete(String id);
}
