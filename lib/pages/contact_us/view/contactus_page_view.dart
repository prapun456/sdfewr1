import 'package:sdfewr/configs/app_dimensions.dart';
import 'package:sdfewr/configs/configs.dart';
import 'package:sdfewr/pages/contact_us/view_model/contactus_page_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart' as UrLauncher;
import '../../../../widgets/busy_button.dart';
import '../../../../widgets/text_input/orange_text_form_field.dart';
import '../../../locator.dart';
import '../../../services/form_service.dart';

class ContactUsPageView extends StatelessWidget {
  ContactUsPageView({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder<ContactPageViewModel>.reactive(
      viewModelBuilder: () => ContactPageViewModel(),
      builder: (
        BuildContext context,
        ContactPageViewModel model,
        Widget? child,
      ) {
        final emailcontroller = TextEditingController();
        final topiccontroller = TextEditingController();
        final messagecontroller = TextEditingController();
        final namecontroller = TextEditingController();

        final emailInputField = BrownTextFormField(
          controller: emailcontroller,
          labelText: 'Email',
          validator: model.validateEmail,
          keyboardType: TextInputType.emailAddress,
        );
        final nameInputField = BrownTextFormField(
          controller: namecontroller,
          labelText: 'Name',
          validator: model.validateName,
          keyboardType: TextInputType.text,
        );
        final topicInputField = BrownTextFormField(
          controller: topiccontroller,
          labelText: 'Topic',
          validator: model.validateTopic,
          keyboardType: TextInputType.text,
        );
        final messageInputField = BrownTextFormField(
          controller: messagecontroller,
          labelText: 'Message',
          validator: model.validateMessage,
          keyboardType: TextInputType.text,
        );

        final sendMessageFields = [
          emailInputField,
          nameInputField,
          topicInputField,
          messageInputField,
        ];

        return ResponsiveBuilder(builder: (context, sizingInformation) {
          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: AnimatedContainer(
                constraints: sizingInformation.isDesktop
                    ? const BoxConstraints(maxWidth: 1200)
                    : BoxConstraints(
                        maxWidth: sizingInformation.screenSize.width,
                      ),
                duration: const Duration(milliseconds: 60),
                padding: sizingInformation.isDesktop
                    ? const EdgeInsets.symmetric(horizontal: 90)
                    : const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: locator<FormService>().sendMessageFormKey(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send Message',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 25),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      if (!sizingInformation.isMobile)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: sendMessageFields.sublist(0, 3).map(
                                  (item) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 9,
                                      ),
                                      child: item,
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: sendMessageFields.sublist(3).map(
                                  (item) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 9,
                                      ),
                                      child: item,
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        )
                      else
                        ...sendMessageFields,
                      BusyButton(
                        title: 'Send',
                        busy: model.isBusy,
                        onPressed: () {
                          model.sendmessage(
                            context: context,
                            uid: _auth.currentUser!.uid,
                            email: emailcontroller.text,
                            name: namecontroller.text,
                            topic: topiccontroller.text,
                            message: messagecontroller.text,
                          );
                        },
                      ),
                      Text(
                        'OR Contact us via:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 20),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              UrLauncher.launch("mailto:mo7amedaliebaid@gmail.com");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Color(0xff7c471c)),
                              width: AppDimensions.maxContainerWidth,
                              height: AppDimensions.normalize(40),
                              padding: Space.hf(1.5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/email(2).svg",
                                    fit: BoxFit.fill,
                                    width: AppDimensions.normalize(15),
                                  ),
                                  Space.y!,
                                  Text(
                                    "Email",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Space.x!,
                          InkWell(
                            onTap: () {
                              model.launched = model.launchInWebViewOrVC(
                                  Uri.parse("https://www.whatsapp.com/"));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Color(0xff7c471c)),
                              width: AppDimensions.maxContainerWidth,
                              height: AppDimensions.normalize(40),
                              padding: Space.h1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/whatsapp(1).svg",
                                    fit: BoxFit.fill,
                                    width: AppDimensions.normalize(15),
                                  ),
                                  Space.y!,
                                  Text(
                                    "Whatsapp",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Space.x!,
                          InkWell(
                            onTap: () {
                              UrLauncher.launch("tel://201016381636");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Color(0xff7c471c)),
                              width: AppDimensions.maxContainerWidth,
                              height: AppDimensions.normalize(40),
                              padding: Space.hf(1.5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/phone(4).svg",
                                    fit: BoxFit.fill,
                                    width: AppDimensions.normalize(15),
                                  ),
                                  Space.y!,
                                  Text(
                                    "Call us",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ].map(
                      (item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: item,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
