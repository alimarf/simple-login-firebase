part of 'widgets.dart';

class CustomPin extends StatelessWidget {
  final Function(String)? onCompleted;

  const CustomPin({
    super.key,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 6,
      keyboardType: TextInputType.number,
      onCompleted: onCompleted,
      defaultPinTheme: PinTheme(
        height: 56,
        width: 48,
        textStyle: TypographyStyle.semi18,
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colours.bluePrimary),
        ),
      ),
      errorPinTheme: PinTheme(
        height: 56,
        width: 48,
        textStyle: TypographyStyle.semi18,
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colours.errorDark),
        ),
      ),
      focusedPinTheme: PinTheme(
        height: 56,
        width: 48,
        textStyle: TypographyStyle.semi18,
        decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colours.bluePrimary),
        ),
      ),
    );
  }
}
