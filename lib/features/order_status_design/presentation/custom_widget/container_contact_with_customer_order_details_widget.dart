import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/pages_widgets/general_widgets/memory_image_with_fallback.dart';
import '../../../../core/theming/assets.dart';
import '../../../../core/theming/colors.dart';

class ContainerContactWithCustomerOrderDetailsWidget extends StatelessWidget {
  const ContainerContactWithCustomerOrderDetailsWidget(
      {super.key,
      this.nameCustomer,
      this.imageUser,
      this.phone,
      this.onMessage});
  final String? nameCustomer, phone;
  final Uint8List? imageUser;
  final VoidCallback? onMessage;

  @override
  Widget build(BuildContext context) {
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    final number = phone?.trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.orangeColor.withValues(alpha: 0.4))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(ar ? 'التواصل مع صاحب الطلب' : 'Contact order customer'),
        const SizedBox(height: 10),
        Row(children: [
          ClipOval(
              child: MemoryImageWithFallback(
                  bytes: imageUser,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  fallback: Image.asset(AppImageKeys.person22,
                      width: 48, height: 48))),
          const SizedBox(width: 8),
          Expanded(
              child: Text(nameCustomer?.trim().isNotEmpty == true
                  ? nameCustomer!
                  : '—')),
          IconButton(
              key: const Key('order-contact-phone'),
              icon: const Icon(Icons.phone_outlined),
              tooltip: ar ? 'عرض الرقم' : 'Show phone number',
              onPressed: number?.isNotEmpty != true
                  ? null
                  : () => showDialog<void>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                            title: Text(ar ? 'رقم الهاتف' : 'Phone number'),
                            content: SelectableText(number!,
                                textDirection: TextDirection.ltr),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: number));
                                    if (dialogContext.mounted)
                                      Navigator.of(dialogContext).pop();
                                  },
                                  child:
                                      Text(ar ? 'نسخ الرقم' : 'Copy number')),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: Text(ar ? 'إغلاق' : 'Close')),
                            ],
                          ))),
          IconButton(
              key: const Key('order-contact-chat'),
              icon: const Icon(Icons.message_outlined),
              tooltip: ar ? 'فتح المحادثة' : 'Open conversation',
              onPressed: onMessage),
        ]),
        if (number?.isNotEmpty != true)
          Text(ar ? 'رقم الهاتف غير متاح' : 'Phone number unavailable'),
      ]),
    );
  }
}
