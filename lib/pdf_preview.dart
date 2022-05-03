import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PdfPreviewScreen extends StatefulWidget {
  final Future<Uint8List> Function() pdfGenerator;

  const PdfPreviewScreen({
    Key? key,
    required this.pdfGenerator,
  }) : super(key: key);

  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  PrintingInfo? printingInfo;
  static const _defaultPageFormats = <String, PdfPageFormat>{
    'A4': PdfPageFormat.a4,
  };

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _init() async {
    final info = await Printing.info();

    setState(() {
      printingInfo = info;
    });
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dokumentas atspausdintas sėkmingai'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        maxPageWidth: 1080,
        canDebug: false,
        allowSharing: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
        build: (format) => widget.pdfGenerator(),
        // actions: actions,
        shouldRepaint: true,
        pageFormats: _defaultPageFormats,
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
        onError: (ctx, e) {
          print(e);
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Icon(Icons.chevron_left),
      ),
    );
  }
}
