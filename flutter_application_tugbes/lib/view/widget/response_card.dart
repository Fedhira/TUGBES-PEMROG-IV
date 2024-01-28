import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';

class ResponseCard extends StatelessWidget {
  final DataResponse res;
  final Function() onDismissed;

  const ResponseCard({Key? key, required this.res, required this.onDismissed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Dismissible(
        key: Key(res.message),
        onDismissed: (direction) {
          onDismissed();
        },
        background: Container(
          color: Colors.transparent,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.greenAccent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (res.insertedId != null)
                _buildDataRow('Inserted ID', res.insertedId),
              _buildDataRow('Message', res.message),
              _buildDataRow('Status', res.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10), // Jarak antara label dan titik dua
        Expanded(
          child: Text(
            ': $value',
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
