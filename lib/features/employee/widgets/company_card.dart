import 'package:flutter/material.dart';
import '../model/company_model.dart';
import 'detail_card.dart';
import 'info_tile.dart';

class CompanyCard extends StatelessWidget {
  final CompanyModel? company;

  const CompanyCard({super.key, this.company});

  @override
  Widget build(BuildContext context) {
    if (company == null) return const SizedBox.shrink();

    return DetailCard(
      title: 'Company',
      children: [
        InfoTile(
          icon: Icons.business_rounded,
          label: 'Company Name',
          value: company?.name ?? 'N/A',
        ),
        const Divider(height: 1, indent: 48),
        InfoTile(
          icon: Icons.lightbulb_outline_rounded,
          label: 'Catch Phrase',
          value: company?.catchPhrase ?? 'N/A',
        ),
        const Divider(height: 1, indent: 48),
        InfoTile(
          icon: Icons.work_outline_rounded,
          label: 'Business Scope',
          value: company?.bs ?? 'N/A',
        ),
      ],
    );
  }
}
