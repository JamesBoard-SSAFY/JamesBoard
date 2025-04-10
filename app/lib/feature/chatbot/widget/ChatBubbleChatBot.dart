import 'package:flutter/material.dart';
import 'package:jamesboard/constants/IconPath.dart';
import 'package:jamesboard/theme/Colors.dart';
import '../../../constants/FontString.dart';
import '../../../widget/image/ImageCommonUserCircle.dart';

class ChatBubbleChatBot extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String? imageUrl;
  final bool showProfile;
  final bool showTime;

  const ChatBubbleChatBot({
    Key? key,
    required this.message,
    required this.isMe,
    required this.time,
    this.imageUrl,
    this.showProfile = true,
    this.showTime = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isMe && showProfile) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(IconPath.agentImage, width: 30),
              const SizedBox(width: 8),
              const Text(
                'Q',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: FontString.pretendardBold,
                  color: mainWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) const SizedBox(width: 38),
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isMe && showTime)
                        Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 4),
                          child: Text(
                            time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: mainGrey,
                              fontFamily: FontString.pretendardBold,
                            ),
                          ),
                        ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isMe ? mainGrey : secondaryBlack,
                            borderRadius: isMe
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )
                                : const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                          ),
                          child: Text(
                            message,
                            style: const TextStyle(
                              color: mainWhite,
                              fontSize: 16,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                      if (!isMe && showTime)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Text(
                            time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: mainGrey,
                              fontFamily: FontString.pretendardBold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
