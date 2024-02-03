/// Checks if the given [value] is a valid URL link.
///
/// Returns `true` if the [value] matches the URL pattern, otherwise `false`.
bool isLink(String value) {
  Uri? uri = Uri.tryParse(value);
  return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
}
