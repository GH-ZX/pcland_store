import 'package:flutter/material.dart';
import '../services/app_localizations.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final List<Map<String, String>> addresses = [
      {
        'title': localizations.translate('home'),
        'address': localizations.translate('syria_idlib'),
      },
      {
        'title': localizations.translate('work'),
        'address': localizations.translate('syria_aleppo_azaz'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('my_addresses')),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final address = addresses[index];
          return ListTile(
            leading: Icon(
              Icons.location_on,
              color: Colors.blue.shade700,
              size: 32,
            ),
            title: Text(
              address['title']!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              address['address']!,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                // يمكنك إضافة وظيفة تعديل العنوان هنا
              },
            ),
            onTap: () {
              // يمكنك إضافة وظيفة عند النقر على العنوان هنا
            },
          );
        },
      ),
    );
  }
}
