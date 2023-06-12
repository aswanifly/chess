Map chessPieces = {
  "black": [
    {"name": "black pawn", "imagePath": "assets/black/Pawn-black.svg"},
    {"name": "black knight", "imagePath": "assets/black/Knight-black.svg"},
    {"name": "black rook", "imagePath": "assets/black/Rook-black.svg"},
    {"name": "black bishop", "imagePath": "assets/black/Bishop-black.svg"},
    {"name": "black queen", "imagePath": "assets/black/Queen-black.svg"},
    {"name": "black king", "imagePath": "assets/black/King-black.svg"},
  ],
  "white": [
    {"name": "white pawn", "imagePath": "assets/white/Pawn-white.svg"},
    {"name": "white knight", "imagePath": "assets/white/Knight-white.svg"},
    {"name": "white rook", "imagePath": "assets/white/Rook-white.svg"},
    {"name": "white bishop", "imagePath": "assets/white/Bishop-white.svg"},
    {"name": "white queen", "imagePath": "assets/white/Queen-white.svg"},
    {"name": "white king", "imagePath": "assets/white/King-white.svg"},
  ]
};


final List alphaAndNum = [
  ["a", "b", "c", "d"],
  ["e", "f", "g", "h"],
  ["1", "2", "3", "4"],
  ["5", "6", "7", "8"],
];



final List symbols = ["0-0", "0-0-0", "x", "+", "#","="];

final List<Map> timeTileList = [
  {"1":"Bullet","2":"1", "3":"1/1","4":"2/1"},
  {"1":"Blitz","2":"3", "3":"3/2","4":"5 min"},
  {"1":"Rapid","2":"10", "3":"15/10","4":"30 min"},
];

Map pieceColorPath = {
  "black" :"assets/svg/blackKing.svg",
  "white" : "assets/svg/whiteKing.svg"
};