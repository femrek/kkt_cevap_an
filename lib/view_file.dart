import 'package:Gkktcaa/datas/app_theme.dart';
import 'package:Gkktcaa/datas/file_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class ViewFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ViewFileState();
  }
}

class _ViewFileState extends State<ViewFile> {
  String pathPDF = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FileData fileData = ModalRoute.of(context).settings.arguments;
    pathPDF = fileData.path;
    String title = fileData.title ?? 'PDF Görüntüleyici';

    return PDFViewerScaffold(
      path: pathPDF,
      appBar: AppBar(
        backgroundColor: AppTheme.appBarBg,
        centerTitle: true,
        title: Text(title),
      ),
    );
  }
}
