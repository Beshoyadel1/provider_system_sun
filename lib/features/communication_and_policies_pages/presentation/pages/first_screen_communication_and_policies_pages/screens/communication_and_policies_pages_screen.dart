import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/communication_and_policies_pages/data/about_repository.dart';
import 'package:sun_web_system/features/communication_and_policies_pages/presentation/custom_widget/tab_communication_and_policies_widget.dart';

class CommunicationAndPoliciesPagesScreen extends StatefulWidget {
  const CommunicationAndPoliciesPagesScreen({super.key, this.loadPages});
  final Future<List<AboutPage>> Function()? loadPages;
  @override
  State<CommunicationAndPoliciesPagesScreen> createState() =>
      _CommunicationAndPoliciesPagesScreenState();
}

class _CommunicationAndPoliciesPagesScreenState
    extends State<CommunicationAndPoliciesPagesScreen> {
  late Future<List<AboutPage>> _pages;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _pages = (widget.loadPages ?? AboutRepository().getPages)();
  }

  @override
  Widget build(BuildContext context) {
    final arabic = Localizations.localeOf(context).languageCode == 'ar';
    final translations = AppLocalizations.of(context);
    return Directionality(
      textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
      child: FutureBuilder<List<AboutPage>>(
        future: _pages,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.orangeColor));
          }
          if (snapshot.hasError) {
            return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(translations.translate(AppLanguageKeys.aboutLoadError)),
              const SizedBox(height: 12),
              TextButton(
                  onPressed: () => setState(_load),
                  child:
                      Text(translations.translate(AppLanguageKeys.aboutRetry))),
            ]));
          }
          final pages = snapshot.data ?? [];
          if (pages.isEmpty) {
            return Center(
                child:
                    Text(translations.translate(AppLanguageKeys.aboutEmpty)));
          }
          final selectedIndex = _selectedIndex.clamp(0, pages.length - 1);
          final selectedPage = pages[selectedIndex];
          final title = selectedPage.title(arabic);
          final content = selectedPage.content(arabic);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(pages.length, (index) {
                    return TabCommunicationAndPoliciesWidget(
                      key: ValueKey('about-chip-$index'),
                      isSelected: selectedIndex == index,
                      text: pages[index].title(arabic),
                      onTap: () => setState(() => _selectedIndex = index),
                    );
                  }),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(8, 28, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (title.isNotEmpty)
                        Semantics(
                          header: true,
                          child: SelectableText(
                            title,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      if (title.isNotEmpty && content.isNotEmpty)
                        const SizedBox(height: 16),
                      if (content.isNotEmpty)
                        SelectableText(
                          content,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.8,
                            color: AppColors.blackColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
