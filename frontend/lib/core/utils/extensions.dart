extension StringExtension on String {
  String get capitalize =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;

  bool get isValidEmail =>
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(this);

  bool get isValidPassword => length >= 8;
}

extension NullableString on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
