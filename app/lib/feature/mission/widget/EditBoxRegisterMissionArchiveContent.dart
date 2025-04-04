import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

class EditBoxRegisterMissionArchiveContent extends StatefulWidget {
  final TextEditingController controller;

  const EditBoxRegisterMissionArchiveContent(
      {super.key, required this.controller});

  @override
  State<EditBoxRegisterMissionArchiveContent> createState() =>
      _CustomInputBoxState();
}

class _CustomInputBoxState extends State<EditBoxRegisterMissionArchiveContent> {
  bool _hasInput = false;

  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {
        _hasInput = widget.controller.text.isNotEmpty;
      });
    });
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
        controller: widget.controller,
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
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero),
      ),
    );
  }
}
