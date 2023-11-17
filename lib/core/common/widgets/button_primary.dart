part of 'widgets.dart';

class ButtonPrimary extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  const ButtonPrimary({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colours.bluePrimary,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        minWidth: context.width,
        height: 48.0,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colours.white),
              )
            : Text(
                title,
                style: TypographyStyle.semi16.copyWith(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
