import 'package:chess/extensions/collection_extensions.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'piece.dart';
import 'motion.dart';

class Bot {
  static const dbg=kDebugMode;
  static const tag = '[Chess.Bot]';
  static const int MATE_VALUE = 10000;  
  static const int WIN_VALUE = MATE_VALUE - 100; 

  final List<List<int>> _board;
  final Map<int, Piece> _pieceMap;
  int _depth ;
  late Motion _foul;
  final ChessColor _color;

  int _number = 0;
  static Random  rand=Random();

  Bot(this._board, this._pieceMap,this._color,  this._depth);

  Motion calc(String pace, Motion foul) {
    
    _foul = foul;
    _number = 0;
    
    var vl=_alphaBeta(-MATE_VALUE ,MATE_VALUE, _depth,_board.clone2d(),_color);
    if (vl == null || vl.value == -WIN_VALUE) {
      _depth=2;
      
      vl=_alphaBeta(-MATE_VALUE ,MATE_VALUE, _depth, _board.clone2d(),_color);
    }

    if (vl != null && vl.value != -WIN_VALUE) {
      final piece = _pieceMap[vl.key];
      if(piece!=null){
        final r = motion(piece.x,  piece.y,  vl.x,  vl.y);
        
        return r;
      }
    }
    
    return invalidMotion;
  }

  ({int key, int x, int y, int value})? _alphaBeta(int vlAlpha, int vlBeta,int nDepth, List<List<int>> map, ChessColor chessColor) {
    if (nDepth == 0) {
      final r = (key:Piece.none, x:0, y:0, value:_evaluate(map, chessColor)); 
      
      return r;
    }
    final motions = _genLegalMoves(map, chessColor);
    
    ({int key, int x, int y, int value})? root;
    int key=Piece.none;
    int nx=invalidMotionX;
    int ny=invalidMotionY;
    for (final Motion motion in motions) {
       key = motion.key;
       final ox= motion.x;
       final oy= motion.y;
       nx= motion.newX;
       ny= motion.newY;
       final clearKey = map[ ny ][ nx ];

      map[ ny ][ nx ] = key;
      map[ oy ][ ox ] = Piece.none;
      
      
      if (clearKey == Piece.k || clearKey == Piece.K) {
        
        map[oy][ox] = key;
        map[ny][nx] = Piece.none;
        if (clearKey!=Piece.none){
          map[ ny ][ nx ] = clearKey;
        }
        final r = (key: key, x: nx, y: ny, value: WIN_VALUE);
        
        return r;
      }
       final vl = -_alphaBeta(-vlBeta, -vlAlpha, nDepth - 1, map , chessColor==ChessColor.red? ChessColor.black:ChessColor.red)!.value;
       
       map[ oy ][ ox ] = key;
       map[ ny ][ nx ] = Piece.none;
       if (clearKey != Piece.none) {
         map[ ny ][ nx ] = clearKey;
       }
       if (vl >= vlBeta) {
         var r = (key: key, x: nx, y: ny, value: vlBeta);
         
         return r;
       }
       if (vl > vlAlpha) {
         vlAlpha = vl;
         if (_depth == nDepth) {
          root = (key: key, x: nx, y: ny, value: vlBeta);
          
         }
       }
    }

    if (_depth == nDepth) {
      
      return root;
    }
    final r = (key: key, x: nx, y: ny, value: vlAlpha);
    
    return r;
  }

  List<Motion> _genLegalMoves(List<List<int>> list, ChessColor color) {
    final List<Piece> pieces = [];
    for (final line in list) {
      for (final key in line) {
        if (key == Piece.none) continue;
        var piece = _pieceMap[key];
        if (piece != null && !piece.isKilled && piece.color == color) {
          pieces.add(piece);
        }
      }
    }

    final List<Motion> motions = [];
    for (final piece in pieces) {
      final steps = piece.guideSteps(list,_pieceMap);
      final x = piece.x;
      final y = piece.y;
      for (AxisXY it in steps) {
        final newX = it.x;
        final newY = it.y;
        if (_foul==invalidMotion || _foul.x != x || _foul.y != y || _foul.newX != newX || _foul.newY != newY) {
          motions.add(motion( x,  y, newX,  newY ,key:piece.key));
        }
      }
    }
    
    return motions;
  }

  int _evaluate(List<List<int>> board,ChessColor color) {
    var ret = 0;
    for (int i = 0; i < board.length; i++) {
      final line=board[i];
      for (int j = 0; j <line.length; j++) {
        final key = line[j];
        if (key == Piece.none) continue;
        final piece= _pieceMap[key];
        if(piece==null) continue;
        ret += piece.score[i][j] * piece.color.multiplier;
      }
    }
    _number++;
    return ret * color.multiplier;
  }

  static Future<void> load() async {
    return Future.value();
  }
  static release() {

  }
}