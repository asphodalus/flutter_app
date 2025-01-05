import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;
void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.deepPurple
      ),
      home: const MyHomePage(title: 'App'),
      initialRoute: "/home",
      routes: {
    '/home': (context) => const MyHomePage(title: "Home",),
    '/info': (context) => const InfoPage(),
    "/login": (context) => const LoginPage(),
  },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentTime = "";

  DateTime now = DateTime.now();
  int touchedIndex = -1;
  bool loading = true;
  Map nceaData = {
    "name": "student",
    "not_achieved": 0,
    "achieved": 0,
    "merit": 0,
    "excellence": 0
  };
  var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  var attendenceData = {
    "1": {
      "p1": {},
      "p2": {},
      "p3": {},
      "p4": {},
      "p5": {},
      "p6": {},
    },
    "2": {
      "p1": {},
      "p2": {},
      "p3": {},
      "p4": {},
      "p5": {},
      "p6": {},
    },
    "3": { // Fixed typo
      "p1": {},
      "p2": {},
      "p3": {},
      "p4": {},
      "p5": {},
      "p6": {},
    },
    "4": {
      "p1": {},
      "p2": {},
      "p3": {},
      "p4": {},
      "p5": {},
      "p6": {},
    },
    "5": {
      "p1": {},
      "p2": {},
      "p3": {},
      "p4": {},
      "p5": {},
      "p6": {},
    },
  };
  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('MM/dd/yyyy hh:mm:ss').format(DateTime.now());
      now = DateTime.now();
    });
  }



Future<void> fetchPortal(String username, String pwd) async {
  final decoder = utf8.decoder;
  List<String> newRawCookies = [];
  List<String> newNewRawCookies = [];
  List<String> rawCookies = [];
  String userStudentID = username;
  String userpwd = pwd;
  String ts;
  String portalurl;
  String kmr;
  String authData;
  String jsurl;
  print(username);
  var studentInfo = {
    "name": "Unknown",
    "not_achieved": 0,
    "achieved": 0,
    "merit": 0,
    "excellence": 0
  };

  final res = await http.get(
    Uri.parse("https://portal.westlake.school.nz"),
    headers: {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9",
      "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      "priority": "u=0, i",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36",
      "upgrade-insecure-requests": "1"
    },
  );

  final arrayBuffer = res.bodyBytes;
  final content = decoder.convert(arrayBuffer);

  res.headers.forEach((key, value) {
    if (key == 'set-cookie') {
      for (var val in value.split(",")) {
        
        rawCookies.add(val);
      }

      
    }
  });

  final document = html.parse(content);
  final authElement = document.querySelector("#auth");
  authData = authElement?.attributes[authElement.attributes.keys.elementAt(2)] ?? "";

  if (document.querySelectorAll("script")[3].attributes['src'] == "https://portal.westlake.school.nz/assets/javascript.js?v2024.02.003") {
    jsurl = document.querySelectorAll("script")[3].attributes['src'] ?? "";
  } else {
    jsurl = document.querySelectorAll("script")[4].attributes['src'] ?? "";
  }

  final jsfetch = await http.get(Uri.parse(jsurl));
  final jsab = jsfetch.bodyBytes;
  final js = decoder.convert(jsab);

  kmr = js.split('\$(\'<input type="hidden" name="')[1].substring(0, 35);

  ts = js.split('name="_ts" class="a-ts" value="')[1].substring(0, 10);
  portalurl = js.split("url: \$form.prop('action') +'")[1].substring(0, 65);

  final portalfetch = await http.post(
    Uri.parse("https://portal.westlake.school.nz/$portalurl"),
    headers: {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9",
      "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      "priority": "u=1, i",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "x-requested-with": "XMLHttpRequest",
      "cookie": "${rawCookies[0].split(";")[0]}; ${rawCookies[2].split(";")[0]}",
      "Referer": "https://portal.westlake.school.nz/",
      "Referrer-Policy": "strict-origin-when-cross-origin"
    },
    body: "username=$userStudentID&password=$userpwd&$kmr=$authData&_ts=$ts",
  );

  if (portalfetch.statusCode != 200) {
    throw Exception('Failed to fetch! Status: ${portalfetch.statusCode}');
  }

  portalfetch.headers.forEach((key, value) {
    if (key == 'set-cookie') {
      for (var val in value.split(",")) {
        newRawCookies.add(val);
      }
      //newRawCookies.add(value);
    }
  });

  final detailf = await http.get(
    Uri.parse("https://portal.westlake.school.nz/details"),
    headers: {
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      "accept-language": "en-US,en;q=0.9",
      "cache-control": "max-age=0",
      "priority": "u=0, i",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "same-origin",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "cookie": "${rawCookies[2].split(";")[0]}; ${newRawCookies[0].split(";")[0]}",
      "Referer": "https://portal.westlake.school.nz/",
      "Referrer-Policy": "strict-origin-when-cross-origin"
    },
  );
  
  final body = detailf.bodyBytes;
  final mainContent = decoder.convert(body);

  detailf.headers.forEach((key, value) {
    if (key == 'set-cookie') {
      for (var val in value.split(",")) {
        
        newNewRawCookies.add(val);
      }
      
    }
  });
  dom.Document detailsPageDocument = html.parse(mainContent);
  String studentName = detailsPageDocument.querySelector("span.print-show")?.innerHtml.split(" - ")[1] ?? "student";
  print(studentName);
  //print(mainContent);

  // Your cookies data should be assigned here appropriately.

  
  final headers = {
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "accept-language": "en-US,en;q=0.9",
    "cache-control": "max-age=0",
    "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Windows\"",
    "sec-fetch-dest": "document",
    "sec-fetch-mode": "navigate",
    "sec-fetch-site": "same-origin",
    "sec-fetch-user": "?1",
    "upgrade-insecure-requests": "1",
    "cookie": "${rawCookies[1]}; ${rawCookies[2]}; ${newNewRawCookies[0]}; ${newNewRawCookies[1]}",
    "Referer": "https://portal.westlake.school.nz/details",
    "Referrer-Policy": "strict-origin-when-cross-origin"
  };

  final nceaRes = await http.get(Uri.parse("https://portal.westlake.school.nz/ncea_summary"), headers: headers);
  final nceaDetails = decoder.convert(nceaRes.bodyBytes);

  final nceaDom = html.parse(nceaDetails);
  studentInfo["name"] = studentName;
  studentInfo['not_achieved'] = nceaDom.querySelector(".notachieved")?.innerHtml.split("<strong>")[1].split("</strong>")[0] ?? 0;
  studentInfo['achieved'] = nceaDom.querySelector(".achieved")?.innerHtml.split("<strong>")[1].split("</strong>")[0] ?? 0;
  studentInfo['merit'] = nceaDom.querySelector(".merit")?.innerHtml.split("<strong>")[1].split("</strong>")[0] ?? 0;
  studentInfo['excellence'] = nceaDom.querySelector(".excellence")?.innerHtml.split("<strong>")[1].split("</strong>")[0] ?? 0;
  

  final directory = await getApplicationDocumentsDirectory();
  var docpath = directory.path;

  File dataFile = File('$docpath/cache.lol');
  dataFile.writeAsStringSync(jsonEncode(studentInfo), mode: FileMode.writeOnly);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('excellence', '${studentInfo["excellence"]}');
  await prefs.setString('merit', '${studentInfo["merit"]}');
  await prefs.setString('achieved', '${studentInfo["achieved"]}');
  await prefs.setString('not_achieved', '${studentInfo["not_achieved"]}');
  print("Data stored in SharedPreferences");
  setState(() {
    nceaData.addAll(studentInfo);
  });
}


  void fetchAttendenceData(String username, String pwd)async{
      final decoder = utf8.decoder;
  List<String> newRawCookies = [];
  List<String> newNewRawCookies = [];
  List<String> rawCookies = [];
  String userStudentID = username;
  String userpwd = pwd;
  String ts;
  String portalurl;
  String kmr;
  String authData;
  String jsurl;


  final res = await http.get(
    Uri.parse("https://portal.westlake.school.nz"),
    headers: {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9",
      "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      "priority": "u=0, i",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36",
      "upgrade-insecure-requests": "1"
    },
  );

  final arrayBuffer = res.bodyBytes;
  final content = decoder.convert(arrayBuffer);

  res.headers.forEach((key, value) {
    if (key == 'set-cookie') {
      for (var val in value.split(",")) {
        
        rawCookies.add(val);
      }

      
    }
  });

  final document = html.parse(content);
  final authElement = document.querySelector("#auth");
  authData = authElement?.attributes[authElement.attributes.keys.elementAt(2)] ?? "";

  if (document.querySelectorAll("script")[3].attributes['src'] == "https://portal.westlake.school.nz/assets/javascript.js?v2024.02.003") {
    jsurl = document.querySelectorAll("script")[3].attributes['src'] ?? "";
  } else {
    jsurl = document.querySelectorAll("script")[4].attributes['src'] ?? "";
  }

  final jsfetch = await http.get(Uri.parse(jsurl));
  final jsab = jsfetch.bodyBytes;
  final js = decoder.convert(jsab);
  //print(js);
  kmr = js.split('\$(\'<input type="hidden" name="')[1].substring(0, 35);

  ts = js.split('name="_ts" class="a-ts" value="')[1].substring(0, 10);
  portalurl = js.split("url: \$form.prop('action') +'")[1].substring(0, 65);

  final portalfetch = await http.post(
    Uri.parse("https://portal.westlake.school.nz/$portalurl"),
    headers: {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9",
      "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      "priority": "u=1, i",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "x-requested-with": "XMLHttpRequest",
      "cookie": "${rawCookies[0].split(";")[0]}; ${rawCookies[2].split(";")[0]}",
      "Referer": "https://portal.westlake.school.nz/",
      "Referrer-Policy": "strict-origin-when-cross-origin"
    },
    body: "username=$userStudentID&password=$userpwd&$kmr=$authData&_ts=$ts",
  );

  if (portalfetch.statusCode != 200) {
    throw Exception('Failed to fetch! Status: ${portalfetch.statusCode}');
  }

  portalfetch.headers.forEach((key, value) {
    if (key == 'set-cookie') {
      for (var val in value.split(",")) {
        newRawCookies.add(val);
      }
      //newRawCookies.add(value);
    }
  });


  final detailf = await http.get(
    Uri.parse("https://portal.westlake.school.nz/details"),
    headers: {
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      "accept-language": "en-US,en;q=0.9",
      "cache-control": "max-age=0",
      "priority": "u=0, i",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "same-origin",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "cookie": "${rawCookies[2].split(";")[0]}; ${newRawCookies[0].split(";")[0]}",
      "Referer": "https://portal.westlake.school.nz/",
      "Referrer-Policy": "strict-origin-when-cross-origin"
    },
  );


  detailf.headers.forEach((key, value) {
    if (key == 'set-cookie') {
      for (var val in value.split(",")) {
        
        newNewRawCookies.add(val);
      }
      
    }
  });

  //print(mainContent);

  // Your cookies data should be assigned here appropriately.

  
  final headers = {
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "accept-language": "en-US,en;q=0.9",
    "cache-control": "max-age=0",
    "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Windows\"",
    "sec-fetch-dest": "document",
    "sec-fetch-mode": "navigate",
    "sec-fetch-site": "same-origin",
    "sec-fetch-user": "?1",
    "upgrade-insecure-requests": "1",
    "cookie": "${rawCookies[1]}; ${rawCookies[2]}; ${newNewRawCookies[0]}; ${newNewRawCookies[1]}",
    "Referer": "https://portal.westlake.school.nz/details",
    "Referrer-Policy": "strict-origin-when-cross-origin"
  };

  final attendenceRes = await http.get(Uri.parse("https://portal.westlake.school.nz/attendance"), headers: headers);
  final attendenceDetails = decoder.convert(attendenceRes.bodyBytes);

  final attendenceDom = html.parse(attendenceDetails);
  var attendenceDomData = jsonEncode(returnAttendanceData(attendenceDom));
  var dData = jsonDecode(attendenceDomData);
    for (var data in dData["title_row"].keys) {
      // print(dData["title_row"][data]);
      days.add(dData["title_row"][data]);
    }

    days.removeRange(0, 5);
    days.remove("header");
    days.remove("&nbsp; &nbsp;");
    for (var period in dData.keys) {
      var periodData = dData[period];
      for (var day in periodData.keys) {
        if (attendenceData.containsKey("$day")) {
          if (periodData["$day"] != "N/A") {
            //print(periodData["$day"]);
            attendenceData[day]?[period]?.addAll(periodData[day] ?? {"Lol"});
          } else {
            //print(periodData["day"]);
            attendenceData[day]?[period]?.addAll({"classCode": "N/A", "misc": "N/A"});
          }
        
        } else {
          //print("$day not in map");
        }
      }
    }
  }
  void buildPage() async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    bool loginFileExists = File('$path/data.lol').existsSync();
    if (!loginFileExists) {
      if (context.mounted && mounted) Navigator.pushNamed(context, "/login");
    } else {
      try {
        File userCreds = File('$path/data.lol');
        String userPostData = userCreds.readAsStringSync();
        //fetchData('/', userPostData);
        fetchPortal(userPostData.split("&")[0], userPostData.split("&")[1]);
        //print("No cache file");
      } catch (e) {
        File data = File('$path/cache.lol');
        String userData = data.readAsStringSync();
        var decodedResponse = jsonDecode(userData) as Map;
        setState(() {
            nceaData.addAll(decodedResponse);
        });
      }
    }
  }
  Color periodColorPicker(DateTime time, int row, int column) {
    if (time.weekday == (column + 1) && "p${row + 1}" == reportPeriod(time)) {

      return const Color.fromARGB(255, 204, 57, 230);
    } else if (time.weekday == (column + 1)){
      return const Color.fromARGB(255, 245, 77, 65);
    } else if ("p${row + 1}" == reportPeriod(time)) {
      return Colors.lightBlue;
    } else {
      return Colors.white;
    }
  }
  String reportPeriod(DateTime ctime) {
    var now = DateTime.now();
    final p1 = DateTime(now.year, now.month, now.day, 8, 55);
    final p2v = DateTime(now.year, now.month, now.day, 9, 20);
    final p2am = DateTime(now.year, now.month, now.day, 9, 35);
    final p2 = DateTime(now.year, now.month, now.day, 9, 50);
    final p3 = DateTime(now.year, now.month, now.day, 11, 10);
    final p4 = DateTime(now.year, now.month, now.day, 12, 00);
    final p5 = DateTime(now.year, now.month, now.day, 13, 25);
    final p6 = DateTime(now.year, now.month, now.day, 14, 20);
    if (now.isAfter(p1) && now.isBefore(p2)) {
      return "p1";
    } else if (now.isAfter(p2) && now.isBefore(p3)) {
      return "p2";
    } else if (now.isAfter(p3) && now.isBefore(p4)) {
      return "p3";
    } else if (now.isAfter(p4) && now.isBefore(p5)) {
      return "p4";
    } else if (now.isAfter(p5) && now.isBefore(p6)) {
      return "p5";
    } else if (now.isAfter(p6)) {
      return "p6";
    } else if (now.isAfter(p2v) && now.isBefore(p3) && DateTime.now().weekday == 5) {
      return "p2 - assembly at 10:15";
    } else if (now.isAfter(p2am) && now.isBefore(p3) && DateTime.now().weekday == 1) {
      return "p2 - assembly at 10:15";
    } else {
      return ":(";
    }
  }
  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.yellow,
            value: double.parse(nceaData['excellence'].toString()),
            title: nceaData['excellence'].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.blueGrey,
            value: double.parse(nceaData['merit'].toString()),
            title: nceaData['merit'].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.brown,
            value: double.parse(nceaData['achieved'].toString()),
            title: nceaData['achieved'].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.white,
            value: double.parse(nceaData['not_achieved'].toString()),
            title: nceaData['not_achieved'].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  void _update() {
    buildPage();
    fetchAttendenceData("mz20335", "c5Pparis");
  }
  void _scheduleDailyUpdate() {
    _update();
    // Schedule a timer to update every 24 hours
    Timer.periodic(const Duration(days: 1), (timer) => _update());
  }

  @override
  void initState() {
    super.initState();
    _update();
    _updateTime();
    
    Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);
    // Set a timer to update at midnight
    Timer(durationUntilMidnight, _scheduleDailyUpdate);

  }
  @override
  Widget build(BuildContext context) {
    
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView( // Added this to handle overflow in smaller screens
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.05),

                Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.5, // 20% of the Column height
                  child: Padding(
                padding: EdgeInsets.only(left: constraints.maxWidth *0.05, right:  constraints.maxWidth * 0.025),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: (Colors.white).withOpacity(0.8)
                  ),
                  width: constraints.maxWidth * 0.425, // 30% of the Row width
                  height: constraints.maxHeight * 0.5, // 20% of the Row height
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome", style: GoogleFonts.roboto(fontSize: 70),
                          ),
                        Text(
                          nceaData["name"],
                          style: GoogleFonts.roboto(fontSize: 50),
                        )
                      ],
                    ),
                  ),
                ),
              ),

                ),
                SizedBox(height: constraints.maxHeight * 0.05), // Spacing between containers
                SizedBox(
                  height: constraints.maxHeight * 0.5, // 40% of the Column height
                  child: Padding(
                padding: EdgeInsets.only(left: constraints.maxWidth * 0.025, right: constraints.maxWidth *0.05),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: (Colors.white).withOpacity(0.8)
                  ),
                  width: constraints.maxWidth * 0.425, // 30% of the Row width
                  height: constraints.maxHeight * 0.5, // 20% of the Row height
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_currentTime, style: GoogleFonts.roboto(fontSize: 30),),
                      Text("Current class - ${attendenceData["${now.weekday}"]?[reportPeriod(now)]?["classCode"] ?? "No class found!"} | ${attendenceData["${now.weekday}"]?[reportPeriod(now)]?["misc"] ?? ""}", style: GoogleFonts.roboto(fontSize: 30)),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      Center(
        child: ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(10),
                  child: Table(
    //border: TableBorder.all(),
    children: [
      // Hard-coded table row at the top
      TableRow(
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0))
        ),
        children: List.generate(5, (columnIndex) {
          return Container(
            height: 50, // Optional: Different color for the header
            child: Center(
              child: Text(
                "${days[columnIndex]}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ),
      // Dynamic table rows
      ...List.generate(6, (rowIndex) {
        return TableRow(
          children: List.generate(5, (columnIndex) {
            return Container(
              height: 50,
              color: periodColorPicker(now, rowIndex, columnIndex),//(rowIndex + columnIndex) % 2 == 0 ? Colors.grey[300] : Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${attendenceData["${columnIndex + 1}"]?["p${rowIndex + 1}"]?["classCode"] ?? "N/A"}" ),
                    Text("${attendenceData["${columnIndex + 1}"]?["p${rowIndex + 1}"]?["misc"] ?? "N/A"}")
                  ],
                ),
              ),
            );
          }),
        );
      }),
    ],
  ),
                ),
              ),
            ),
          ),
          child: const Text("View full attendence"),
        ),
      ),
                    ],
                  )
                ),
              ),

                ),
              ],
            ),                   
            const SizedBox(
                    height: 28,
                  ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth* 0.05),
              child:             
              Container(
              decoration: BoxDecoration(
                color: (Colors.white).withOpacity(0.8),
                borderRadius: BorderRadius.circular(32.0)
                
              ),
              child: AspectRatio(
              aspectRatio: 2,
              child: Column(

                children: <Widget>[
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                  
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Indicator(
                        color: Colors.yellow,
                        text: 'Excellence',
                        isSquare: false,
                        size: touchedIndex == 0 ? 18 : 16,
                        textColor: touchedIndex == 0
                            ? Colors.cyan
                            : Colors.black,
                      ),
                      Indicator(
                        color: Colors.blueGrey,
                        text: 'Merit',
                        isSquare: false,
                        size: touchedIndex == 1 ? 18 : 16,
                        textColor: touchedIndex == 1
                            ? Colors.white
                            : Colors.black,
                      ),
                      Indicator(
                        color: Colors.brown,
                        text: 'Achieved',
                        isSquare: false,
                        size: touchedIndex == 2 ? 18 : 16,
                        textColor: touchedIndex == 2
                            ? Colors.white
                            : Colors.black,
                      ),
                      Indicator(
                        color: Colors.white,
                        text: 'Not Achieved',
                        isSquare: false,
                        size: touchedIndex == 3 ? 18 : 16,
                        textColor: touchedIndex == 3
                            ? Colors.white
                            : Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.075,
                  ),
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                        child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),

                ],
              ),
            ),
            )
            ), 
            const SizedBox(
                    height: 28,
                  )
              ],
            ),
          );
        },
      ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> Navigator.pushNamed(context, "/login"),
        tooltip: 'Go to Login',
        child: const Icon(Icons.person),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.pushNamed(context, "/");
          },
        ),
      ),
    );
  }

}
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState()  => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final textController = TextEditingController();
  final pwdController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SizedBox(
                height: constraints.maxHeight * 0.9, // 30% of the Column height
                child: LayoutBuilder(
                  builder: (context, innerConstraints) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                      child: Container(
                      width: innerConstraints.maxWidth * 0.9, // 40% of inner width
                      child: Center(
                        child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Sign in to the Portal:", style: GoogleFonts.roboto(fontSize: 20),),
        SizedBox(height: constraints.maxHeight*0.1,),
        const Text("Username/Student ID"), 
        TextField(
          controller: textController,
        ),
        const Text("Password"),
        TextField(controller: pwdController, obscureText: true,),
        SizedBox(
          height: constraints.maxHeight*0.05,
        ),
        ElevatedButton(
          onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text("Logging in"),
              );
            },
          );
          try {

            var username = textController.text;
            var password = pwdController.text;
            final decoder = utf8.decoder;

  List<String> rawCookies = [];

  String ts;
  String portalurl;
  String kmr;
  String authData;
  String jsurl;

  final res = await http.get(
    Uri.parse("https://portal.westlake.school.nz"),
    headers: {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9",
      "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      "priority": "u=0, i",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36",
      "upgrade-insecure-requests": "1"
    },
  );

  final arrayBuffer = res.bodyBytes;
  final content = decoder.convert(arrayBuffer);

  res.headers.forEach((key, value) {
    if (key == 'set-cookie') {
      for (var val in value.split(",")) {
        
        rawCookies.add(val);
      }

      
    }
  });

  final document = html.parse(content);
  final authElement = document.querySelector("#auth");
  authData = authElement?.attributes[authElement.attributes.keys.elementAt(2)] ?? "";

  if (document.querySelectorAll("script")[3].attributes['src'] == "https://portal.westlake.school.nz/assets/javascript.js?v2024.02.003") {
    jsurl = document.querySelectorAll("script")[3].attributes['src'] ?? "";
  } else {
    jsurl = document.querySelectorAll("script")[4].attributes['src'] ?? "";
  }

  final jsfetch = await http.get(Uri.parse(jsurl));
  final jsab = jsfetch.bodyBytes;
  final js = decoder.convert(jsab);
  //print(js);
  kmr = js.split('\$(\'<input type="hidden" name="')[1].substring(0, 35);
  print(kmr);
  ts = js.split('name="_ts" class="a-ts" value="')[1].substring(0, 10);
  portalurl = js.split("url: \$form.prop('action') +'")[1].substring(0, 65);

  final portalfetch = await http.post(
    Uri.parse("https://portal.westlake.school.nz/$portalurl"),
    headers: {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9",
      "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      "priority": "u=1, i",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Opera GX\";v=\"112\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "x-requested-with": "XMLHttpRequest",
      "cookie": "${rawCookies[0].split(";")[0]}; ${rawCookies[2].split(";")[0]}",
      "Referer": "https://portal.westlake.school.nz/",
      "Referrer-Policy": "strict-origin-when-cross-origin"
    },
    body: "username=$username&password=$password&$kmr=$authData&_ts=$ts",
  );
  final bodyBytes = portalfetch.bodyBytes;
  final bodyString = decoder.convert(bodyBytes);
  final Map<String, dynamic> jsonResponse = jsonDecode(bodyString);

  if (portalfetch.statusCode != 200) {
    print('Error status: ${jsonResponse['status']}');
  } else {
    print('Success');
  }
  print(jsonResponse['status']);
            textController.clear();
            pwdController.clear();

            // print(status);
            if (jsonResponse['status'] != 200) {
              // wipe form
              if (context.mounted) {
                showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Invalid username or password - code ${jsonResponse['status']}"),
                  );
                },
              );
              }
            } else if (jsonResponse['status'] == 200) {
              final directory = await getApplicationDocumentsDirectory();
              var path = directory.path;
              File userCreds = File('$path/data.lol');
              userCreds.writeAsString('$username&$password');
              // print("data written");
              if (context.mounted) {
                // print("context mounted");
                

                showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("success"),
                  );
                },
              );
              // Write data to file
            
                Navigator.pushNamed(context, "/home");
              }

              
            }
          } catch (e) {
            if (context.mounted){
            showDialog(context: context, builder: 
            (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text(e.toString()),
                  );
                },);
            }

          }

            
        }, 
          child: const Text("Sign in")
          )
        ],
        )
        )
      ),
                      ),
                    ),
                      );
                  },
                ),
              ));
        },
      )
    );
  }
}




class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(10.0), 
    child: Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    ),
    );
  }
}




Map<String, dynamic> returnAttendanceData(dom.Document dom) {
  return {
    'title_row': sortTitleRow(dom.querySelector('thead')!),
    'admin': sortBodyRow(dom.querySelectorAll('tbody')[1].children[0]),
    'p1': sortBodyRow(dom.querySelectorAll('tbody')[1].children[1]),
    'p2': sortBodyRow(dom.querySelectorAll('tbody')[1].children[2]),
    'p3': sortBodyRow(dom.querySelectorAll('tbody')[1].children[3]),
    'p4': sortBodyRow(dom.querySelectorAll('tbody')[1].children[4]),
    'p5': sortBodyRow(dom.querySelectorAll('tbody')[1].children[5]),
    'p6': sortBodyRow(dom.querySelectorAll('tbody')[1].children[6]),
  };
}

Map<String, dynamic> sortTitleRow(dom.Element element) {
  return {
    'type': 'header',
    'header': '${element.children[0].children[0].innerHtml.split('<')[0]} ${element.children[0].children[0].innerHtml}',
    '1': '${element.children[0].children[1].innerHtml.split('<')[0]} ${element.children[0].children[1].innerHtml.split('<')[1].split('>')[1]}',
    '2': '${element.children[0].children[2].innerHtml.split('<')[0]} ${element.children[0].children[2].innerHtml.split('<')[1].split('>')[1]}',
    '3': '${element.children[0].children[3].innerHtml.split('<')[0]} ${element.children[0].children[3].innerHtml.split('<')[1].split('>')[1]}',
    '4': '${element.children[0].children[4].innerHtml.split('<')[0]} ${element.children[0].children[4].innerHtml.split('<')[1].split('>')[1]}',
    '5': '${element.children[0].children[5].innerHtml.split('<')[0]} ${element.children[0].children[5].innerHtml.split('<')[1].split('>')[1]}',
  };
}

Map<String, dynamic> parseCell(String string) {
  List<String> array = string.split('\n');
  if (array.length == 10) {
    return {
      'time': array[2].trim().split('>')[1].split('<')[0],
      'classCode': array[5].trim().substring((array[5].trim().length - 3)),
      'misc': array[5].trim().substring(0, 3)
    };
  } else {
    return {'status': 'N/A'};
  }
}

Map<String, dynamic> sortBodyRow(dom.Element element) {
  return {
    'type': 'body',
    'period': element.children[0].children[0].innerHtml.trim(),
    '1': parseCell(element.children[1].innerHtml),
    '2': parseCell(element.children[2].innerHtml),
    '3': parseCell(element.children[3].innerHtml),
    '4': parseCell(element.children[4].innerHtml),
    '5': parseCell(element.children[5].innerHtml),
  };
}