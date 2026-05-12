import 'package:hiddify/features/profile/notifier/active_profile_notifier.dart';
import 'package:hiddify/features/profile/model/profile_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SubscriptionTier { free, premium }

final subscriptionTierProvider = Provider<SubscriptionTier>((ref) {
  final activeProfile = ref.watch(activeProfileProvider).valueOrNull;
  if (activeProfile == null) return SubscriptionTier.free;

  final name = activeProfile.name.toLowerCase();
  final url = activeProfile is RemoteProfileEntity ? activeProfile.url.toLowerCase() : '';
  
  print('DEBUG PROFILE: name=$name, url=$url');
  
  // Check if the profile name or user info explicitly indicates a free tier
  if (name.contains('free_') || name.contains('free-') || name.contains('free ') || url.contains('free_')) {
    return SubscriptionTier.free;
  }
  
  return SubscriptionTier.premium;
});
