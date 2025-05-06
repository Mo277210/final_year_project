import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:collogefinalpoject/model/patient_home/history.dart';

class DiseaseChartPage extends StatefulWidget {
  final List<NailImageHistory> history;

  const DiseaseChartPage({Key? key, required this.history}) : super(key: key);

  @override
  State<DiseaseChartPage> createState() => _DiseaseChartPageState();
}

class _DiseaseChartPageState extends State<DiseaseChartPage> {
  late String selectedDisease;

  final List<String> diseasesList = [
    'Acral Lentiginous Melanoma',
    'Blue Finger',
    'Beaus Line',
    'Clubbing',
    'Koilonychia',
    'Muehrckes Lines',
    'Pitting',
    'Terrys Nail',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.history.isNotEmpty) {
      // Select the diagnosis of the first item in history
      selectedDisease = widget.history.first.diagnosis;
    } else {
      selectedDisease = 'Pitting'; // fallback value if history is empty
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedDisease Chart'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedDisease = value;
              });
            },
            itemBuilder: (context) {
              return diseasesList.map((disease) {
                return PopupMenuItem<String>(
                  value: disease,
                  child: Text(disease),
                );
              }).toList();
            },
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('History chart for $selectedDisease'),
            const SizedBox(height: 20),
            Expanded(
              child: _buildLineChart(selectedDisease),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(String diseaseName) {
    List<FlSpot> spots = [];
    double minY = double.infinity;
    double maxY = -double.infinity;

    // Collecting the spots and calculating min/max Y values for dynamic scaling
    for (int i = 0; i < widget.history.length; i++) {
      final item = widget.history[i];
      if (item.probabilities.containsKey(diseaseName)) {
        double value = item.probabilities[diseaseName] ?? 0;
        spots.add(FlSpot(i.toDouble(), value));

        // Update min and max Y values for dynamic scaling
        minY = value < minY ? value : minY;
        maxY = value > maxY ? value : maxY;
      }
    }

    // Ensure the Y-axis range is always within bounds (e.g., 0-100) and add some padding
    minY = minY > 0 ? minY : 0;
    maxY = maxY < 100 ? maxY : 100;

    // Adding some padding
    double yPadding = (maxY - minY) * 0.1; // 10% padding
    minY = minY - yPadding > 0 ? minY - yPadding : 0;
    maxY = maxY + yPadding < 100 ? maxY + yPadding : 100;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: spots.isNotEmpty ? spots.length - 1 : 1,
        minY: minY,
        maxY: maxY,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                if (index >= 0 && index < widget.history.length) {
                  return Transform.rotate(
                    angle: -0.8,
                    child: Text(
                      DateFormat('dd MMM').format(widget.history[index].createdAt),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                final date = DateFormat('dd MMM yyyy').format(widget.history[index].createdAt);
                final value = spot.y.toStringAsFixed(1);
                return LineTooltipItem(
                  '$date\n$value%',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList();
            },
          ),
          touchCallback: (event, response) {},
          handleBuiltInTouches: true,
        ),
      ),
    );
  }

}
