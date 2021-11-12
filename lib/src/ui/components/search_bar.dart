import 'package:canton_design_system/canton_design_system.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.searchNotes, this.tag, this.tagList}) : super(key: key);

  final void Function(String) searchNotes;
  final Tag? tag;
  final List<Widget>? tagList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CantonTextInput(
          obscureText: false,
          isTextFormField: false,
          hintText: 'Search notes',
          radius: (tagList != null && tagList!.isNotEmpty)
              ? const SmoothBorderRadius.vertical(top: const SmoothRadius(cornerRadius: 27, cornerSmoothing: 1))
              : const SmoothBorderRadius.all(const SmoothRadius(cornerRadius: 27, cornerSmoothing: 1)),
          prefixIcon: IconlyIcon(
            IconlyBold.Search,
            size: 20,
            color: Theme.of(context).colorScheme.secondaryVariant,
          ),
          onChanged: (string) {
            searchNotes(string);
          },
        ),
        (tagList != null && tagList!.isNotEmpty)
            ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const SmoothBorderRadius.vertical(
                    bottom: const SmoothRadius(cornerRadius: 10, cornerSmoothing: 1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 26,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: tagList!,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
