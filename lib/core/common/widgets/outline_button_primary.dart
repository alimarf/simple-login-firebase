part of 'widgets.dart';

class OutlineButtonPrimary extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;

  const OutlineButtonPrimary({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colours.white,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colours.bluePrimary,
          )),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        minWidth: context.width,
        height: 20.0,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colours.white),
              )
            : Text(
                title,
                style: TypographyStyle.semi12.copyWith(
                  color: Colours.bluePrimary,
                ),
              ),
      ),
    );
  }
}
