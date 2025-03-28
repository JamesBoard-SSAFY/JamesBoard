import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

class EditBoxRegisterMissionArchiveContent extends StatefulWidget {
  const EditBoxRegisterMissionArchiveContent({super.key});

  @override
  State<EditBoxRegisterMissionArchiveContent> createState() =>
      _CustomInputBoxState();
}

class _CustomInputBoxState extends State<EditBoxRegisterMissionArchiveContent> {
  final TextEditingController _controller = TextEditingController();
  bool _hasInput = false;

  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _hasInput = _controller.text.isNotEmpty;
      });
    });
  }

  // 메모리 누수 방지.
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: secondaryBlack,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.text,
        minLines: 3,
        maxLines: null,
        inputFormatters: [
          LengthLimitingTextInputFormatter(255),
        ],
        style: TextStyle(
          color: _hasInput ? mainWhite : mainGrey,
          fontSize: 16,
          fontFamily: FontString.pretendardMedium,
        ),
        decoration: InputDecoration(
            hintText: AppString.missionContentInput,
            hintStyle: TextStyle(
                color: mainGrey,
                fontSize: 16,
                fontFamily: FontString.pretendardMedium),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero),
      ),
    );
  }
}
