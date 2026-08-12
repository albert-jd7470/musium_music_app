class FeaturedItemModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String targetUrl;

  FeaturedItemModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.targetUrl,
  });

  factory FeaturedItemModel.fromJson(Map<String, dynamic> json) {
    String image = '';
    if (json['image'] is List && (json['image'] as List).isNotEmpty) {
      image = (json['image'] as List).last['link']?.toString() ?? '';
    }
    
    return FeaturedItemModel(
      title: json['title']?.toString() ?? json['name']?.toString() ?? 'Featured',
      subtitle: json['subtitle']?.toString() ?? 'Playlist',
      imageUrl: image,
      targetUrl: json['id']?.toString() ?? json['url']?.toString() ?? '',
    );
  }
}
