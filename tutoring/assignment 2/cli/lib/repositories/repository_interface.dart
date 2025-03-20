abstract interface class RepositoryInterface<T> {
  T create(T item);
  List<T> getAll();
  T? getById(int id);
  T update(int id, T item);
  T delete(int id);
}
