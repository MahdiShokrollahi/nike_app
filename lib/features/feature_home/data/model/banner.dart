class BannerModel {
  final int id;
  final String imageUrl;

  BannerModel(this.id, this.imageUrl);
  BannerModel.fromJson(Map<String, dynamic> jsonObject)
      : id = jsonObject['id'],
        imageUrl = jsonObject['image'];
}
