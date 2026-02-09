import 'package:flutter/material.dart';
import 'package:gnw/Models/client_model.dart';
import 'package:gnw/providers/auth_provider.dart';
import '../widget/customAppBar.dart';
import '../utils/responsive_helper.dart';

class ClientListPage extends StatefulWidget {
  final int categoryId; // The ID of the category clicked (e.g., 2 for Food)
  final String categoryName; // "Food", "Shopping", etc.

  const ClientListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  late Future<String> _userNameFuture;
  late Future<List<ClientModel>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _userNameFuture = AuthService.fetchUserName();
    _clientsFuture = AuthService.fetchAllClients();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _userNameFuture,
      builder: (context, userSnapshot) {
        String userName = userSnapshot.data ?? "Prajjwal";
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: buildCustomAppBar(
              context, userName, ResponsiveHelper.getAppBarHeight(context)),
          body: FutureBuilder<List<ClientModel>>(
            future: _clientsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No data available"));
              }

              // --- FILTER LOGIC ---
              // Show only clients that match the clicked Category ID
              final filteredClients = snapshot.data!.where((client) {
                return client.categoryMasterId == widget.categoryId;
              }).toList();

              if (filteredClients.isEmpty) {
                return Center(
                    child: Text("No ${widget.categoryName} spots found."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  final client = filteredClients[index];
                  return ListTile(
                    leading: client.clientImage == null
                        ? Text("No image")
                        : null,
                    title: Text(
                      client.clientName,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(client.address,),
                        const SizedBox(height: 4),
                        Text(client.phoneNumber,),
                        const SizedBox(height: 4),
                        Text(client.location),
                        const SizedBox(height: 4),
                        Text(client.email),
                        const SizedBox(height: 4),
                        Text(" Contact person: ${client.contactPerson}"),

                      ],
                    ),

                  );
                },
              );
            },
          ),
        );
      }
    );
  }
}