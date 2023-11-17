part of 'widgets.dart';

class AppbarPrimary extends StatelessWidget implements PreferredSize {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool backButton;

  const AppbarPrimary({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
    this.backButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: backButton,
      elevation: 0,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(
        color: Colours.black,
      ),
      title: Text(
        title,
        style: TypographyStyle.semi16,
      ),
      actions: actions,
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(48);
}
