extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  double? parseVndDouble() {
    return double.tryParse(this.replaceAll(",", '.'));
  }

  String displayVnd() {
    return this.trailing000().replaceAll('.', ',');
  }

  String trailing000() {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return this.replaceAll(regex, '');
  }
}
