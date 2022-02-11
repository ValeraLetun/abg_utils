import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../abg_utils.dart';

pw.ImageProvider? _qrCodeImage;
pw.MemoryImage? _logo;
var _font = pw.TextStyle(fontSize: 10);

Future<Uint8List> importCurrentBookingToPDF(
    stringInvoice, ///strings.get(465)), /// INVOICE
    string0,        ///strings.get(0)
    stringEmail,   /// strings.get(86) /// Email
    stringOrderId, /// strings.get(456) /// Order ID
    stringPhone, /// strings.get(124) /// Phone
    stringOrderDate, /// strings.get(466) /// Order Date:
    stringBillTo, /// strings.get(458) "Bill to"
    stringProductName, /// strings.get(459) /// Product name
    stringQty, /// strings.get(460) /// Qty
    stringUnitPrice, /// strings.get(461) /// Unit price
    stringTax, /// strings.get(130) /// Tax
    stringTotal, /// strings.get(177) /// Total
    stringSubTotal, /// strings.get(462) /// Sub Total
    stringTotalTax, /// strings.get(463) /// Total Tax
    stringCouponDiscount, /// strings.get(464) /// Coupon Discount
    stringGrandTotal,  /// strings.get(464) /// Grand Total
    stringAddons, /// strings.get(347) /// "Addons",
    {double fontSize = 10, String colorIn = "#eceff4", String fontName = 'assets/fonts/Montserrat-Regular.ttf'}
    ) async {

  var color = PdfColor.fromHex(colorIn);

  final pdf = pw.Document();
  _qrCodeImage = null;
  _logo = null;
  pw.TextStyle(fontSize: fontSize);

  setDataToCalculate(currentOrder, null);

  final qrValidationResult = QrValidator.validate(
    data: currentOrder.id,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L,
  );

  if (qrValidationResult.status == QrValidationStatus.valid){
    final qrCode = qrValidationResult.qrCode;
    if (qrCode != null) {
      final painter = QrPainter.withQr(
        qr: qrCode,
        color: const Color(0xFF000000),
        gapless: true,
        embeddedImageStyle: null,
        embeddedImage: null,
      );
      final picData = await painter.toImageData(200, format: ImageByteFormat.png);
      if (picData != null)
        _qrCodeImage = pw.MemoryImage(picData.buffer.asUint8List());
    }
  }

  if (appSettings.adminPanelLogoServer.isNotEmpty){
    var response = await http.get(Uri.parse(appSettings.adminPanelLogoServer));
    var data = response.bodyBytes;
    _logo = pw.MemoryImage(data);
  }else
    _logo = pw.MemoryImage(
      (await rootBundle.load('assets/applogo.png')).buffer.asUint8List(),
    );

  Uint8List fontData = (await rootBundle.load(fontName)).buffer.asUint8List(); //'assets/fonts/Montserrat-Regular.ttf'
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());
  _font = pw.TextStyle(fontSize: 10, font: ttf);

  _buildBody2() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(stringBillTo, style: _font), /// "Bill to"
        pw.SizedBox(height: 5),
        //////////////////////////////////////////////////
        pw.Text(currentOrder.customer, style: _font),
        pw.SizedBox(height: 5),
        ///////////////////////////////////////////////////
        pw.Text(currentOrder.address, style: _font),
        pw.SizedBox(height: 5),
        ///////////////////////////////////////////////////
        if (currentOrder.customerEmail.isNotEmpty)
          pw.Row(
              children: [
                pw.Text(stringEmail + ":", style: _font), /// Email
                pw.SizedBox(width: 5),
                pw.Text(currentOrder.customerEmail, style: _font),
              ]
          ),
        if (currentOrder.customerEmail.isNotEmpty)
          pw.SizedBox(height: 5),
        ///////////////////////////////////////////////////
        if (currentOrder.customerPhone.isNotEmpty)
          pw.Row(
              children: [
                pw.Text(stringPhone + ":", style: _font), /// Phone
                pw.SizedBox(width: 5),
                pw.Text(currentOrder.customerPhone, style: _font),
              ]
          ),
        if (currentOrder.customerPhone.isNotEmpty)
          pw.SizedBox(height: 5),
        /////////////////////////////////////////////////
        pw.Column(
            children: [
              pw.Row(
                  children: [
                    pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringProductName, style: _font) /// Product name
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringQty, style: _font) /// Qty
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringUnitPrice, style: _font) /// Unit price
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringTax, style: _font) /// Tax
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringTotal, style: _font) /// Total
                        )
                    )
                  ]
              ),
              //////////
              pw.SizedBox(height: 10),
              pw.Row(
                  children: [
                    pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                            child: pw.Text(getTextByLocale(currentOrder.service, locale), style: _font) /// Product name
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            child: pw.Text(currentOrder.count.toString(), style: _font) /// Qty
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            child: pw.Text(getPriceString(getSubTotalWithCoupon()), style: _font) /// Unit price
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            child: pw.Text(getPriceString(getTax()), style: _font) /// Tax
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            child: pw.Text(getPriceString(getTotal()), style: _font) /// Total
                        )
                    )
                  ]
              ),
              ///////////////////////////////////////
              pw.SizedBox(height: 5),
              pw.Divider(color: color),
              pw.SizedBox(height: 5),
              /////////////////////////////////////
              pw.Row(
                  children: [
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                          padding: pw.EdgeInsets.all(20),
                          child: _qrCodeImage != null ? pw.Image(_qrCodeImage!) : pw.Container(),
                        )),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                        )),
                    pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                            children: [
                              pw.Row(
                                  children: [
                                    pw.Expanded(child: pw.Text(stringSubTotal, style: _font)), /// Sub Total
                                    pw.SizedBox(width: 10),
                                    pw.Text(getPriceString(getSubTotalWithoutCoupon()), style: _font)
                                  ]
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                  children: [
                                    pw.Expanded(child: pw.Text(stringTotalTax, style: _font)), /// Total Tax
                                    pw.SizedBox(width: 10),
                                    pw.Text(getPriceString(getTax()), style: _font)
                                  ]
                              ),
                              pw.SizedBox(height: 5),
                              pw.Divider(color: color),
                              pw.SizedBox(height: 2),
                              pw.Row(
                                  children: [
                                    pw.Expanded(child: pw.Text(stringCouponDiscount, style: _font)), /// Coupon Discount
                                    pw.SizedBox(width: 10),
                                    pw.Text(getPriceString(getCoupon()), style: _font)
                                  ]
                              ),
                              pw.SizedBox(height: 2),
                              pw.Divider(color: color),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                  children: [
                                    pw.Expanded(child: pw.Text(stringGrandTotal, style: _font)), /// Grand Total
                                    pw.SizedBox(width: 10),
                                    pw.Text(getPriceString(getTotal()), style: _font)
                                  ]
                              ),
                            ]
                        )
                    ),
                  ]
              )
            ]
        ),



      ],
    );
  }

  _buildBody2V4() {

    cart = currentOrder.products;
    cartCurrentProvider = ProviderData.createEmpty()..id = currentOrder.providerId;

    List<pw.Widget> listPrices = [];
    for (var item in cartGetPriceForAllServices()){
      listPrices.add(pw.Row(
          children: [
            // pw.Container(
            //   width: 100,
            //   padding: pw.EdgeInsets.all(10),
            // child: item.image.isNotEmpty ? Image.network(item.image, fit: BoxFit.contain,) : Container(),
            // ),
            pw.Expanded(
                flex: 2,
                child: pw.Column(
                  children: [
                    pw.Container(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(item.name, style: _font) // Product name
                    ),
                    pw.SizedBox(height: 5,),
                    if (item.addonText.isNotEmpty)
                      pw.Container(
                          padding: pw.EdgeInsets.only(left: 5, right: 5, bottom: 5),
                          child: pw.Text(item.addonText, style: _font) // Product name
                      ),
                  ],
                )
            ),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(item.count.toString(), style: _font) // Qty
                )
            ),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(getPriceString(item.priceWithoutCount), style: _font) // Unit price
                )
            ),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(getPriceString(item.priceAddons), style: _font) // Add on
                )
            ),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text("(${item.taxPercentage.toStringAsFixed(0)}%) ${getPriceString(item.tax)}", style: _font) // Tax
                )
            ),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text(item.subTotalString, style: _font) // Total
                )
            )
          ]
      )
      );

      listPrices.add(pw.SizedBox(height: 5),);
      listPrices.add(pw.Divider(color: color),);
      listPrices.add(pw.SizedBox(height: 5),);
    }

    var _totalPrice = cartGetTotalForAllServices();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(stringBillTo, style: _font), /// "Bill to"
        pw.SizedBox(height: 5),
        //////////////////////////////////////////////////
        pw.Text(currentOrder.customer, style: _font),
        pw.SizedBox(height: 5),
        ///////////////////////////////////////////////////
        pw.Text(currentOrder.address, style: _font),
        pw.SizedBox(height: 5),
        ///////////////////////////////////////////////////
        if (currentOrder.customerEmail.isNotEmpty)
          pw.Row(
              children: [
                pw.Text(stringEmail + ":", style: _font), /// Email
                pw.SizedBox(width: 5),
                pw.Text(currentOrder.customerEmail, style: _font),
              ]
          ),
        if (currentOrder.customerEmail.isNotEmpty)
          pw.SizedBox(height: 5),
        ///////////////////////////////////////////////////
        if (currentOrder.customerPhone.isNotEmpty)
          pw.Row(
              children: [
                pw.Text(stringPhone + ":", style: _font), /// Phone
                pw.SizedBox(width: 5),
                pw.Text(currentOrder.customerPhone, style: _font),
              ]
          ),
        if (currentOrder.customerPhone.isNotEmpty)
          pw.SizedBox(height: 5),
        /////////////////////////////////////////////////
        pw.Column(
            children: [
              pw.Row(
                  children: [
                    // pw.Container(
                    //     width: 100,
                    //     color: color,
                    //     padding: pw.EdgeInsets.all(5),
                    //     child: pw.Text("", style: _font)
                    // ),
                    pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringProductName, style: _font) /// Product name
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringQty, style: _font) /// Qty
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringUnitPrice, style: _font) /// Unit price
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringAddons, style: _font) /// "Addons",
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringTax, style: _font) /// Tax
                        )
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            color: color,
                            child: pw.Text(stringSubTotal, style: _font) /// Sub Total
                        )
                    )
                  ]
              ),

              ...listPrices,
              //////////

              pw.Row(
                  children: [
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                          padding: pw.EdgeInsets.all(20),
                          child: _qrCodeImage != null ? pw.Image(_qrCodeImage!) : pw.Container(),
                        )),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                        )),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                            children: [
                              pw.Row(
                                  children: [
                                    pw.Expanded(child: pw.Text(stringSubTotal, style: _font)), /// Sub Total
                                    pw.SizedBox(width: 10),
                                    pw.Text(getPriceString(_totalPrice.subtotal), style: _font)
                                  ]
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                  children: [
                                    pw.Expanded(child: pw.Text(stringTotalTax, style: _font)), /// Total Tax
                                    pw.SizedBox(width: 10),
                                    pw.Text(getPriceString(_totalPrice.tax), style: _font)
                                  ]
                              ),
                              pw.SizedBox(height: 5),
                              pw.Divider(color: color),
                              pw.SizedBox(height: 2),
                              pw.Row(
                                  children: [
                                    pw.Expanded(child: pw.Text(stringCouponDiscount, style: _font)), /// Coupon Discount
                                    pw.SizedBox(width: 10),
                                    pw.Text(getPriceString(_totalPrice.discount), style: _font)
                                  ]
                              ),
                              pw.SizedBox(height: 2),
                              pw.Divider(color: color),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                  children: [
                                    pw.Expanded(child: pw.Text(stringGrandTotal, style: _font)), /// Grand Total
                                    pw.SizedBox(width: 10),
                                    pw.Text(getPriceString(_totalPrice.total), style: _font)
                                  ]
                              ),
                            ]
                        )
                    ),
                  ]
              )

            ]
        ),



      ],
    );
  }

  _buildBody(){
    return pw.Column(
        children: [
          pw.Container(
              padding: pw.EdgeInsets.only(top: 15, left: 15, right: 15),
              color: color,
              child: pw.Column(
                children: [
                  pw.Row(
                      children: [
                        pw.SizedBox(height: 50,
                          child: _logo != null ? pw.Image(_logo!) : pw.Container(),),
                        pw.Expanded(
                          child: pw.Container(),
                        ),
                        pw.Text(stringInvoice), /// INVOICE
                      ]
                  ),
                  pw.SizedBox(height: 10),
                  //////////////////////////////////////
                  pw.Row(
                      children: [
                        pw.Text(string0, style: _font ), /// app name
                      ]
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Text("$stringEmail: ${appSettings.adminEmail}", style: _font ), /// Email
                        ),
                        pw.Text("$stringOrderId: ${currentOrder.id}", style: _font ),  /// Order ID
                      ]
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Text("$stringPhone: ${appSettings.adminPhone}", style: _font ), /// Phone
                        ),
                        pw.Text("$stringOrderDate: ${appSettings.getDateTimeString(currentOrder.time)}", style: _font ), /// Order Date:
                      ]
                  ),
                  pw.SizedBox(height: 10),
                ],
              )
          ),

          pw.Container(
            margin: pw.EdgeInsets.only(left: 15, right: 15, top: 10),
            child: currentOrder.ver4 ? _buildBody2V4() : _buildBody2(),
          ),

        ]
    );
  }


  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4.copyWith(marginTop: 0, marginLeft: 0, marginRight: 0),
      build: (pw.Context context) {
        return _buildBody(); // Center
      })); // Pag

  return await pdf.save();
}

