import 'package:Gkktcaa/datas/app_theme.dart';
import 'package:Gkktcaa/datas/file_data.dart';
import 'package:Gkktcaa/datas/url_data.dart';
import 'package:Gkktcaa/datas/user_options.dart';
import 'package:Gkktcaa/main.dart';
import 'package:Gkktcaa/static_methods.dart';
import 'package:Gkktcaa/widgets/main_feed_list_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class MainFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainFeedState();
  }
}

class _MainFeedState extends State<MainFeed> {
  Color shadowColor = AppTheme.shadowColor;

  Future<List<List<String>>> _listFuture;
  List<List<String>> _listElementsData = List();

  Future<List<List<String>>> _listFutureFunc() async {
    StaticMethods.applicationDocumentDirectory =
        (await getApplicationDocumentsDirectory()).path;
    _listElementsData = _convertDataToListSync(UrlData.DATA);
    return _listElementsData;
  }

  @override
  void initState() {
    super.initState();
    FlutterDownloader.initialize();
    _listFuture = _listFutureFunc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<List<String>> _convertDataToListSync(String data) {
    if (data == null || data.length == 0) return null;
    List<List<String>> result = List();
    int startIndex = 0;
    int rowCount = ';'.allMatches(data).length;
    for (int i = 0; i < rowCount; i++) {
      List<String> rowList = List();
      String row = data.substring(startIndex, data.indexOf(';', startIndex));
      int commaStartIndex = 0;
      for (int j = 0; j < ','.allMatches(row).length + 1; j++) {
        int commaIndex = row.indexOf(',', commaStartIndex);
        rowList.add(row.substring(
            commaStartIndex, commaIndex > 0 ? commaIndex : row.length));
        commaStartIndex = commaIndex + 1;
      }
      startIndex = data.indexOf(';', startIndex) + 1;
      result.add(rowList);
    }
    return result;
  }

  List<MainFeedListElement> _listWidgets = List();

  MainFeedListElement _getWidgetByIndex(int index) {
    assert(StaticMethods.applicationDocumentDirectory != null);
    String url = _listElementsData[index][0];
    String path =
        '${StaticMethods.applicationDocumentDirectory}/kktca/${url.substring(url.lastIndexOf('/'))}';
    String title = _listElementsData[index][1];
    Widget widget = MainFeedListElement(
      path: path,
      url: url,
      title: title,
    );
    _listWidgets.insert(index - 1, widget);
    if (_listWidgets.length > _listElementsData.length)
      _listWidgets.removeRange(_listElementsData.length, _listWidgets.length);
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.scaffoldBg,
      child: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              color: AppTheme.scaffoldBgDark,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Kare Kod Tara',
                          style: TextStyle(
                            color: AppTheme.onScaffold,
                            fontSize: 18,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        ButtonTheme(
                          buttonColor: AppTheme.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: RaisedButton(
                            onPressed: _scanButtonClick,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  'assets/qrcode.svg',
                                  fit: BoxFit.cover,
                                  color: AppTheme.onAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Container(
              height: 0,
              color: AppTheme.appColorsDark['divider'],
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  FutureBuilder<List<List<String>>>(
                    future: _listFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 12, right: 24, left: 24),
                            itemBuilder: (BuildContext context, int index) {
                              MainFeedListElement tile =
                                  _getWidgetByIndex(index + 1);
                              return tile;
                            },
                            itemCount: snapshot.data == null
                                ? 0
                                : snapshot.data.length - 1,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Hata',
                          style: TextStyle(color: Colors.red, fontSize: 24),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Text(
                          'Hata',
                          style: TextStyle(color: Colors.red, fontSize: 24),
                        );
                      }
                    },
                  ),
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            shadowColor,
                            Color.fromRGBO(shadowColor.red, shadowColor.green,
                                shadowColor.blue, 0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 8,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              shadowColor,
              Color.fromRGBO(
                  shadowColor.red, shadowColor.green, shadowColor.blue, 0)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ]),
    );
  }

  String _readUrl;

  Future _scan() async {
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      setState(() {
        _readUrl = barcode;
      });

      String taskID;
      int cursorIndex = 0;
      for (List<String> row in _listElementsData) {
        if (row[0] == _readUrl) {

          if (await StaticMethods.detectDownloadedFile(_readUrl)) {
            Navigator.pushNamed(
              context,
              '/viewer',
              arguments: FileData(
                  '${StaticMethods.applicationDocumentDirectory}/kktca/${row[0].substring(row[0].lastIndexOf('/'))}',
                  title: row[1],
                  url: row[0]),
            );
            break;
          }

          if(UserOptions.savePdfToStorage) {
            taskID = await StaticMethods.savePdfToStorage(row[0]);
            StaticMethods.showDownloadingDialog(context, row[1]);
            StaticMethods.fileDownloadListener(taskID).then((bool isComplete) {
              setState(() {
                _listFuture = _listFutureFunc();
              });
              Navigator.pop(context);
              if (isComplete) {
                Navigator.pushNamed(context, '/viewer',
                    arguments: FileData(
                        '${StaticMethods.applicationDocumentDirectory}/kktca/${row[0].substring(row[0].lastIndexOf('/'))}',
                        title: row[1],
                        url: row[0]));
              } else {
                StaticMethods.showDownloadFailedDialog(context);
              }
            });
            break;
          }

          taskID = await StaticMethods.savePdfToTmp(row[0]);
          StaticMethods.showDownloadingDialog(context, row[1]);
          StaticMethods.fileDownloadListener(taskID).then((bool isComplete) {
            Navigator.pop(context);
            if (isComplete) {
              Navigator.pushNamed(context, '/viewer', arguments: FileData(
                  '${StaticMethods.applicationDocumentDirectory}/tmp/tmpFile.pdf',
                  title: row[1],
                  url: row[0],
              ));
            } else {
              StaticMethods.showDownloadFailedDialog(context);
            }
          });

        }
        cursorIndex++;
      }
      if (cursorIndex == 0 || cursorIndex == _listElementsData.length-1) {
        taskID = await StaticMethods.savePdfToTmp(_readUrl);
        StaticMethods.showDownloadingDialog(context, 'cevap anahtarı');
        StaticMethods.fileDownloadListener(taskID).then((bool isComplete) {
          Navigator.pop(context);
          if (isComplete) {
            Navigator.pushNamed(context, '/viewer', arguments: FileData(
                '${StaticMethods.applicationDocumentDirectory}/tmp/tmpFile.pdf',
                title: 'cevap anahtarı',
                url: _readUrl,
            ));
          } else {
            StaticMethods.showDownloadFailedDialog(context);
          }
        });
      }
    }
  }

  Future _scanButtonClick() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      Permission.camera.request().then((PermissionStatus value) {
        if (value == PermissionStatus.granted) {
          _scan();
        } else if (value == PermissionStatus.permanentlyDenied) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Kamera izini'),
                  content: Text(
                      'Karekod okutabilmek için uygulmama ayarlarından kameraya erişim izni verin.'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        openAppSettings();
                      },
                      child: Text('Ayarlara Git'),
                    ),
                  ],
                );
              });
        } else {
          Fluttertoast.showToast(msg: 'Karekod olutmak için kamera izni verin');
        }
      });
    } else {
      _scan();
    }
  }
}
