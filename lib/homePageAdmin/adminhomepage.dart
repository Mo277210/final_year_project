import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Increase AppBar height
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'Nägel',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontFamily: 'Inter Tight',
              color: Color(0xFF105DFB),
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: Container(
        color: Colors.grey[50], // Set background color for the entire page
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            Expanded(
              child: SingleChildScrollView(
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
                    ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _buildDoctorCard(
                          context,
                          name: 'Dr. Sarah Johnson',
                          specialty: 'Dermatologist',
                          phone: '+1 (555) 123-4567',
                          email: 'dr.sarah@example.com',
                          image: 'assets/google-school-of-medicine.jpg',
                        ),
                        SizedBox(height: 16),
                        _buildDoctorCard(
                          context,
                          name: 'Dr. Michael Chen',
                          specialty: 'Cardiologist',
                          phone: '+1 (555) 987-6543',
                          email: 'dr.chen@example.com',
                          image: 'assets/Dr-Ordog-California-Medical-License-first-in-1980-finished-2018.png',
                        ),
                        SizedBox(height: 16),
                        _buildDoctorCard(
                          context,
                          name: 'Dr. Emily Rodriguez',
                          specialty: 'Neurologist',
                          phone: '+1 (555) 456-7890',
                          email: 'dr.rodriguez@example.com',
                          image: 'assets/google-school-of-medicine.jpg',
                        ),
                      ],
                    ),
                  ],
                ),
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
        required String specialty,
        required String phone,
        required String email,
        required String image,
      }) {
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
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: 'Inter Tight',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        specialty,
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
                      Icon(Icons.phone, size: 20, color: Color(0xFF105DFB)), // Phone icon
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                                fontWeight:  FontWeight.bold,

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
                SizedBox(width: 16), // Reduced spacing
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.email, size: 20, color:Color(0xFF105DFB)), // Email icon
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                                fontWeight:  FontWeight.bold,

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
              'Medical License',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image, // Use the asset image
                width: double.infinity,
                height: 250, // Increase image height
                fit: BoxFit.cover,
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

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminHomePage(),
  ));
}