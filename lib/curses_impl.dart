import 'package:curses_abst/curses_abst.dart';

import 'package:phi_cui_client/src/curses_binding.dart';

class CLICursesBinding implements CursesBinding {
  @override
  TermColour get defaultBgColour => TermColour.BLACK;

  @override
  CursorShape get defaultCursorShape => CursorShape.BLOCK_FULL;

  @override
  TermColour get defaultFgColour => TermColour.WHITE;

  @override
  Window initDisplay() {
    return new CLIWindow();
  }
}