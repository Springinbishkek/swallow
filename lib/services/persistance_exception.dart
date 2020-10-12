class PersistanceException extends Error {
  final String message;

  PersistanceException(e) : this.message = e.toString();
}
