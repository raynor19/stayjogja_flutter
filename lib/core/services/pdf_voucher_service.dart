import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfVoucherService {
  PdfVoucherService._();

  static Future<Uint8List> generateVoucherDocument({
    required String bookingCode,
    required String guestName,
    required String hotelName,
    required String roomName,
    required String checkIn,
    required String checkOut,
    required int nights,
    required int totalPrice,
    String? guestNik,
    String? guestPhone,
  }) async {
    final pdf = pw.Document();

    final qrPayload = [
      '=== RESERVASI STAYJOGJA ===',
      'INVOICE : $bookingCode',
      'STATUS  : LUNAS & TERKONFIRMASI',
      '---------------------------',
      'NAMA    : $guestName',
      'HOTEL   : $hotelName',
      'KAMAR   : $roomName',
      'TANGGAL : $checkIn s/d $checkOut',
      'TOTAL   : Rp $totalPrice',
      '===========================',
      'TERVERIFIKASI RESMI STAYJOGJA'
    ].join('\n');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300, width: 1.5),
              borderRadius: pw.BorderRadius.circular(16),
            ),
            padding: const pw.EdgeInsets.all(28),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // ─── Header: Brand Logo & Title ───────────────────────
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'STAYJOGJA',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#16181B'),
                          ),
                        ),
                        pw.Text(
                          'Official Hospitality & Reservation Voucher',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#6F7673'),
                          ),
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#E2F7EE'),
                        borderRadius: pw.BorderRadius.circular(12),
                        border: pw.Border.all(color: PdfColor.fromHex('#00B67A'), width: 1),
                      ),
                      child: pw.Text(
                        'LUNAS & TERKONFIRMASI',
                        style: pw.TextStyle(
                          color: PdfColor.fromHex('#00B67A'),
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Divider(thickness: 1, color: PdfColors.grey300),
                pw.SizedBox(height: 14),

                // ─── Booking Code Box ─────────────────────────────────
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F8F9FA'),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'KODE BOOKING INVOICE:',
                        style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        bookingCode,
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#16181B')),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // ─── Hotel & Guest Details Grid ───────────────────────
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Kolom Hotel
                    pw.Expanded(
                      flex: 6,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('INFORMASI AKOMODASI', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600)),
                          pw.SizedBox(height: 6),
                          pw.Text(hotelName, style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
                          pw.Text(roomName, style: pw.TextStyle(fontSize: 12, color: PdfColor.fromHex('#00B67A'), fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 14),
                          pw.Text('Jadwal Menginap:', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                          pw.Text('$checkIn s/d $checkOut ($nights Malam)', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 14),
                          pw.Text('DATA TAMU UTAMA:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600)),
                          pw.SizedBox(height: 4),
                          pw.Text('Nama Tamu : $guestName', style: const pw.TextStyle(fontSize: 11)),
                          if (guestPhone != null && guestPhone.isNotEmpty)
                            pw.Text('No. WhatsApp : $guestPhone', style: const pw.TextStyle(fontSize: 11)),
                          if (guestNik != null && guestNik.isNotEmpty)
                            pw.Text('NIK / ID : $guestNik', style: const pw.TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),

                    // Kolom QR Code
                    pw.Expanded(
                      flex: 4,
                      child: pw.Column(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey300),
                              borderRadius: pw.BorderRadius.circular(12),
                            ),
                            child: pw.BarcodeWidget(
                              barcode: pw.Barcode.qrCode(),
                              data: qrPayload,
                              width: 140,
                              height: 140,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            'Scan di Front Desk untuk Fast Check-in',
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Divider(thickness: 1, color: PdfColors.grey300),
                pw.SizedBox(height: 10),

                // ─── Price Summary ────────────────────────────────────
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TOTAL PEMBAYARAN (LUNAS):', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#00B67A')),
                    ),
                  ],
                ),
                pw.Spacer(),

                // ─── Footer: Legal Notice & Stamp ─────────────────────
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#EBF4EE'),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'VERIFIKASI RESMI DIGITAL STAYJOGJA — SISTEM PAPERLESS CHECK-IN',
                              style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#16181B')),
                            ),
                            pw.Text(
                              'Tunjukkan dokumen PDF atau QR Code ini kepada resepsionis hotel saat kedatangan. Anda tidak perlu membawa fotokopi KTP fisik.',
                              style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Print atau Simpan PDF langsung di perangkat
  static Future<void> printOrSaveVoucher({
    required String bookingCode,
    required String guestName,
    required String hotelName,
    required String roomName,
    required String checkIn,
    required String checkOut,
    required int nights,
    required int totalPrice,
    String? guestNik,
    String? guestPhone,
  }) async {
    final pdfBytes = await generateVoucherDocument(
      bookingCode: bookingCode,
      guestName: guestName,
      hotelName: hotelName,
      roomName: roomName,
      checkIn: checkIn,
      checkOut: checkOut,
      nights: nights,
      totalPrice: totalPrice,
      guestNik: guestNik,
      guestPhone: guestPhone,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'Voucher-StayJogja-$bookingCode.pdf',
    );
  }

  /// Bagikan dokumen PDF ke aplikasi lain (WhatsApp, Email, dll)
  static Future<void> shareVoucher({
    required String bookingCode,
    required String guestName,
    required String hotelName,
    required String roomName,
    required String checkIn,
    required String checkOut,
    required int nights,
    required int totalPrice,
  }) async {
    final pdfBytes = await generateVoucherDocument(
      bookingCode: bookingCode,
      guestName: guestName,
      hotelName: hotelName,
      roomName: roomName,
      checkIn: checkIn,
      checkOut: checkOut,
      nights: nights,
      totalPrice: totalPrice,
    );

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'Voucher-StayJogja-$bookingCode.pdf',
    );
  }
}
