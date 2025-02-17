import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String hintText;
  final String? defaultValue; // Add a default value

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.hintText,
    this.onChanged,
    this.defaultValue = 'Men', // Set 'Male' as the default value
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: defaultValue, // Set the default value

          hint: Text(
            hintText,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: items.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(
                gender,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
