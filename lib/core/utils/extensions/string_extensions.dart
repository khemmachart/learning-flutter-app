
extension DateFormatting on String {
  String formatDate() {
    final date = DateTime.parse(this);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}