import 'package:phi_editor/phi_editor.dart' as phi_editor;
import 'package:curses_abst/curses_abst.dart' as curses_abst;

import 'package:phi_cui_client/curses_impl.dart';

void main(List<String> args) {
  curses_abst.bindCurses(new CLICursesBinding());
  phi_editor.main(phi_editor.phiArguments.parse(args));
}