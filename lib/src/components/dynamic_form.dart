import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

import 'package:babysitterapp/src/components.dart';
import 'package:babysitterapp/src/constants.dart';

import 'package:babysitterapp/src/models.dart';

class DynamicForm extends HookConsumerWidget {
  DynamicForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    this.isLoading,
    this.initialData,
    this.userId,
  });

  final List<InputFieldConfig> fields;
  final void Function(Map<String, dynamic>) onSubmit;
  final ValueNotifier<bool>? isLoading;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final Map<String, dynamic>? initialData;
  final String? userId;

  static const double _borderRadius = 12.0;

  InputDecoration _getInputDecoration(InputFieldConfig field) {
    return InputDecoration(
      labelText: field.label,
      hintText: field.hintText,
      prefixIcon: Icon(field.prefixIcon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: GlobalStyles.primaryButtonColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget buildFormField(BuildContext context, InputFieldConfig field) {
    final dynamic initialValue = initialData?[field.label] ?? field.value;

    if (field.type == 'image') {
      return ImageField(
        name: field.label,
        decoration: _getInputDecoration(field),
        userId: userId ?? '',
        initialValue: initialValue as String?,
        onChanged: (String? url) {
          if (url != null) {
            _formKey.currentState?.fields[field.label]?.didChange(url);
          }
        },
      );
    }

    switch (field.type) {
      case 'select':
        return FormBuilderDropdown<String>(
          name: field.label,
          decoration: _getInputDecoration(field),
          initialValue: initialValue as String?,
          items: field.options
                  ?.map((String option) => DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      ))
                  .toList() ??
              <DropdownMenuItem<String>>[],
          validator: FormBuilderValidators.required(),
        );

      case 'file':
        return FormBuilderFilePicker(
          name: field.label,
          decoration: _getInputDecoration(field),
          maxFiles: 1,
          typeSelectors: const <TypeSelector>[
            TypeSelector(
              type: FileType.custom,
              selector: Text('Select File'),
            ),
          ],
          allowedExtensions: const <String>['jpg', 'png', 'pdf'],
          onChanged: (List<PlatformFile>? val) {},
          withData: true,
        );

      case 'password':
        final ValueNotifier<bool> showPassword = useState(false);
        return FormBuilderTextField(
          name: field.label,
          obscureText: !showPassword.value,
          decoration: _getInputDecoration(field).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                showPassword.value
                    ? FluentIcons.eye_off_24_regular
                    : FluentIcons.eye_24_regular,
                size: 20,
              ),
              onPressed: () => showPassword.value = !showPassword.value,
            ),
          ),
          initialValue: initialValue as String?,
          validator: FormBuilderValidators.compose(<FormFieldValidator<String>>[
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(6),
          ]),
        );

      case 'email':
        return FormBuilderTextField(
          name: field.label,
          decoration: _getInputDecoration(field),
          initialValue: initialValue as String?,
          keyboardType: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose(<FormFieldValidator<String>>[
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        );

      default:
        return FormBuilderTextField(
          name: field.label,
          decoration: _getInputDecoration(field),
          initialValue: initialValue as String?,
          validator: field.isRequired ? FormBuilderValidators.required() : null,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 24),
          ...fields.map(
            (InputFieldConfig field) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: buildFormField(context, field),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading?.value ?? false
                  ? null
                  : () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        onSubmit(_formKey.currentState!.value);
                      }
                    },
              child: isLoading?.value ?? false
                  ? const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        color: GlobalStyles.primaryButtonColor,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
