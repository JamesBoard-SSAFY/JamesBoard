import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jamesboard/constants/AppString.dart';
import 'package:jamesboard/constants/FontString.dart';
import 'package:jamesboard/theme/Colors.dart';

class EditBoxRegisterMissionBoardGameCount extends StatefulWidget {
  final TextEditingController controller;

  const EditBoxRegisterMissionBoardGameCount(
      {super.key, required this.controller});

  @override
  State<EditBoxRegisterMissionBoardGameCount> createState() =>
      _CustomInputBoxState();
}

class _CustomInputBoxState extends State<EditBoxRegisterMissionBoardGameCount> {
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: secondaryBlack,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
          _MaxValueInputFormatter(9)
        ],
        style: TextStyle(
          color: _hasInput ? mainWhite : mainGrey,
          fontSize: 16,
          fontFamily: FontString.pretendardMedium,
        ),
        decoration: InputDecoration(
            hintText: AppString.gameCountInput,
            hintStyle: TextStyle(
              color: mainGrey,
              fontSize: 16,
              fontFamily: FontString.pretendardMedium,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero),
      ),
    );
  }
}

class _MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;

  _MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final int? value = int.tryParse(newValue.text);
    if (value == null || value > maxValue) {
      return oldValue;
    }

    return newValue;
  }
}
