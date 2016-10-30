import 'package:console/console.dart';
import 'package:console/curses.dart';
import 'package:curses_abst/curses_abst.dart' as abst;

class CLICanvas extends Window {
  abst.Window _parent;

  List<QuadInt> _dirty = new List();

  CLICanvas() : super('Phi');

  @override
  void draw() {
    for (QuadInt reg in _dirty) {
      for (int y = 0; y < reg.h; y++) {
        for (int x = 0; x < reg.w; x++) {
          abst.Cell cell = _parent.getCell(x, y);
          Console.setBold(cell.bold);
          Console.setItalic(cell.italic);
          Console.setCrossedOut(cell.strikethrough);
          Console.setUnderline(cell.underline);
          Console.setBackgroundColor(cell.bg_col.index);
          Console.setTextColor(cell.fg_col.index);
          Console.write(cell.text != null ? cell.text : ' ');
          Console.resetAll();
        }
      }
    }
  }

  @override
  void initialize() {
    _dirty.add(new QuadInt(0, 0, _parent.width, _parent.height));
    this.display();
  }
}

class CLIWindow extends abst.Window {
  CLICanvas _canvas;

  factory CLIWindow() {
    CLIWindow window = new CLIWindow._pre();
    window._canvas = new CLICanvas();
    window._canvas._parent = window;
    return window;
  }

  CLIWindow._pre() : super(Console.columns, Console.rows, () => new CLICell(), new CLICursor());

  @override
  void drawBuffer() => drawRegion(0, 0, width, height);

  @override
  void drawRegion(int xOff, int yOff, int width, int height) {
    _canvas._dirty.add(new QuadInt(xOff, yOff, width, height));
  }
}

class CLICell extends abst.Cell { }

class CLICursor extends abst.Cursor { }

class QuadInt {
  int x, y, w, h;

  QuadInt(this.x, this.y, this.w, this.h);
}