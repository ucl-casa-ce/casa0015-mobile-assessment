class ApplianceModel {
  String? title;
  String? image;
  ApplianceModel({this.title, this.image});
}

List<ApplianceModel> category = [
  ApplianceModel(title: "TV", image: "images/tv.png"),
  ApplianceModel(title: "Oven", image: "images/Oven.png"),
  ApplianceModel(title: "Refrigerator", image: "images/refrigerator.png"),
  ApplianceModel(title: "blender", image: "images/blender.png"),
];
