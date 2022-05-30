import 'dart:io';

import 'package:file_manager/app/modules/home/bloc/home_bloc.dart';
import 'package:file_manager/app/modules/home/views/panel_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef KeySet = LogicalKeySet;
typedef KeyCode = LogicalKeyboardKey;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeInit()),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  static const _kOptions = [
    'aardvark',
    'bobcat',
    'jagmeleon',
    'jagdvark',
    'ragcat',
    'ragmeleon',
    'ragdvark',
    'jagcat',
    'rjleon',
    'rjark',
    'rcat',
    'rmeleon',
    'rdvark',
    'cat',
    'rmeleon',
    'rvark',
    'agcat',
    'agmeleon',
    'dvark',
    'zdat',
    'zdeleon',
    'zdvark',
    'jagcat',
    'jagmeleon',
    'agdvark',
    'obcat',
    'ameleon',
    'aardvark',
    'bobcat',
    'chameleon',
    'ardark',
    'bocat',
    'cameleon',
  ];
  void _showDia(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        final focusNode2 = FocusNode();
        String? highlight;
        return Dialog(
          child: SizedBox(
            width: 450,
            child: Shortcuts(
              shortcuts: {
                KeySet(KeyCode.tab): TabIntent(),
              },
              child: Actions(
                actions: {
                  TabIntent: CommonAction<TabIntent>(
                    onInvoke: () {
                      controller.text = highlight ?? controller.text;
                      controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length));
                    },
                    enabled: true,
                  ),
                },
                child: RawAutocomplete<String>(
                  focusNode: focusNode2,
                  //tabToInsertCurrentHightlight: true,
                  textEditingController: controller,
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextField(
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(6),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      autofocus: true,
                      controller: textEditingController,
                      onSubmitted: (String value) {
                        onFieldSubmitted();
                        // Get.back();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _kOptions.where((String option) {
                      return option
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return _MyAutocompleteOptions<String>(
                      displayStringForOption:
                          RawAutocomplete.defaultStringForOption,
                      onSelected: onSelected,
                      onHighlighted: (option) {
                        highlight = option;
                      },
                      controller: controller,
                      options: options,
                      // focusNode2: focusNode2,
                      maxOptionsHeight: 250,
                      maxOptionsWidth: 450,
                    );
                  },
                  onSelected: (String selection) {
                    print('You just selected $selection');
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            KeySet(KeyCode.control, KeyCode.shift, KeyCode.keyP):
                CommandPalette(),
            KeySet(KeyCode.control, KeyCode.keyP): GoToDirectory(),
            KeySet(KeyCode.alt, KeyCode.arrowLeft): GoBackward(),
            KeySet(KeyCode.alt, KeyCode.arrowRight): GoForward(),
            KeySet(KeyCode.backspace): GoUp(),
          },
          child: Actions(
            actions: {
              CommandPalette: CommonAction<CommandPalette>(
                onInvoke: () => _showDia(context),
                enabled: true,
              ),
              GoToDirectory: CommonAction<GoToDirectory>(
                onInvoke: () => _showDia(context),
                enabled: true,
              ),
              GoUp: CommonAction<GoUp>(
                onInvoke: () {
                  context.read<HomeBloc>().add(
                        HomeSetPath(
                          0,
                          FileSystemEntity.parentOf(state.panel0Path),
                        ),
                      );
                },
                enabled: true,
              ),
              GoBackward: CommonAction<GoBackward>(
                onInvoke: () {
                  context.read<HomeBloc>().add(HomeGoBackward(0));
                  // controller.goBackward(0);
                },
                enabled: true,
              ),
              GoForward: CommonAction<GoForward>(
                onInvoke: () {
                  context.read<HomeBloc>().add(HomeGoForward(0));
                },
                enabled: true,
              ),
            },
            child: Focus(
              autofocus: true,
              child: Scaffold(
                // appBar: AppBar(
                //   title: Text('HomeView'),
                //   centerTitle: true,
                // ),
                body: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Center(
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        label: Text('Panel 1 current Address'),
                                      ),
                                    ),
                                    Expanded(
                                      child: PanelView(state.panel0Dir),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  child: Center(child: Text('Panel 2')))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Text('Status Bar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

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
  CommonAction({
    required this.onInvoke,
    required this.enabled,
  });
  final VoidCallback onInvoke;
  final bool enabled;

  @override
  bool isEnabled(covariant T intent) {
    return enabled;
  }

  @override
  void invoke(covariant T intent) {
    onInvoke.call();
  } // model.selectAll();
}

class _MyAutocompleteOptions<T extends Object> extends StatelessWidget {
  const _MyAutocompleteOptions({
    Key? key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
    required this.maxOptionsWidth,
    required this.controller,
    required this.onHighlighted,
  }) : super(key: key);

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;
  final void Function(T? option) onHighlighted;

  final Iterable<T> options;
  final double maxOptionsHeight;
  final double maxOptionsWidth;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) onHighlighted(null);
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: maxOptionsHeight, maxWidth: maxOptionsWidth),
          child: ListView.separated(
            primary: false,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;

                  if (highlight) {
                    onHighlighted(option);
                    SchedulerBinding.instance
                        .addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context);
                    });
                    // focusNode2.requestFocus();
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 0.5,
                    ),
                    child: Text(displayStringForOption(option)),
                  );
                }),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Divider(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black26
                        : Colors.white24,
                    height: 1,
                    thickness: 1,
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
