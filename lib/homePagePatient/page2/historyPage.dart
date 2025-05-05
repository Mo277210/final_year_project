import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/api/patient_home/history.dart';
import 'package:collogefinalpoject/api/patient_home/patient_info.dart';
import 'package:collogefinalpoject/model/patient_home/history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class Historypage extends StatefulWidget {
  const Historypage({Key? key}) : super(key: key);

  @override
  _HistorypageState createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  late NailApiService _apiService;
  late PatientInfoApiService _patientInfoApiService;
  List<NailImageHistory> _history = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _patientName = '';
  bool _isFetchingPatientInfo = true;
  final Map<int, bool> _expandedItems = {};
  int _currentImageIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tokenProvider = Provider.of<TokenProvider>(context);
    _apiService = NailApiService(tokenProvider.token);
    _patientInfoApiService = PatientInfoApiService();
    _refreshAll();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _apiService.getPatientHistory();
      setState(() {
        _history = history;
        for (int i = 0; i < history.length; i++) {
          _expandedItems[i] = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load history: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPatientInfo(String token) async {
    try {
      final patientInfoResponse =
          await _patientInfoApiService.getPatientInfo(token);
      setState(() {
        _patientName = patientInfoResponse?.data.name != null &&
                patientInfoResponse!.data.name.isNotEmpty
            ? patientInfoResponse.data.name
            : 'Guest';
        _isFetchingPatientInfo = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch patient info: $e';
        _patientName = 'Guest';
        _isFetchingPatientInfo = false;
      });
    }
  }

  Future<void> _refreshAll() async {
    setState(() {
      _isLoading = true;
      _isFetchingPatientInfo = true;
      _errorMessage = '';
    });

    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    await Future.wait([
      _loadHistory(),
      _fetchPatientInfo(tokenProvider.token),
    ]);
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Widget _buildProbabilitiesList(Map<String, double> probabilities, int index) {
    final entries = probabilities.entries.toList();
    final isExpanded = _expandedItems[index] ?? false;
    final showAll = isExpanded || entries.length <= 3;

    // دالة مساعدة لتنسيق النسبة بنفس شكل JSON
    String _formatProbability(double value) {
      if (value == value.toInt()) {
        return value.toInt().toString(); // عرض كعدد صحيح إذا كان العدد صحيحاً
      } else {
        return value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), ''); // إزالة الأصفار غير الضرورية
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Probabilities:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...entries.take(showAll ? entries.length : 3).map((entry) => Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            '${entry.key}: ${_formatProbability(entry.value)}%',
            style: TextStyle(
              color: entry.value > 0 ? Colors.black : Colors.grey,
            ),
          ),
        )),
        if (entries.length > 3)
          TextButton(
            onPressed: () {
              setState(() {
                _expandedItems[index] = !isExpanded;
              });
            },
            child: Text(isExpanded ? 'Show less' : 'Show more'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
      ],
    );
  }

  Widget _buildGraph(Map<String, double> probabilities) {
    final barSpots = probabilities.entries.toList();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(8.0),
      child: BarChart(
        BarChartData(
          maxY: 100,
          barGroups: barSpots.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value.key;
            final value = entry.value.value.clamp(0, 100).toDouble();
            return BarChartGroupData(
              x: index,
              barRods: [
                if (value > 0) // رسم العمود فقط إذا كانت القيمة أكبر من صفر
                  BarChartRodData(
                    toY: value,
                    color: value > 50 ? Colors.green : Colors.red,
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                  )
                else // عرض رمزي للقيم الصفرية
                  BarChartRodData(
                    toY: 0,
                    color: Colors.grey.withOpacity(0.3),
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                  ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= barSpots.length)
                    return const SizedBox();
                  final itemValue = barSpots[index].value;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Transform.rotate(
                      angle: -0.8,
                      child: Text(
                        barSpots[index].key,
                        style: TextStyle(
                          fontSize: 10,
                          color: itemValue > 0 ? Colors.black : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                interval: 1,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                getTitlesWidget: (value, meta) {
                  if (value % 10 == 0) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _isFetchingPatientInfo
                  ? const CircularProgressIndicator()
                  : Text(
                      'Welcome 🖐, $_patientName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_history.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshAll,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 100),
            Center(child: Text('No history available')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshAll,
      child: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final historyItem = _history[index];
          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                setState(() {
                  if (details.primaryVelocity! < 0) {
                    _currentImageIndex = 1;
                  } else if (details.primaryVelocity! > 0) {
                    _currentImageIndex = 0;
                  }
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentImageIndex == 0)
                    historyItem.imageFile.isNotEmpty
                        ? Image.network(
                            historyItem.fullImageUrl,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 300,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.broken_image),
                              ),
                            ),
                          )
                        : Container(
                            height: 300,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
                  if (_currentImageIndex == 1)
                    _buildGraph(historyItem.probabilities),
                  const SizedBox(height: 10),
                  Text(
                    historyItem.diagnosis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatDate(historyItem.createdAt),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Confidence: ${historyItem.confidence.toStringAsFixed(1)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildProbabilitiesList(historyItem.probabilities, index),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}






