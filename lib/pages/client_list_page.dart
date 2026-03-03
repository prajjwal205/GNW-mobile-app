import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/Models/client_model.dart';
import 'package:gnw/services/auth_provider.dart';
import 'package:gnw/widget/customAppBar.dart';
import 'package:gnw/utils/responsive_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'client_detail_page.dart';

/// ✅ Provider for UserName
final userNameProvider = FutureProvider<String>((ref) async {
  return AuthService.fetchUserName();
});

/// ✅ Provider for All Clients
final clientsProvider = FutureProvider<List<ClientModel>>((ref) async {
  return AuthService.fetchAllClients();
});

/// ✅ Search Provider
final searchQueryProvider = StateProvider<String>((ref) => "");

class ClientListPage extends ConsumerWidget {
  final int categoryId;
  final String categoryName;

  const ClientListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  Future<void> _launchUrl(BuildContext context, String url) async {
    if (url.isEmpty) return;

    Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open: $url")),
      );
    }
  }

  Future<void> _callNumber(BuildContext context, String number) async {
    if (number.isEmpty) return;
    await _launchUrl(context, "tel:$number");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameAsync = ref.watch(userNameProvider);
    final clientsAsync = ref.watch(clientsProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return userNameAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),
      data: (userName) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: buildCustomAppBar(
            context,
            userName,
            ResponsiveHelper.getAppBarHeight(context),
          ),
          body: Column(
            children: [
              // ✅ Search Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Search Food...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ref.read(searchQueryProvider.notifier).state = "";
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),

              // ✅ Client List
              Expanded(
                child: clientsAsync.when(
                  loading: () =>
                  const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("Error: $err")),
                  data: (clients) {
                    // ✅ Filter by categoryId
                    List<ClientModel> filteredClients = clients
                        .where((client) =>
                    client.categoryMasterId == categoryId)
                        .toList();

                    // ✅ Search Filter
                    if (searchQuery.isNotEmpty) {
                      filteredClients = filteredClients.where((client) {
                        return client.clientName
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()) ||
                            client.address
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase());
                      }).toList();
                    }

                    if (filteredClients.isEmpty) {
                      return Center(
                        child: Text("No $categoryName found."),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = filteredClients[index];
                        return _buildClientCard(context, client, ref);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClientCard(BuildContext context, ClientModel client, WidgetRef ref) {
    final imageProvider =
    (client.clientImage != null && client.clientImage!.isNotEmpty)
        ? NetworkImage(client.clientImage!)
        : const AssetImage('lib/images/image_21.png') as ImageProvider;

    double screenWidth = MediaQuery.of(context).size.width;

    double avatarRadius = screenWidth < 400 ? 24 : 28;
    double nameFont = screenWidth < 400 ? 14 : 16;
    double addressFont = screenWidth < 400 ? 12 : 13;
    double badgeFont = screenWidth < 400 ? 9 : 10;
    double callRadius = screenWidth < 400 ? 14 : 16;

    return Card(
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClientDetailPage(client: client),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // ✅ IMAGE
              CircleAvatar(
                radius: avatarRadius,
                backgroundImage: imageProvider,
              ),

              const SizedBox(width: 12),

              // ✅ DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Name + Badge + Call Icon
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  client.clientName,
                                  style: TextStyle(
                                    fontSize: nameFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(width: 6),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                  client.isActive ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  client.isActive ? "OPEN" : "CLOSED",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: badgeFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        InkWell(
                          onTap: () {
                            _callNumber(context, client.phoneNumber ?? "");
                          },
                          child: CircleAvatar(
                            radius: callRadius,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                              size: callRadius + 2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // ✅ Address
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            client.address,
                            style: TextStyle(
                              fontSize: addressFont,
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
