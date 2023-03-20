import 'package:flutter/material.dart';
import 'package:invested/util/widget/page/page_image.dart';
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/custom_text_field.dart';
import 'package:invested/util/widget/text/page_title.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({Key? key}) : super(key: key);

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(
                  children: [
                    const ToPrevPage(),
                    const PageImage(assetImg: 'assets/images/icon.png', marginTop: 7),
                    const PageTitle(title: "Enter Code"),
                    CustomText(
                      leftMargin: 15,
                      rightMargin: 15,
                      topMargin: 10,
                      bottomMargin: 10,
                      text: "We have sent an email with your verification code! Please check your email.",
                      fontSize: 15,
                    ),
                    CustomTextField(
                        textCallBack: (value) {},
                        hintText: 'Enter Verification Code...',
                        labelText: 'Enter Verification Code',
                        errorText: verificationCodeErrorText,
                        textInputType: TextInputType.number,
                        textFormatters: [FilteringTextInputFormatter.digitsOnly],
                        prefixIcon: Icons.dialpad_outlined,
                        textController: codeController
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            child: ElevatedButton(
                                onPressed: codeController.text.isNotEmpty ? onSubmit : () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Color(global_styling.LOGO_COLOR),
                                ),
                                child: Text(
                                  "Submit Code",
                                  style: TextStyle(
                                      fontFamily: global_styling.TITLE_FONT
                                  ),
                                )
                            )
                        )
                    ),
                  ],
                )
            )
        )
    );
  }

  Column
}

