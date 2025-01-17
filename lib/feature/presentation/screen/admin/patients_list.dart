import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientsList extends ConsumerStatefulWidget {
  const PatientsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PatientsListState();
}

class _PatientsListState extends ConsumerState<PatientsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final patients = ref.watch(authProvider).patients;
        if (patients.isEmpty) {
          return const Center(
            child: Text(
              'No data available',
            ),
          );
        } else {
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return ListViewUser(profile: patient);
            },
          );
        }
      },
    );
  }
}

class ListViewUser extends ConsumerStatefulWidget {
  const ListViewUser({
    super.key,
    required this.profile,
  });
  final ProfileModel profile;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListViewUserState();
}

class _ListViewUserState extends ConsumerState<ListViewUser> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: '$baseUrl/${widget.profile.profilepict!}',
              height: 80,
              width: 80,
              fit: BoxFit.contain,
              httpHeaders: const {
                'Connection': 'keep-alive',
                'Keep-Alive': 'timeout=60, max=100',
              },
              imageBuilder: (context, imageProvider) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: imageProvider,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              placeholder: (context, url) => Container(
                height: 80,
                color: grey,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.image_not_supported,
              ),
            ),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textUtils(
                  text: widget.profile.name ?? 'Unknown Name',
                  size: 16,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                textUtils(
                  text: widget.profile.email ?? 'Unknown Email',
                  size: 14,
                  color: grey,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
