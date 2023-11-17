part of 'widgets.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final int? maxLength;
  final bool readOnly;
  final bool? obscureText;
  final VoidCallback? toggleObscure;
  final VoidCallback? onTap;

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.prefix,
    this.maxLength,
    this.readOnly = false,
    this.obscureText,
    this.toggleObscure,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      textInputAction: textInputAction,
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: textInputType,
      validator: validator,
      maxLength: maxLength,
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      
      style: TypographyStyle.regular12,
      decoration: InputDecoration(
        prefix: prefix,
        counterText: "",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          label,
          style: TypographyStyle.semi16
              .copyWith(color: Colours.black, fontSize: 18),
        ),
        hintText: hint,
        hintStyle: TypographyStyle.regular12.copyWith(color: Colours.grey),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colours.grey),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colours.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colours.grey),
        ),
        // suffixIcon: obscureText != null
        //     ? IconButton(
        //         icon: Icon(
        //           obscureText == true
        //               ? Icons.visibility_off_outlined
        //               : Icons.visibility_outlined,
        //           color: Colours.grey,
        //           size: 24,
        //         ),
        //         onPressed: toggleObscure,
        //       )
        //     : null,
      ),
    );
  }
}
