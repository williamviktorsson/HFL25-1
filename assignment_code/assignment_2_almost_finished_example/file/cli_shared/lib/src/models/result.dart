sealed class Result<T, E> {
  const Result();

  factory Result.success({required T value}) => Success(data: value);
  factory Result.failure({required E reason}) => Failure(error: reason);
}

class Success<T, E> extends Result<T, E> {
  final T data;
  const Success({required this.data});
}

class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure({required this.error});
}

