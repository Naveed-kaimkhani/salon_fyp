import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final bool isPhoneNumber;
  final Widget? suffixIcon;
  final bool isPasswordField, readOnly;
  final String? Function(String?)? validator; // Add validator
  final int maxline;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  CustomTextField({
    super.key,
    this.label = "",
    required this.hint,
    required this.controller,
    this.currentFocusNode,
    this.nextFocusNode,
    this.isPhoneNumber = false,
    this.suffixIcon,
    this.isPasswordField = false,
    this.readOnly = false,
    this.validator, // Accept validator
    this.maxline = 1,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
  });

  final PasswordController passwordController = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          text: label,
          fontSize: 14,
          weight: FontWeight.w400,
        ),
        const Gap(5),
        FormField<String>(
          validator: validator, // Apply the validator
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller,
                  focusNode: currentFocusNode,
                  readOnly: readOnly,
                  textInputAction: nextFocusNode != null
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (nextFocusNode != null) {
                      FocusScope.of(context).requestFocus(nextFocusNode);
                    } else {
                      currentFocusNode?.unfocus();
                    }
                  },
                  maxLength: maxLength,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 16),
                  decoration: InputDecoration(
                    prefixIcon: isPhoneNumber
                        ? CountryCodePicker(
                            showDropDownButton: true,
                            showFlag: false,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 16),
                            initialSelection: 'IL',
                            onChanged: (country) {
                              log("Selected country: ${country.dialCode}");
                            },
                          )
                        : null,
                    hintText: hint,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 16, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: isPasswordField
                        ? Obx(
                            () => IconButton(
                              icon: Icon(
                                passwordController.isObscure.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: passwordController.toggleVisibility,
                            ),
                          )
                        : suffixIcon,
                    errorText: field.errorText,
                  ),
                  maxLines: maxline,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  validator: validator,
                  obscureText: isPasswordField
                      ? passwordController.isObscure.value
                      : false,
                  onChanged: (value) {
                    field.didChange(value);
                    if (onChanged != null) {
                      onChanged!(value);
                    }
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
