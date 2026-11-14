sealed class Result<T, E> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get dataOrNull => switch (this) {
    Success(data: final data) => data,
    Failure() => null,
  };

  E? get errorOrNull => switch (this) {
    Success() => null,
    Failure(error: final error) => error,
  };
}

class Success<T, E> extends Result<T, E> {
  final T data;

  const Success(this.data);
}

class Failure<T, E> extends Result<T, E> {
  final E error;

  const Failure(this.error);
}
