import 'package:flutter/material.dart';
import '../model/address_model.dart';
import 'detail_card.dart';
import 'info_tile.dart';

class AddressCard extends StatelessWidget {
  final AddressModel? address;

  const AddressCard({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    if (address == null) return const SizedBox.shrink();

    final streetText = '${address?.suite ?? ''} ${address?.street ?? ''}'.trim();

    return DetailCard(
      title: 'Address',
      children: [
        InfoTile(
          icon: Icons.location_on_outlined,
          label: 'Street',
          value: streetText.isNotEmpty ? streetText : 'N/A',
        ),
        const Divider(height: 1, indent: 48),
        InfoTile(
          icon: Icons.location_city_rounded,
          label: 'City',
          value: address?.city ?? 'N/A',
        ),
        const Divider(height: 1, indent: 48),
        InfoTile(
          icon: Icons.pin_drop_outlined,
          label: 'Zipcode',
          value: address?.zipcode ?? 'N/A',
        ),
        if (address?.geo?.lat != null && address?.geo?.lng != null) ...[
          const Divider(height: 1, indent: 48),
          InfoTile(
            icon: Icons.explore_outlined,
            label: 'Coordinates',
            value: 'Lat: ${address?.geo?.lat}, Lng: ${address?.geo?.lng}',
          ),
        ],
      ],
    );
  }
}
