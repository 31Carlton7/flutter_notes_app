import 'package:canton_design_system/canton_design_system.dart';

class ProfileViewHeader extends StatelessWidget {
  const ProfileViewHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      CantonBackButton(
        isClear: true,
      ),
      Text(
        'Profile',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline5!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
      CantonHeaderButton(
        backgroundColor: CantonColors.transparent,
        icon: Container(),
        onPressed: () {},
      ),
    ]);
  }
}
