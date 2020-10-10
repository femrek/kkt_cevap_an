import 'dart:io';

import 'package:Gkktcaa/datas/app_theme.dart';
import 'package:Gkktcaa/datas/file_data.dart';
import 'package:Gkktcaa/datas/user_options.dart';
import 'package:Gkktcaa/static_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainFeedListElement extends StatefulWidget {
  MainFeedListElement({
    this.title,
    this.path,
    this.url,
  });

  final String title;
  final String path;
  final String url;

  void downloadFile(bool isOpenFileAfterDownload) {
    state.downloadFile(isOpenFileAfterDownload);
  }

  _MainFeedListElementState state;

  @override
  State<StatefulWidget> createState() {
    state = _MainFeedListElementState();
    return state;
  }
}

class _MainFeedListElementState extends State<MainFeedListElement> {
  Future<bool> _returnTrue() async {
    return await true;
  }

  Future<bool> _returnFalse() async {
    return await false;
  }

  Future<bool> _downloadIconFuture;

  @override
  void initState() {
    super.initState();
    _downloadIconFuture = StaticMethods.detectDownloadedFile(widget.url).then((value) => _isDownloaded = value);
  }

  downloadFile(bool isOpenFileAfterDownload) {
    StaticMethods.savePdfToStorage(widget.url).then((String taskId) {
      StaticMethods.fileDownloadListener(taskId).then((bool isComplete) {
        setState(() {
          _isDownloaded = isComplete;
          _isDownloading = false;
          _downloadIconFuture = isComplete ? _returnTrue():_returnFalse();
        });
        if(isOpenFileAfterDownload) {
          if (isComplete){
            Navigator.pop(context);
            Navigator.pushNamed(
                context,
                '/viewer',
                arguments: FileData(widget.path, title: widget.title, url: widget.url)
            );
          } else {
            Navigator.pop(context);
            StaticMethods.showDownloadFailedDialog(context);
          }
        }
      });
    });
    setState(() {
      _isDownloading = true;
      _downloadIconFuture = _returnFalse();
    });
    if (isOpenFileAfterDownload) {
      StaticMethods.showDownloadingDialog(context, widget.title);
    }
  }

  bool _isDownloaded = false;
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isDownloaded) {
          Navigator.pushNamed(
            context,
            '/viewer',
            arguments: FileData(widget.path, title: widget.title, url: widget.url));
        } else {
          if (UserOptions.savePdfToStorage) {
            downloadFile(true);
          } else {
            StaticMethods.showDownloadingDialog(context, widget.title);
            StaticMethods.savePdfToTmp(widget.url).then((value) {
              StaticMethods.fileDownloadListener(value).then((value) {
                Navigator.pop(context);
                if (value) {
                  Navigator.pushNamed(
                    context,
                    '/viewer',
                    arguments: FileData(
                      '${StaticMethods.applicationDocumentDirectory}/tmp/tmpFile.pdf',
                      url: widget.url,
                      title: widget.title,
                    ),
                  );
                } else {
                  StaticMethods.showDownloadFailedDialog(context);
                }
              });
            });
          }
        }
      },
      onLongPress: () {
        Fluttertoast.showToast(msg: widget.title);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            color: AppTheme.cardBg,
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowColor,
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3))
            ]),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                widget.title,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(color: AppTheme.cardTitle, fontSize: 18),
              ),
            ),
            FutureBuilder(
              future: _downloadIconFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                    backgroundColor: snapshot.data
                        ? AppTheme.cardAlertBg
                        : AppTheme.accent,
                    child: IconButton(
                      onPressed: () {
                        if (snapshot.data) {
                          StaticMethods.deleteFileFromStorage(widget.path).then((value) {
                            setState(() {
                              _downloadIconFuture = _returnFalse();
                              _isDownloaded = false;
                            });
                          });
                        } else if (!_isDownloading) {
                          downloadFile(false);
                        }
                      },
                      icon: _isDownloading ?
                      CircularProgressIndicator()
                          :
                      Icon(
                        snapshot.data ? Icons.delete : Icons.file_download,
                        color: snapshot.data
                            ? AppTheme.onCardAlert
                            : AppTheme.onAccent,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 32,
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
