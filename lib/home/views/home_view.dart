import 'dart:io';

import 'package:file_manager/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(const HomeInit()),
      child: const HomeView(),
    );
  }
}

typedef KeySet = LogicalKeySet;
typedef KeyCode = LogicalKeyboardKey;

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
                  TabIntent: AppAction(
                    (e) {
                      controller.text = highlight ?? controller.text;
                      controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length));
                    },
                  ),
                },
                child: RawAutocomplete<String>(
                  focusNode: focusNode2,
                  textEditingController: controller,
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextField(
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(6),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      autofocus: true,
                      controller: textEditingController,
                      onSubmitted: (String value) {
                        onFieldSubmitted();
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
              CommandPalette: AppAction((e) => _showDia(context)),
              GoToDirectory: AppAction((e) => _showDia(context)),
              GoUp: AppAction(
                (e) {
                  context.read<HomeBloc>().add(
                        HomeSetPath(
                          0,
                          FileSystemEntity.parentOf(state.panel0Path),
                        ),
                      );
                  return;
                },
              ),
              GoBackward: CommonAction<GoBackward>(
                () => context.read<HomeBloc>().add(const HomeGoBackward(0)),
              ),
              GoForward: CommonAction<GoForward>(
                () => context.read<HomeBloc>().add(const HomeGoForward(0)),
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
                            child: Center(
                              child: Column(
                                children: [
                                  const TextField(
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
                          Expanded(
                            child: Center(
                              child: Column(
                                children: [
                                  const TextField(
                                    decoration: InputDecoration(
                                      label: Text('Panel 2 current Address'),
                                    ),
                                  ),
                                  Expanded(
                                    child: PanelView(state.panel1Dir),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
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

  final TextEditingController controller;
  final AutocompleteOptionToString<T> displayStringForOption;
  final double maxOptionsHeight;
  final double maxOptionsWidth;
  final void Function(T? option) onHighlighted;
  final AutocompleteOnSelected<T> onSelected;
  final Iterable<T> options;

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
                  const Divider(
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
