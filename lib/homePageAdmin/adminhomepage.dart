import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../  provider/provider.dart';
import '../api/admin_home_api.dart'; // Import the APIService
import '../login/loginScreenAdmin.dart';
import '../model/admin_home.dart'; // Import the PendedDoctorModel


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late Future<List<PendedDoctorModel>> _pendedDoctorsFuture;
  final APIService _apiService = APIService();

  @override
  void initState() {
    super.initState();
    // Access the token from TokenProvider
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    _pendedDoctorsFuture = _apiService.showPendedDoctors(tokenProvider.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Increase AppBar height
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Nägel',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: 'Inter Tight',
                color: Color(0xFF105DFB),
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Color(0xFF105DFB)), // Exit icon
              onPressed: () {
                // Clear the token when logging out
                Provider.of<TokenProvider>(context, listen: false).setToken('');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreenAdmin()),
                );
              },
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            Expanded(
              child: FutureBuilder<List<PendedDoctorModel>>(
                future: _pendedDoctorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No pended doctors found."));
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            child: Text(
                              'Doctor Requests',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontFamily: 'Inter Tight',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final doctor = snapshot.data![index];
                              return Column(
                                children: [
                                  _buildDoctorCard(
                                    context,
                                    name: doctor.name,
                                    specialization: doctor.specialization,
                                    phone: doctor.phone,
                                    email: doctor.email,
                                    proof: doctor.proof,
                                  ),
                                  SizedBox(height: 16), // Add space between cards
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(
      BuildContext context, {
        required String name,
        required String specialization,
        required String phone,
        required String email,
        required String proof,
      }) {
    String proofUrl = "https://nagel-production.up.railway.app$proof";

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white, // White background for the card
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr.$name",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: 'Inter Tight',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        specialization,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 24, thickness: 1),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 20, color: Color(0xFF105DFB)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              phone,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.email, size: 20, color: Color(0xFF105DFB)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              email,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Medical License Proof',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: proof.startsWith('/tmp/')
                  ? Center(
                child: Text(
                  'Proof image not available',
                  style: TextStyle(color: Colors.red),
                ),
              )
                  : Image.network(
                proofUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Unable to load image',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('Reject pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF5F5F5),
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(100, 40),
                  ),
                  child: Text('Reject'),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    print('Accept pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF249689),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(100, 40),
                  ),
                  child: Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}