import 'package:flutter/material.dart';
import 'package:maze_search_ai/constants.dart';
import 'package:maze_search_ai/providers/home_view_provider.dart';
import 'package:provider/provider.dart';

class GridSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeViewProvider = context.watch<HomeViewProvider>();
    return Padding(
      padding: boxPadding,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: homeViewProvider.columns.toString(),
              decoration: const InputDecoration(labelText: "Amount Columns"),
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return validateNumber(value);
              },
              onChanged: (value) {
                int intValue = int.tryParse(value.trim());
                intValue ??= 1;
                context.read<HomeViewProvider>().updateColumns(intValue);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              validator: (value) {
                return validateNumber(value);
              },
              initialValue: homeViewProvider.rows.toString(),
              decoration: const InputDecoration(labelText: "Amount Rows"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int intValue = int.tryParse(value.trim());
                intValue ??= 1;

                if (intValue > 25) intValue = 25;
                context.read<HomeViewProvider>().updateRows(intValue);
              },
            ),
          )
        ],
      ),
    );
  }

  String validateNumber(String value) {
    final parse = int.tryParse(value.trim());

    if (value == null || value.trim().isEmpty || parse == null) {
      return "Please provide a value";
    }
    if (parse <= 0) {
      return "Please provide a grid length larger than 0";
    }

    if (parse > 25) return "Enter a value below 25";
    return null;
  }
}
