import 'package:flutter/material.dart';

import 'package:tentura/ui/widget/avatar_image.dart';

import '../bloc/profile_cubit.dart';

class ProfileNavBarItem extends StatelessWidget {
  const ProfileNavBarItem({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (p, c) => p.user.imageId != c.user.imageId,
        builder: (context, state) => FittedBox(
          fit: BoxFit.scaleDown,
          child: AvatarImage(
            userId: state.user.has_picture ? state.user.id : '',
            size: 36,
          ),
        ),
      );
}
