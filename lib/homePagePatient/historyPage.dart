import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/api/patient_setting/history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:collogefinalpoject/model/patient_setting/history.dart';


class Historypage extends StatefulWidget {
  const Historypage({Key? key}) : super(key: key);

  @override
  _HistorypageState createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  late NailApiService _apiService;
  List<NailImageHistory> _history = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tokenProvider = Provider.of<TokenProvider>(context);
    _apiService = NailApiService(tokenProvider.token);
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _apiService.getPatientHistory();
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load history: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_history.isEmpty) {
      return Center(child: Text('No history available'));
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final historyItem = _history[index];
          return Container(
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
                historyItem.imageFile.isNotEmpty
                    ? Image.network(
                  historyItem.fullImageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.broken_image),
                    ),
                  ),
                )
                    : Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.image_not_supported),
                  ),
                ),
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
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Confidence: ${(historyItem.confidence * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Probabilities:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...historyItem.probabilities.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      '${entry.key}: ${(entry.value * 100).toStringAsFixed(1)}%',
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}