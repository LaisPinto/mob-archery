import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:mob_archery/app/modules/training/models/training_end_model.dart';
import 'package:mob_archery/app/modules/training/models/training_session_model.dart';

class TrainingReportService {
  static final _dateFormat = DateFormat("dd/MM/yyyy 'às' HH:mm");

  Future<List<int>> buildSessionPdf({
    required TrainingSessionModel session,
    required List<TrainingEndModel> ends,
  }) async {
    final doc = pw.Document();

    // ── Computed values ───────────────────────────────────────────────────────
    final sessionTitle = session.name.isNotEmpty
        ? session.name
        : 'Treino — ${session.totalArrows} flechas';
    final totalScore = (session.averageScore * session.totalArrows).round();

    int acc = 0;
    final rows = ends.asMap().entries.map((e) {
      final sum = _endSum(e.value);
      acc += sum;
      return _EndRow(
        index: e.key + 1,
        arrows: e.value.arrows.join('  '),
        sum: sum,
        acc: acc,
        isOdd: e.key.isOdd,
      );
    }).toList();

    // ── Colors ────────────────────────────────────────────────────────────────
    const brand = PdfColor(0.231, 0.510, 0.965); // #3B82F6
    const surface = PdfColor(0.973, 0.980, 0.988); // #F8FAFC
    const border = PdfColor(0.886, 0.902, 0.918); // #E2E8F0
    const labelGrey = PdfColor(0.392, 0.455, 0.545); // #64748B
    const zebraOrange = PdfColor(1.0, 0.969, 0.929); // #FFF7ED

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 48),
        footer: (_) => pw.Center(
          child: pw.Text(
            'Gerado pelo Mob Archery',
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
          ),
        ),
        build: (_) => [
          // ── Header ──────────────────────────────────────────────────────────
          pw.Text(
            'MOB ARCHERY',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: brand,
              letterSpacing: 1,
            ),
          ),
          pw.Text(
            'Relatório de Treino',
            style: pw.TextStyle(fontSize: 12, color: labelGrey),
          ),
          pw.SizedBox(height: 10),
          pw.Divider(color: border, thickness: 1),
          pw.SizedBox(height: 10),
          pw.Text(
            sessionTitle,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            _dateFormat.format(session.date),
            style: pw.TextStyle(fontSize: 11, color: labelGrey),
          ),
          if (session.isSpotter) ...[
            pw.SizedBox(height: 6),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: pw.BoxDecoration(
                color: zebraOrange,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                'REGISTRADO POR SPOTTER',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor(0.976, 0.451, 0.086), // #F97316
                ),
              ),
            ),
          ],

          pw.SizedBox(height: 24),

          // ── Metrics ──────────────────────────────────────────────────────────
          pw.Text(
            'MÉTRICAS DA SESSÃO',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: labelGrey,
              letterSpacing: 0.5,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 16),
            decoration: pw.BoxDecoration(
              color: surface,
              border: pw.Border.all(color: border),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _metricCell('TOTAL', '$totalScore', '${session.totalArrows} flechas', labelGrey),
                _dividerCell(border),
                _metricCell('MÉDIA', session.averageScore.toStringAsFixed(2), 'p/ flecha', labelGrey),
                _dividerCell(border),
                _metricCell('X COUNT', '${session.xCount}', 'centro', labelGrey),
              ],
            ),
          ),

          pw.SizedBox(height: 24),

          // ── Ends table ───────────────────────────────────────────────────────
          if (rows.isNotEmpty) ...[
            pw.Text(
              'HISTÓRICO DE ENDS',
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: labelGrey,
                letterSpacing: 0.5,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: border, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(60),
                1: const pw.FlexColumnWidth(),
                2: const pw.FixedColumnWidth(52),
                3: const pw.FixedColumnWidth(72),
              },
              children: [
                // Header
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: surface),
                  children: [
                    _tableHeader('SÉRIE'),
                    _tableHeader('FLECHAS'),
                    _tableHeader('SOMA', align: pw.TextAlign.center),
                    _tableHeader('ACUMULADO', align: pw.TextAlign.right),
                  ],
                ),
                // Data rows
                ...rows.map(
                  (row) => pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: row.isOdd ? zebraOrange : PdfColors.white,
                    ),
                    children: [
                      _tableCell('End ${row.index}'),
                      _tableCell(row.arrows),
                      _tableCell('${row.sum}', align: pw.TextAlign.center),
                      _tableCell('${row.acc}', align: pw.TextAlign.right),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );

    return doc.save();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  int _scoreValue(String s) {
    if (s == 'X' || s == '10') return 10;
    if (s == 'M') return 0;
    return int.tryParse(s) ?? 0;
  }

  int _endSum(TrainingEndModel end) =>
      end.arrows.fold(0, (sum, s) => sum + _scoreValue(s));

  pw.Widget _metricCell(
    String label,
    String value,
    String subtitle,
    PdfColor labelColor,
  ) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: labelColor,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            subtitle,
            style: pw.TextStyle(fontSize: 9, color: labelColor),
          ),
        ],
      ),
    );
  }

  pw.Widget _dividerCell(PdfColor color) {
    return pw.Container(width: 1, height: 48, color: color);
  }

  pw.Widget _tableHeader(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey600,
        ),
      ),
    );
  }

  pw.Widget _tableCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: pw.Text(
        text,
        textAlign: align,
        style: const pw.TextStyle(fontSize: 11),
      ),
    );
  }
}

class _EndRow {
  const _EndRow({
    required this.index,
    required this.arrows,
    required this.sum,
    required this.acc,
    required this.isOdd,
  });

  final int index;
  final String arrows;
  final int sum;
  final int acc;
  final bool isOdd;
}