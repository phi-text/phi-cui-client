import 'dart:io';

import 'package:curses/curses.dart';
import 'package:curses_abst/curses_abst.dart' as abst;

List<Color> colourMap = [Color.BLACK, Color.RED, Color.GREEN, Color.YELLOW, Color.BLUE, Color.MAGENTA, Color.CYAN, Color.WHITE];
Map<int, int> colourPairs = new Map();
int pairId = 0;

int attrForColour(abst.TermColour fg, abst.TermColour bg) {
  int key = fg.index | (bg.index << 4);
  if (colourPairs.containsKey(key))
    return colourPairs[key];
  stdscr.init_pair(pairId++, colourMap[fg.index], colourMap[bg.index]);
  return pairId - 1;
}

class CLIWindow extends abst.Window {
  factory CLIWindow() {
    stdscr.setup();
    stdscr.start_color();
    Size size = stdscr.getmaxyx();
    CLIWindow window = new CLIWindow._(size.columns, size.rows);
    return window;
  }

  CLIWindow._(int x, int y) : super(x, y, () => new CLICell(), new CLICursor());

  @override
  void drawBuffer() => drawRegion(0, 0, width, height);

  @override
  void drawRegion(int xOff, int yOff, int width, int height) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        abst.Cell cell = getCell(x, y);
        List<Attribute> attrs = new List();
        if (cell.bold) attrs.add(Attribute.BOLD);
        if (cell.italic) attrs.add(Attribute.STANDOUT);
        if (cell.strikethrough) attrs.add(Attribute.DIM);
        if (cell.underline) attrs.add(Attribute.UNDERLINE);
        stdscr.addstr(
            cell.text == null ? ' ' : cell.text,
            location: new Point(y, x),
            maxLength: 1,
            colorPair: attrForColour(cell.fg_col, cell.bg_col),
            attributes: attrs
        );
      }
    }
  }
}

class CLICell extends abst.Cell { }

class CLICursor extends abst.Cursor { }

class QuadInt {
  int x, y, w, h;

  QuadInt(this.x, this.y, this.w, this.h);
}