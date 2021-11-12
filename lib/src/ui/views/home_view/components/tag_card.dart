import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/ui/views/tag_view/tag_view.dart';

class TagCard extends StatelessWidget {
  const TagCard({required this.tag, required this.setState, Key? key}) : super(key: key);

  final Tag tag;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CantonMethods.viewTransition(context, TagView(tag)).then((value) => setState(() {})),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: SmoothBorderRadius(cornerRadius: 5, cornerSmoothing: 1),
        ),
        padding: const EdgeInsets.all(4.0),
        child: Text(
          tag.name!,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(color: CantonColors.white),
        ),
      ),
    );
  }
}
