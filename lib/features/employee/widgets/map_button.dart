import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapButton extends StatelessWidget {
  final String? latitude;
  final String? longitude;

  const MapButton({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  Future<void> _launchMaps(BuildContext context) async {
    final lat = latitude?.trim();
    final lng = longitude?.trim();

    if (lat == null || lat.isEmpty || lng == null || lng.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location Not Available')),
      );
      return;
    }

    final urlString = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final uri = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open Google Maps.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton.icon(
        onPressed: () => _launchMaps(context),
        icon: const Icon(Icons.map_outlined),
        label: const Text('Open In Google Maps'),
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
