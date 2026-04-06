import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/features/home/presentation/view/home_view.dart';
import 'package:test_graduation/features/my_properties/presentation/views/my_properties_view.dart';
import 'package:test_graduation/features/profile/presentation/views/profile_view.dart';
import 'package:test_graduation/features/search/presentation/veiw/search_screen.dart';
import 'package:test_graduation/features/root/presentation/views/widgets/custom_bottom_navigation_bar.dart';

// 🔥 الكيوبيت لخدمة كافة التطبيق (الانتقال بين التبويبات)
class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);
  void changeIndex(int index) => emit(index);
}

class RootView extends StatelessWidget {
  const RootView({super.key});

  final List<Widget> screens = const [
    HomeScreen(),
    SearchScreen(),
    MyPropertiesScreen(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    // 🔥 الاستماع للكيوبيت الموفر عالمياً في main.dart
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: IndexedStack(index: currentIndex, children: screens),
          bottomNavigationBar: CustomBottonNavigationBar(
            selectedIndex: currentIndex,
            onTap: (index) =>
                context.read<NavigationCubit>().changeIndex(index),
          ),
        );
      },
    );
  }
}
