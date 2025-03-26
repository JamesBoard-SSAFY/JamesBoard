import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jamesboard/theme/Colors.dart';

class ButtonRegisterArchivePicture extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;

  const ButtonRegisterArchivePicture({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = (constraints.maxWidth - 16) / 2;

        return GestureDetector(
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: secondaryBlack,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: size,
                  height: size,
                  color: mainGrey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
