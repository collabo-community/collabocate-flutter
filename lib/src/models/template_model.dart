class IssueTemplate {
  final String name;
  final String downloadUrl;

  IssueTemplate({
    required this.name,
    required this.downloadUrl,
  });
  factory IssueTemplate.fromJson(Map<String, dynamic> json) {
    return IssueTemplate(
      name: json['name'] as String,
      downloadUrl: json['download_url'] as String,
    );
  }
}
