class Clothing {
  final String name;
  final double minTemp;
  final double maxTemp;
  final bool isTop;

  const Clothing({
    required this.name,
    required this.minTemp,
    required this.maxTemp,
    required this.isTop,
  });

  // 区间重叠检测方法
  bool matchesRange(double dayMin, double dayMax) {
  // 自动处理温度顺序
  final lowerDay = dayMin < dayMax ? dayMin : dayMax;
  final upperDay = dayMin > dayMax ? dayMin : dayMax;

  return (lowerDay <= maxTemp) && (minTemp <= upperDay);
}
}
