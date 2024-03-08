class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

List<ChartData> consolidateChartData(List<ChartData> originalData) {
  var map = <String, double>{};

  for (var data in originalData) {
    var existingY = map[data.x];
    if (existingY != null) {
      // If an entry with this x already exists, add the y value
      map[data.x] = existingY + data.y;
    } else {
      // Otherwise, create a new entry
      map[data.x] = data.y;
    }
  }

  return map.entries.map((e) => ChartData(e.key, e.value)).toList();
}
