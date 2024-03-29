import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ViewPdfScreen extends StatefulWidget {
final  String pdfUrl;
  const ViewPdfScreen({super.key,required this.pdfUrl});

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {

  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController;
  bool loaded = false;

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'chess';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName.pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  // void requestPersmission() async {
  //   await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  // }

  @override
  void initState() {
    // requestPersmission();
    getFileFromUrl(widget.pdfUrl).then(
          (value) => {
        setState(() {
          // if (value) {
            urlPDFPath = value.path;
            loaded = true;
            exists = true;
          // } else {
          //   exists = false;
          // }
        })
      },
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print(urlPDFPath);
    //show pdf
    return Scaffold(
      body: !loaded ? Center(child: Text("Loading..."),) :  PDFView(
        filePath: urlPDFPath,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        nightMode: false,
        onError: (e) {
          Center(child: Text("Something went wrong"),);
        },
        onRender: (pages) {
          setState(() {
            _totalPages = pages!;
            pdfReady = true;
          });
        },
        onViewCreated: (PDFViewController vc) {
          setState(() {
            _pdfViewController = vc;
          });
        },
        onPageChanged: (int? page, int? total) {
          setState(() {
            _currentPage = page!;
          });
        },
        onPageError: (page, e) {},
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            iconSize: 50,
            color: Colors.black,
            onPressed: () {
              setState(() {
                if (_currentPage > 0) {
                  _currentPage--;
                  _pdfViewController.setPage(_currentPage);
                }
              });
            },
          ),
          Text(
            "${_currentPage + 1}/$_totalPages",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: 50,
            color: Colors.black,
            onPressed: () {
              setState(() {
                if (_currentPage < _totalPages - 1) {
                  _currentPage++;
                  _pdfViewController.setPage(_currentPage);
                }
              });
            },
          ),
        ],
      ),
    );
    // if (loaded) {

    // } else {
      // if (exists) {
      //   return Scaffold(
      //     appBar: AppBar(
      //       title: Text("Demo"),
      //     ),
      //     body: Text(
      //       "Loading..",
      //       style: TextStyle(fontSize: 20),
      //     ),
      //   );
      // } else {
      //   //Replace Error UI
      //   return Scaffold(
      //     appBar: AppBar(
      //       title: Text("Demo"),
      //     ),
      //     body: Text(
      //       "PDF Not Available",
      //       style: TextStyle(fontSize: 20),
      //     ),
      //   );
      // }
    }
  }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String urlPDFPath = "";
//   bool exists = true;
//   int _totalPages = 0;
//   int _currentPage = 0;
//   bool pdfReady = false;
//   PDFViewController _pdfViewController;
//   bool loaded = false;
//
//   Future<File> getFileFromUrl(String url, {name}) async {
//     var fileName = 'testonline';
//     if (name != null) {
//       fileName = name;
//     }
//     try {
//       var data = await http.get(url);
//       var bytes = data.bodyBytes;
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/" + fileName + ".pdf");
//       print(dir.path);
//       File urlFile = await file.writeAsBytes(bytes);
//       return urlFile;
//     } catch (e) {
//       throw Exception("Error opening url file");
//     }
//   }
//
//   void requestPersmission() async {
//     await PermissionHandler().requestPermissions([PermissionGroup.storage]);
//   }
//
//   @override
//   void initState() {
//     requestPersmission();
//     getFileFromUrl("http://www.africau.edu/images/default/sample.pdf").then(
//           (value) => {
//         setState(() {
//           if (value != null) {
//             urlPDFPath = value.path;
//             loaded = true;
//             exists = true;
//           } else {
//             exists = false;
//           }
//         })
//       },
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(urlPDFPath);
//     if (loaded) {
//       return Scaffold(
//         body: PDFView(
//           filePath: urlPDFPath,
//           autoSpacing: true,
//           enableSwipe: true,
//           pageSnap: true,
//           swipeHorizontal: true,
//           nightMode: false,
//           onError: (e) {
//             //Show some error message or UI
//           },
//           onRender: (_pages) {
//             setState(() {
//               _totalPages = _pages;
//               pdfReady = true;
//             });
//           },
//           onViewCreated: (PDFViewController vc) {
//             setState(() {
//               _pdfViewController = vc;
//             });
//           },
//           onPageChanged: (int page, int total) {
//             setState(() {
//               _currentPage = page;
//             });
//           },
//           onPageError: (page, e) {},
//         ),
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.chevron_left),
//               iconSize: 50,
//               color: Colors.black,
//               onPressed: () {
//                 setState(() {
//                   if (_currentPage > 0) {
//                     _currentPage--;
//                     _pdfViewController.setPage(_currentPage);
//                   }
//                 });
//               },
//             ),
//             Text(
//               "${_currentPage + 1}/$_totalPages",
//               style: TextStyle(color: Colors.black, fontSize: 20),
//             ),
//             IconButton(
//               icon: Icon(Icons.chevron_right),
//               iconSize: 50,
//               color: Colors.black,
//               onPressed: () {
//                 setState(() {
//                   if (_currentPage < _totalPages - 1) {
//                     _currentPage++;
//                     _pdfViewController.setPage(_currentPage);
//                   }
//                 });
//               },
//             ),
//           ],
//         ),
//       );
//     } else {
//       if (exists) {
//         //Replace with your loading UI
//         return Scaffold(
//           appBar: AppBar(
//             title: Text("Demo"),
//           ),
//           body: Text(
//             "Loading..",
//             style: TextStyle(fontSize: 20),
//           ),
//         );
//       } else {
//         //Replace Error UI
//         return Scaffold(
//           appBar: AppBar(
//             title: Text("Demo"),
//           ),
//           body: Text(
//             "PDF Not Available",
//             style: TextStyle(fontSize: 20),
//           ),
//         );
//       }
//     }
//   }
// }