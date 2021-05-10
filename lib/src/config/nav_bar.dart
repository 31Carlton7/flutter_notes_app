import 'package:canton_design_system/canton_design_system.dart';
import 'package:notes_app/src/ui/views/profile_view.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:notes_app/src/ui/views/home_view.dart';

class CurrentScreen extends StatefulWidget {
  @override
  _CurrentScreenState createState() => _CurrentScreenState();
}

class _CurrentScreenState extends State<CurrentScreen> {
  @override
  Widget build(BuildContext context) {
    final _controller = PersistentTabController();

    final List<Widget> views = [
      HomeView(),
      ProfileView(),
    ];

    List<PersistentBottomNavBarItem> _navBarsItems(int index) {
      Color activeHome() {
        if (index == 0) {
          return Theme.of(context).primaryColor;
        } else {
          return CantonColors.textTertiary;
        }
      }

      Color activeProfile() {
        if (index == 1) {
          return Theme.of(context).primaryColor;
        } else {
          return CantonColors.textTertiary;
        }
      }

      return [
        PersistentBottomNavBarItem(
          icon: IconlyIcon(IconlyBold.Home, size: 24, color: activeHome()),
          title: '',
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: cantonGrey[500],
        ),
        PersistentBottomNavBarItem(
          icon: IconlyIcon(IconlyBold.Profile, color: activeProfile()),
          title: '',
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: cantonGrey[500],
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: _controller,
      screens: views,
      backgroundColor: cantonGrey[100],
      resizeToAvoidBottomInset: true,
      navBarStyle: NavBarStyle.style12,
      navBarHeight: MediaQuery.of(context).size.height / 16,
      onItemSelected: (index) {
        this.setState(() {
          _navBarsItems(_controller.index);
        });
      },
      decoration: NavBarDecoration(
        colorBehindNavBar: cantonGrey[100],
      ),
      items: _navBarsItems(_controller.index),
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
    );
  }
}
