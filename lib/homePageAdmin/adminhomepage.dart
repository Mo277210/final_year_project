import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/admin/admin_home_api.dart';
import '../api/doctor_setting_api/edit_email.dart';
import '../login/loginScreenAdmin.dart';
import '../model/admin_home.dart';
import '../model/admin/Approve.dart';
import '../model/admin/Reject.dart';
import '../model/doctor_setting_model/edit_email.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late Future<List<PendedDoctorModel>> _pendedDoctorsFuture;
  final adminAPIService _apiService = adminAPIService();
  final DoctorEditEmailAPIService _emailService = DoctorEditEmailAPIService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _refreshDoctorsList();
    await Future.delayed(const Duration(milliseconds: 100));
    _refreshIndicatorKey.currentState?.show();
  }

  Future<void> _refreshDoctorsList() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    setState(() {
      _pendedDoctorsFuture = _apiService.showPendedDoctors(tokenProvider.token);
    });
  }

  Future<void> _rejectDoctor(int doctorId) async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    try {
      final response = await _apiService.rejectDoctor(
        token: tokenProvider.token,
        doctorId: doctorId,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        await _refreshDoctorsList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject doctor: ${response.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting doctor: $e')),
      );
    }
  }

  Future<void> _approveDoctor(int doctorId) async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    try {
      final response = await _apiService.approveDoctor(
        token: tokenProvider.token,
        doctorId: doctorId,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        await _refreshDoctorsList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to approve doctor: ${response.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving doctor: $e')),
      );
    }
  }

  Future<void> _editDoctorEmail(int doctorId, String currentEmail) async {
    final newEmailController = TextEditingController(text: currentEmail);
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Doctor Email'),
        content: TextField(
          controller: newEmailController,
          decoration: const InputDecoration(
            labelText: 'New Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, newEmailController.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != currentEmail) {
      try {
        final response = await _emailService.editEmail(
          token: tokenProvider.token,
          newEmail: result,
          doctorId: doctorId,
        );

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
          await _refreshDoctorsList();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update email: ${response.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating email: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              '     Nägel',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: 'Inter Tight',
                color: const Color(0xFF105DFB),
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app, color: Color(0xFF105DFB)),
              onPressed: () {
                Provider.of<TokenProvider>(context, listen: false).setToken('');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreenAdmin()),
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
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refreshDoctorsList,
                color: const Color(0xFF105DFB),
                backgroundColor: Colors.white,
                strokeWidth: 3.0,
                child: FutureBuilder<List<PendedDoctorModel>>(
                  future: _pendedDoctorsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text(
                              "No pended doctors found",
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: _refreshDoctorsList,
                              child: const Text('Refresh'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            sliver: SliverToBoxAdapter(
                              child: Text(
                                'Doctor Requests',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontFamily: 'Inter Tight',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final doctor = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildDoctorCard(
                                    context,
                                    doctor: doctor,
                                    onReject: () => _rejectDoctor(doctor.id),
                                    onApprove: () => _approveDoctor(doctor.id),
                                  ),
                                );
                              },
                              childCount: snapshot.data!.length,
                            ),
                          ),
                        ],
                      );
                    }
                  },
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
        required PendedDoctorModel doctor,
        required VoidCallback onReject,
        required VoidCallback onApprove,
      }) {
    String proofUrl = "https://nagel-production.up.railway.app${doctor.proof}";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                        "Dr.${doctor.name}",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: 'Inter Tight',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialization,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.phone, size: 20, color: Color(0xFF105DFB)),
                      const SizedBox(width: 8),
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
                            const SizedBox(height: 4),
                            Text(
                              doctor.phone,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.email, size: 20, color: Color(0xFF105DFB)),
                      const SizedBox(width: 8),
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
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    doctor.email,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed: () => _editDoctorEmail(doctor.id, doctor.email),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Medical License Proof',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: doctor.proof.startsWith('/tmp/')
                  ? const Center(
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
                  return const Center(
                    child: Text(
                      'Unable to load image',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5F5F5),
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(100, 40),
                  ),
                  child: const Text('Reject'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF249689),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(100, 40),
                  ),
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}