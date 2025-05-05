import '../models/clothing.dart';

final List<Clothing> wardrobe = [
  // top
  Clothing(name: "short T-shirt", minTemp: 22.0, maxTemp: 40.0, isTop: true),
  Clothing(name: "T-shirt", minTemp: 18.0, maxTemp: 25.0, isTop: true),
  Clothing(name: "knitwear", minTemp: 10.0, maxTemp: 18.0, isTop: true),
  Clothing(name: "hoodies", minTemp: 15.0, maxTemp: 22.0, isTop: true),
  Clothing(name: "sweater", minTemp: 5.0, maxTemp: 15.0, isTop: true),
  Clothing(name: "wool sweater", minTemp: 1.0, maxTemp: 10.0, isTop: true),
  Clothing(name: "suit jacket", minTemp: 15.0, maxTemp: 20.0, isTop: true),
  Clothing(name: "jean jacket", minTemp: 10.0, maxTemp: 18.0, isTop: true),
  Clothing(name: "light down jacket", minTemp: 0.0, maxTemp: 10.0, isTop: true),
  Clothing(name: "down jacket", minTemp: -20.0, maxTemp: 0.0, isTop: true),

  // bottoms
  Clothing(name: "shorts", minTemp: 22.0, maxTemp: 40.0, isTop: false),
  Clothing(name: "trousers", minTemp: 15.0, maxTemp: 25.0, isTop: false),
  Clothing(name: "jeans", minTemp: 12.0, maxTemp: 25.0, isTop: false),
  Clothing(name: "fleece pants", minTemp: 5.0, maxTemp: 15.0, isTop: false),
  Clothing(name: "cotton-wadded trousers", minTemp: 0.0, maxTemp: 10.0, isTop: false),
  Clothing(name: "down pants", minTemp: -20.0, maxTemp: 0.0, isTop: false),
];