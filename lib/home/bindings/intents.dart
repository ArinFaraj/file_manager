/*

F4: Edit (with a text editor)
Shift+F4: Create and edit
F5: Copy
F6: Move
Shift + F6: Rename
F7: New directory
F8: Delete
F9: Open terminal in current directory
F10: Open native file manager (Explorer/Finder)
F11: Copy path(s) to clipboard
Ctrl/Cmd + P: Go to directory ("GoTo on Steroids")
Alt + F1/F2 : List drives / volumes
Ctrl/Cmd + . : Toggle hidden files
Ctrl + Left: Open in left pane
Ctrl + Right: Open in right pane
Alt/Cmd + Left/Right: Go back/forward
Ctrl/Cmd + D: Deselect (clear the selection)
Alt/Cmd + F5: Pack files (eg. to a .zip)
Ctrl/Cmd + F1/F2/F3: Change the sort column

*/
import 'package:flutter/material.dart';

class TabIntent extends Intent {}

class CommandPalette extends Intent {}

class Copy extends Intent {}

class Move extends Intent {}

class Rename extends Intent {}

class NewDirectory extends Intent {}

class Delete extends Intent {}

class OpenTerminal extends Intent {}

class OpenNativeExplorer extends Intent {}

class CopyPath extends Intent {}

class GoToDirectory extends Intent {}

class ListDrives extends Intent {}

class ToggleHidden extends Intent {}

class OpenInLeftPane extends Intent {}

class OpenInRightPane extends Intent {}

class GoForward extends Intent {}

class GoBackward extends Intent {}

class GoUp extends Intent {}

class Deselect extends Intent {}

class PackFiles extends Intent {}

class ChangeSortColumn extends Intent {}

class CommonAction<T extends Intent> extends Action<T> {
  CommonAction(
    this.onInvoke, {
    this.enabled = true,
  });

  final bool enabled;
  final VoidCallback onInvoke;

  @override
  void invoke(covariant T intent) {
    onInvoke.call();
  } // model.selectAll();

  @override
  bool isEnabled(covariant T intent) {
    return enabled;
  }
}

typedef OnInvokeCallbackVoid<T extends Intent> = void Function(T intent);

class AppAction extends CallbackAction {
  AppAction(OnInvokeCallbackVoid<Intent> onInvoke) : super(onInvoke: onInvoke);
}
