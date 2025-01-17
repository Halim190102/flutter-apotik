import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/index_riverpod.dart';
import 'package:apotik_online/feature/presentation/screen/admin/drugs_list.dart';
import 'package:apotik_online/feature/presentation/screen/admin/patients_list.dart';
import 'package:apotik_online/feature/presentation/screen/admin/orders_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Admin extends ConsumerStatefulWidget {
  const Admin({super.key});

  @override
  ConsumerState<Admin> createState() => _AdminState();
}

class _AdminState extends ConsumerState<Admin> {
  bool setting = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final authWatch = ref.watch(authProvider);

    final adminIndex = ref.watch(adminRiverpod);
    return Scaffold(
      backgroundColor: lightGrey,
      key: scaffoldKey,
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          setState(() {
            setting = false;
          });
        }
      },
      drawer: _drawer(context, authWatch, size),
      appBar: _appBar(authWatch),
      body: IndexedStack(
        index: adminIndex,
        children: const [DrugsList(), PatientsList(), OrdersList()],
      ),
    );
  }

  AppBar _appBar(AuthProvider authWatch) {
    return AppBar(
      backgroundColor: lightGreen,
      elevation: 20,
      title: textUtils(text: 'Apotik Online'),
      leading: IconButton(
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
        icon: imageNetwork(
          '$baseUrl/${authWatch.profile?.profilepict}',
          50,
          Icons.person,
        ),
      ),
    );
  }

  Drawer _drawer(
    BuildContext context,
    AuthProvider authWatch,
    Size size,
  ) {
    return Drawer(
      backgroundColor: red,
      width: size.width * .5,
      child: Column(
        children: [
          _buildDrawerHeader(authWatch),
          listTile(
            onTap: () {
              ref.read(adminRiverpod.notifier).state = 0;
              scaffoldKey.currentState?.closeDrawer();
            },
            leading: Icons.medical_information,
            title: 'List of Drugs',
            color: white,
            settings: false,
          ),
          listTile(
            onTap: () {
              ref.read(adminRiverpod.notifier).state = 1;
              scaffoldKey.currentState?.closeDrawer();
            },
            leading: Icons.group,
            title: 'List of Patient',
            color: white,
            settings: false,
          ),
          listTile(
            onTap: () {
              ref.read(adminRiverpod.notifier).state = 2;
              scaffoldKey.currentState?.closeDrawer();
            },
            leading: Icons.list_alt,
            title: 'List of Orders',
            color: white,
            settings: false,
          ),
          _settings(context),
          listTile(
            settings: false,
            onTap: () {
              if (mounted) {
                ref.read(authProvider.notifier).logout();
              }
            },
            leading: Icons.logout,
            title: 'Logout',
            color: white,
          )
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(AuthProvider authWatch) {
    return UserAccountsDrawerHeader(
      accountName: textUtils(
          text: authWatch.profile?.name ?? '', weight: FontWeight.bold),
      accountEmail: textUtils(text: 'Welcome back!', size: 12),
      currentAccountPicture: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/full_image');
        },
        child: imageNetwork(
          '$baseUrl/${authWatch.profile?.profilepict}',
          50,
          Icons.person,
        ),
      ),
    );
  }

  Widget _settings(BuildContext context) {
    return containerUtils(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.all(4),
      borderRadius: setting ? 16 : null,
      color: setting ? const Color.fromARGB(255, 210, 210, 210) : null,
      child: Column(
        children: [
          listTile(
            onTap: () {
              setState(() {
                setting = !setting;
              });
            },
            leading: Icons.settings,
            title: 'Settings',
            trailing: AnimatedRotation(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              turns: setting ? 0.5 : 0.0,
              child: Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: setting ? black : white,
              ),
            ),
            color: setting ? black : white,
            settings: true,
          ),
          _subSettings(context),
        ],
      ),
    );
  }

  AnimatedOpacity _subSettings(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      opacity: setting ? 1.0 : 0.0,
      child: setting
          ? Column(children: [
              ..._buildSettingOptions([
                {
                  'title': 'Change Name',
                  'icon': Icons.abc,
                  'onTap': () {
                    Navigator.pushNamed(context, '/name_change');
                  },
                },
                {
                  'title': 'Change Password',
                  'icon': Icons.password,
                  'onTap': () {
                    Navigator.pushNamed(context, '/password_change');
                  }
                },
              ])
            ])
          : const SizedBox.shrink(),
    );
  }

  List _buildSettingOptions(List<Map<String, dynamic>> options) {
    return options.map((option) {
      return containerUtils(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: listTile(
          onTap: option['onTap'],
          leading: option['icon'],
          title: option['title'],
          color: black,
          settings: true,
        ),
      );
    }).toList();
  }

  listTile({
    required void Function() onTap,
    required IconData leading,
    required String title,
    Widget? trailing,
    required Color color,
    required bool settings,
  }) {
    return containerUtils(
      margin: settings ? null : const EdgeInsets.all(4),
      child: ListTile(
        onTap: onTap,
        visualDensity: const VisualDensity(vertical: -3), // to compact
        leading: Icon(
          leading,
          size: 18,
          color: color,
        ),
        title: textUtils(text: title, size: 12, color: color),
        trailing: trailing,
      ),
    );
  }

  CachedNetworkImage imageNetwork(String url, double size, IconData icon) {
    return CachedNetworkImage(
      imageUrl: url,
      height: size,
      width: size,
      fit: BoxFit.cover,
      httpHeaders: const {
        'Connection': 'keep-alive',
        'Keep-Alive': 'timeout=60, max=100',
      },
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(
          radius: size,
          backgroundImage: imageProvider,
        );
      },
      placeholder: (context, url) => Container(
        height: size,
        color: grey,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        child: Icon(
          icon,
        ),
      ),
    );
  }
}
