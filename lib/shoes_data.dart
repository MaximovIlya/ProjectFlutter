class ShoesData {
  String id;
  String title;
  String price;
  int size;
  String imageUrl;


  ShoesData({
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.size,
    required this.title,
  });

  ShoesData.fromJson(Map <String, dynamic> json)
  : id = json['id'],
    title = json['title'],
    price = json['price'],
    size = json['size'],
    imageUrl = json['imageUrl'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'price' : price,
    'size' : size,
    'imageUrl' : imageUrl,
  };
}