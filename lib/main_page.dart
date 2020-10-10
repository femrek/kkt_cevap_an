import 'package:Gkktcaa/datas/app_theme.dart';
import 'package:Gkktcaa/datas/user_options.dart';
import 'package:Gkktcaa/pages/main_feed.dart';
import 'package:Gkktcaa/widgets/radio_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{
   bool _savePdfToStorageCheckboxValue = UserOptions.savePdfToStorage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openInBrowser(String url) async {
    if (await canLaunch(url))
      await launch(url);
    else
      throw "Could not launch $url";
  }

  _themeRadioOnChanged(value) {
    setState(() {
      _themeRadioValue = value;
      AppTheme.setTheme(value);
    });
  }
  int _themeRadioValue = AppTheme.theme;
  double _themeMenuHeight = 0;
  double _savePdfToStorageMenuHeight = 0;
  int _savePdfToStorageTitleMaxLines = 1;
  bool _savePdfToStorageTitleSoftWrap = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appColorsDark['scaffoldBg'],
      appBar: AppBar(
        backgroundColor: AppTheme.appBarBg,
        centerTitle: true,
        title: Text(
          'KKT Cevap Anahtarları',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: AppTheme.drawerBg,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        color: AppTheme.drawerTileBg,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _savePdfToStorageMenuHeight = _savePdfToStorageMenuHeight==null ? 0:null;
                                  _savePdfToStorageTitleMaxLines = _savePdfToStorageMenuHeight==null ? 3:1;
                                  _savePdfToStorageTitleSoftWrap = _savePdfToStorageMenuHeight==null;
                                });
                              },
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        'Cihaz Hahızasına Kaydet',
                                        maxLines: _savePdfToStorageTitleMaxLines,
                                        overflow: TextOverflow.fade,
                                        softWrap: _savePdfToStorageTitleSoftWrap,
                                        style: TextStyle(
                                            color: AppTheme.drawerTileText,
                                            fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    Checkbox(
                                      onChanged: (bool isChecked) {
                                        UserOptions.savePdfToStorage = isChecked;
                                        setState(() {
                                          _savePdfToStorageCheckboxValue = isChecked;
                                        });
                                      },
                                      value: _savePdfToStorageCheckboxValue,
                                      activeColor: AppTheme.drawerTileRadioActive,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            AnimatedSize(
                              vsync: this,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              child: SizedBox(
                                height: _savePdfToStorageMenuHeight,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Karekod okutarak veya listeden seçerek açtığınız cevap anahtarları cihaz hafızasına kaydedilir. Bir daha açmak istediğinizde indirilmesi gerekmez',
                                    style: TextStyle(
                                      color: AppTheme.drawerTileText,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        color: AppTheme.drawerTileBg,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _themeMenuHeight = _themeMenuHeight == null ? 0 : null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 16),
                                width: double.infinity,
                                child: Text(
                                  'Tema',
                                  style: TextStyle(
                                    color: AppTheme.drawerTileText,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedSize(
                              vsync: this,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              child: SizedBox(
                                height: _themeMenuHeight,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    children: <Widget>[
                                      Divider(
                                        color: AppTheme.shadowColor,
                                      ),
                                      RadioButton(
                                        value: AppTheme.SYSTEM,
                                        groupValue: _themeRadioValue,
                                        onChanged: _themeRadioOnChanged,
                                        label: 'Sistem Varsayılanı',
                                        textColor: AppTheme.drawerTileText,
                                        textActiveColor: AppTheme.drawerTileTextActive,
                                        radioActiveColor: AppTheme.drawerTileRadioActive,
                                        radioUnselectedColor: AppTheme.drawerTileRadioUnselected,
                                      ),
                                      RadioButton(
                                        value: AppTheme.LIGHT,
                                        groupValue: _themeRadioValue,
                                        onChanged: _themeRadioOnChanged,
                                        label: 'Açık Tema',
                                        textColor: AppTheme.drawerTileText,
                                        textActiveColor: AppTheme.drawerTileTextActive,
                                        radioActiveColor: AppTheme.drawerTileRadioActive,
                                        radioUnselectedColor: AppTheme.drawerTileRadioUnselected,
                                      ),
                                      RadioButton(
                                        value: AppTheme.DARK,
                                        groupValue: _themeRadioValue,
                                        onChanged: _themeRadioOnChanged,
                                        label: 'Koyu Tema',
                                        textColor: AppTheme.drawerTileText,
                                        textActiveColor: AppTheme.drawerTileTextActive,
                                        radioActiveColor: AppTheme.drawerTileRadioActive,
                                        radioUnselectedColor: AppTheme.drawerTileRadioUnselected,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: AppTheme.drawerTileBg
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(width: 16,),
                      Expanded(
                        child: Container(
                          child: Text(
                            "Geliştirici Hakkında",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              color: AppTheme.drawerTileText,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () {
                          openInBrowser("https://www.linkedin.com/in/femrek/");
                        },
                        child: SizedBox(height: 32, width: 32, child: SvgPicture.asset('assets/linkedin_icon.svg', color: AppTheme.drawerTileText,))
                      ),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () {
                          openInBrowser("https://play.google.com/store/apps/dev?id=7986243585950801287");
                        },
                        child: SizedBox(height: 32, width: 32, child: SvgPicture.asset('assets/google_play_icon.svg', color: AppTheme.drawerTileText,))
                      ),
                      SizedBox(width: 16,),
                    ],
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: AppTheme.drawerTileBg
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(width: 16,),
                      Expanded(
                        child: Container(
                          child: Text(
                            "Kaynak Kodlar",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              color: AppTheme.drawerTileText,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16,),
                      GestureDetector(
                          onTap: () {
                            openInBrowser("https://github.com/femrek/kkt_cevap_anahtarlari");
                          },
                          child: SizedBox(height: 32, width: 32, child: SvgPicture.asset('assets/github_icon.svg', color: AppTheme.drawerTileText,))
                      ),
                      SizedBox(width: 16,),
                    ],
                  ),
                ),
                SizedBox(height: 16,),
              ],
            ),
          ),
        ),
      ),
      body: MainFeed(),
    );
  }
}
