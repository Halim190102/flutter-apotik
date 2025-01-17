import 'package:apotik_online/core/image_picker/images.dart';
import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/widget/loading.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FullImageScreen extends ConsumerStatefulWidget {
  const FullImageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FullImageScreenState();
}

class _FullImageScreenState extends ConsumerState<FullImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, widget) {
      final authWatch = ref.watch(authProvider);
      if (authWatch.state == GlobalState.loading) {
        return const Loading();
      } else {
        final profile = authWatch.profile ?? ProfileModel();
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    showSource(context, true);
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          body: Center(
            child: Hero(
              tag: 1,
              child: profile.profilepict != null
                  ? Image.network(
                      '$baseUrl/${profile.profilepict}',
                      headers: const {
                        'Connection': 'keep-alive',
                        'Keep-Alive': 'timeout=60, max=100',
                      },
                    )
                  : const Icon(Icons.person),
            ),
          ),
        );
      }
    });
  }
}
