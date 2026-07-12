import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/Models/Sponsor_model.dart';
import 'package:gnw/services/auth_provider.dart';

final sponsorNotifierProvider = AsyncNotifierProvider<SponsorNotifier, List<SponsorModel>>(() {
  return SponsorNotifier();
});

class SponsorNotifier extends AsyncNotifier<List<SponsorModel>> {
  @override
  Future<List<SponsorModel>> build() async {
    // 1. Cache se data check karo
    final cached = await AuthService.getCachedSponsors();

    // 2. Agar cache mein data HAI, toh turant return karo (Instant Load)
    if (cached != null && cached.isNotEmpty) {
      _fetchFreshDataInBackground(); // Background mein naya data laate raho
      return cached;
    }
    // 3. Agar cache KHALI hai (First time install), toh API ka wait karo!
    else {
      return await _fetchInitialData();
    }
  }

  // Ye tab chalega jab cache purana ho
  Future<void> _fetchFreshDataInBackground() async {
    try {
      final fresh = await AuthService.fetchSponsor();
      state = AsyncValue.data(fresh);
      await AuthService.cacheSponsors(fresh);
    } catch (e) {
      // Error aaye toh purana cache hi rehne do
    }
  }

  // Ye tab chalega jab app pehli baar khulegi
  Future<List<SponsorModel>> _fetchInitialData() async {
    try {
      final fresh = await AuthService.fetchSponsor();
      await AuthService.cacheSponsors(fresh);
      return fresh;
    } catch (e) {
      return []; // Agar API fail ho jaye toh empty list return karo taaki app crash na ho
    }
  }
}