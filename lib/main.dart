import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:save_and_copy_text/localdb/db.dart';
import 'package:save_and_copy_text/popscreen.dart';
import 'package:clipboard/clipboard.dart';
import 'package:toast/toast.dart';
import 'localdb/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Hive.initFlutter();
  Hive.registerAdapter(DataAdapter());
  await Hive.openBox('info');

  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.red,
    ),
    home: Myapp(),
    debugShowCheckedModeBanner: false,
  ));
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  double productprice;
  BannerAd myBanner;
  bool isloaded;
  @override
  void initState() {
    super.initState();
    myBanner = BannerAd(
      adUnitId: "ca-app-pub-6812988945725571/6356328399",
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) {
        setState(() {
          isloaded = true;
        });
      }, onAdFailedToLoad: (_, error) {
        print(error);
      }),
    );

    myBanner.load();
  }

  Widget ad() {
    if (isloaded == true) {
      return Container(
          alignment: Alignment.center,
          child: AdWidget(ad: myBanner),
          width: myBanner.size.width.toDouble(),
          height: myBanner.size.height.toDouble());
    } else {
      return Text('ad');
    }
  }

  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('data')),
      ),
      body: FutureBuilder(
        future: Hive.openBox('info'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError)
            return Center(child: Text(snapshot.error.toString()));
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'no data found',
                style: TextStyle(fontSize: 30),
              ),
            );
          } else {
            return buildlist();
          }
        },
      ),
      bottomNavigationBar: ad(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Popscreen()));
        },
      ),
    );
  }
}

Widget buildlist() {
  final box = Hive.box('info');
  return WatchBoxBuilder(
      box: box,
      builder: (context, box) {
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final detail = box.getAt(index) as Data;
            return ListTile(
              onTap: () {
                FlutterClipboard.copy(detail.data).then((value) => Toast.show(
                    detail.data + ' text copied', context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM));
              },
              title: Text(detail.data),
              trailing: IconButton(
                onPressed: () {
                  Db().deletedata(index);
                },
                icon: Icon(Icons.delete_outline),
              ),
            );
          },
        );
      });
}
