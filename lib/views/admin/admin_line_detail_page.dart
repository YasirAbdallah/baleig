// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paligolshir/controllers/poem_controller.dart';
import 'package:paligolshir/models/poem_model.dart';
import 'package:paligolshir/views/helpers/app_widgets.dart';
import 'package:paligolshir/views/helpers/font_adjuster.dart';
import 'package:paligolshir/views/helpers/url_image_displayer.dart';
import 'package:paligolshir/views/helpers/url_voice_card.dart';
import 'admin_line_edit_page.dart';

class AdminLineDetailsPage extends StatelessWidget {
  final Line line;
  final int lineIndex;

  const AdminLineDetailsPage({
    super.key,
    required this.line,
    required this.lineIndex,
  });

  @override
  Widget build(BuildContext context) {
    final PoemController controller = Get.put(PoemController());
    double fontSize = FontAdjuster.getAdjustedFontSize(context);

    return WillPopScope(
      onWillPop: () async {
        controller.isLineEditMode.value = false;
        return true;
      },
      child: MediaQuery(
              data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(0.9)),

        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFD700), // اللون الذهبي الأساسي
                      Color(0xFFFFC107), // لون ذهبي أفتح
                      Color(0xFFFFD700), // لون برتقالي ذهبي
                      Color(0xFFCC8400), // لون ذهبي داكن
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              title: const CustomTitleText(
                text: 'تفاصيل البيت',
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.edit_note),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            AdminLineEditPage(line: line, lineIndex: lineIndex),
                      ));
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: const Icon(Icons.delete, color:  Colors.red,),
                    onPressed: () async {
                      // عرض نافذة حوار التأكيد قبل الحذف
                      Get.dialog(
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                    size: 60,
                                  ),
                                  const SizedBox(height: 20),
                                    const CustomTitleText(
                                    text: 
                                    "هل أنت متأكد أنك تريد حذف هذا السطر؟",
                                  
                                  ),
                                  const SizedBox(height: 20),
                                  const CustomBodyText(
                                  text:   "لن يمكنك استرجاعه بعد الحذف.",
                                    
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // زر الغاء
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // إغلاق النافذة عند الضغط على الغاء
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const   CustomBodyText(
                                              text: 
                                              "إلغاء",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // زر التأكيد
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await controller.deleteLine(lineIndex);
                                              if (!controller.isLoading.value) {
                                                Navigator.pop(
                                                    context); // إغلاق النافذة بعد الحذف
                                                        Navigator.pop(
                                                    context); // إغلاق النافذة بعد الحذف
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const   CustomBodyText(
                                              text: 
                                              "حذف",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              )
        
              ],
            ),
            body: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLineDetails(
                            line,
                            lineIndex + 1,
                            context,
                          ), // Pass line and lineNumber here
                          _buildUrlVoicePlayer(line.voiceUrl),
                          const SizedBox(height: 16),
                          _buildImageDisplayer(line.imageUrl),
                          const SizedBox(height: 20),
                          _buildGoldCard('نثر البيت', line.prose, fontSize),
                          _buildMapDetails('علوم النحو', line.grammarAnalysis),
                          _buildMapDetails('علوم البلاغة', line.rhetoricAnalysis),
                          _buildMapDetails('معاني الكلمات', line.wordMeanings),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrlVoicePlayer(String? voiceUrl) {
    if (voiceUrl != null && voiceUrl.isNotEmpty) {
      return UrlVoiceCardPlayer(
        audioSource: voiceUrl,
      );
    } else {
      return Container();
    }
  }

  Widget _buildImageDisplayer(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return UrlImageDisplayer(
        imageUrl: imageUrl,
      );
    } else {
      return Container();
    }
  }

  Widget _buildLineDetails(
    Line line,
    int lineNumber,
    BuildContext context,
  ) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFD700), // اللون الذهبي الأساسي
              Color(0xFFFFC107), // لون ذهبي أفتح
              Color(0xFFFFD700), // لون برتقالي ذهبي
              Color(0xFFCC8400), // لون ذهبي داكن
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBodyText(text: line.hemistich1),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomBodyText(text: line.hemistich2),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomBodyText(
                text: '($lineNumber)',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بناء جدول لعرض البيانات المخزنة في الخرائط
  Widget _buildMapDetails(String title, Map<String, String> mapData) {
    // التحقق من وجود البيانات
    if (mapData.isEmpty) {
      return const SizedBox.shrink(); // إخفاء الجدول إذا كانت الخريطة فارغة
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTitleText(text: title),
        const SizedBox(height: 8),
        Card(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF9E5), // ذهبي فاتح جداً
                  Color(0xFFFFD700), // لون ذهبي أفتح
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Table(
              border: TableBorder(
                borderRadius: BorderRadius.circular(12),
                bottom: const BorderSide(color: Colors.grey),
                horizontalInside: const BorderSide(color: Colors.grey),
                verticalInside: const BorderSide(color: Colors.grey),
                left: const BorderSide(color: Colors.grey),
                right: const BorderSide(color: Colors.grey),
                top: const BorderSide(color: Colors.grey),
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: mapData.entries
                  .where(
                      (entry) => entry.value.isNotEmpty) // إخفاء الحقول الفارغة
                  .map(
                    (entry) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomBodyText(
                            text: entry.key,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomBodyText(text: entry.value),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildGoldCard(String title, String content, double fontSize) {
    if (content.isEmpty) {
      return const SizedBox.shrink(); // إخفاء البطاقة إذا كان النثر فارغاً
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTitleText(text: title),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.all(5),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFF9E5), // ذهبي فاتح جداً
                  Color(0xFFFFE1A8), // لون ذهبي أفتح
                  Color(0xFFFFD700), // لون ذهبي فاتح
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                CustomBodyText(text: content)
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
