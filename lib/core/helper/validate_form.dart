import 'package:babysitterapp/models/inputfield.dart';

import 'package:form_validator/form_validator.dart';

String? Function(String?) getValidator(InputFieldConfig field) {
  final ValidationBuilder validation = ValidationBuilder()
    ..required('${field.label} is required');

  switch (field.type) {
    case 'email':
      validation.email('Please enter a valid email');
      break;
    case 'text':
    case 'password':
      if (field.minLength != null) {
        validation.minLength(
            field.minLength!, 'Minimum ${field.minLength} characters');
      }
      if (field.maxLength != null) {
        validation.maxLength(
            field.maxLength!, 'Maximum ${field.maxLength} characters');
      }
      break;
  }

  return validation.build();
}
