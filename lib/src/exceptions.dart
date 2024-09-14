class PolicyValidationException implements Exception {
  final String message;

  PolicyValidationException(this.message);

  @override
  String toString() {
    return "Invalid policy: $message";
  }
}
