import 'package:flutter/material.dart';

class CustomDropdownToSelectGender extends StatelessWidget {
  final String label;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String hintText;
  final String? defaultValue;

  const CustomDropdownToSelectGender({
    super.key,
    required this.label,
    required this.items,
    required this.hintText,
    this.onChanged,
    this.defaultValue = 'Male',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///please use label text here for Text() which is your custom component

        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: defaultValue,
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
