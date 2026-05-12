import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/core/router/dialog/dialog_notifier.dart';
import 'package:hiddify/core/router/go_router/helper/active_breakpoint_notifier.dart';
import 'package:hiddify/features/settings/notifier/config_option/config_option_notifier.dart';
import 'package:hiddify/features/settings/notifier/reset_tunnel/reset_tunnel_notifier.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider).requireValue;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          // 1. Account & Subscription Block
          _buildSectionHeader(context, 'Account & Subscription'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Account', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      const Text('user@phantomlink.cc', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      Text('Premium', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Valid until', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                      const Text('Oct 12, 2026', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Gap(24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _launchUrl('https://phantomlink1.netlify.app/dashboard'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Manage Subscription'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(24),

          // 2. Connection & Protocol Block
          _buildSectionHeader(context, 'Connection & Protocol'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.vpn_key_rounded),
                  title: const Text('VPN Protocol'),
                  subtitle: const Text('Automatic (Recommended)'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                     // In the future this can open a modal for VLESS/Reality manual selection
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.route_rounded),
                  title: const Text('Routing Mode'),
                  subtitle: const Text('Global'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.go(context.namedLocation('routeOptions')),
                ),
              ],
            ),
          ),
          const Gap(24),

          // 3. Security Block
          _buildSectionHeader(context, 'Security'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  value: true,
                  onChanged: (val) {},
                  secondary: const Icon(Icons.shield_rounded),
                  title: const Text('Always-on VPN (Kill Switch)'),
                  subtitle: const Text('Blocks internet if VPN connection drops to prevent IP leaks.'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.dns_rounded),
                  title: const Text('DNS Settings'),
                  subtitle: const Text('Automatic'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.go(context.namedLocation('dnsOptions')),
                ),
              ],
            ),
          ),
          const Gap(24),

          // 4. General Block
          _buildSectionHeader(context, 'General'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  value: false,
                  onChanged: (val) {},
                  secondary: const Icon(Icons.power_settings_new_rounded),
                  title: const Text('Auto-Connect on Startup'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text('Language'),
                  subtitle: const Text('English'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.go(context.namedLocation('general')),
                ),
                if (Breakpoint(context).isMobile()) ...[
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.description_rounded),
                    title: Text(t.pages.logs.title),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.go(context.namedLocation('logs')),
                  ),
                ]
              ],
            ),
          ),
          const Gap(24),

          // 5. Legal & Info Block
          _buildSectionHeader(context, 'Legal & Info'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_rounded),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  onTap: () => _launchUrl('https://phantomlink.cc/privacy-policy'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.article_rounded),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  onTap: () => _launchUrl('https://phantomlink.cc/terms-of-service'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.support_agent_rounded),
                  title: const Text('Contact Support'),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  onTap: () => _launchUrl('mailto:support@phantomlink.cc'),
                ),
              ],
            ),
          ),
          
          const Gap(16),
          Center(
            child: Text(
              'PhantomLink v.1.0.0 (Build 12)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
          const Gap(32),

          // 6. Danger Zone Block
          _buildSectionHeader(context, 'Danger Zone', color: Colors.redAccent),
          Card(
            elevation: 0,
            color: Colors.red.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.red.withOpacity(0.2)),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
              title: const Text('Delete Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text('Are you sure? This action is irreversible, and your active subscription will be canceled.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement actual API call to delete user from Marzban
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Account deletion request sent.')),
                          );
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Gap(40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color ?? Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
