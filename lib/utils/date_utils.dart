class DateUtilsHelper {
  DateUtilsHelper._();

  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  static String formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute =
        date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${formatTime(date)}';
  }

  static String relativeTime(DateTime date) {
    final difference =
        DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} day'
          '${difference.inDays == 1 ? '' : 's'} ago';
    }

    return formatDate(date);
  }
}
