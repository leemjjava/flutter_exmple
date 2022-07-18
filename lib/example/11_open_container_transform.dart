// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

const String _loremIpsumParagraph =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Vulputate dignissim '
    'suspendisse in est. Ut ornare lectus sit amet. Eget nunc lobortis mattis '
    'aliquam faucibus purus in. Hendrerit gravida rutrum quisque non tellus '
    'orci ac auctor. Mattis aliquam faucibus purus in massa. Tellus rutrum '
    'tellus pellentesque eu tincidunt tortor. Nunc eget lorem dolor sed. Nulla '
    'at volutpat diam ut venenatis tellus in metus. Tellus cras adipiscing enim '
    'eu turpis. Pretium fusce id velit ut tortor. Adipiscing enim eu turpis '
    'egestas pretium. Quis varius quam quisque id. Blandit aliquam etiam erat '
    'velit scelerisque. In nisl nisi scelerisque eu. Semper risus in hendrerit '
    'gravida rutrum quisque. Suspendisse in est ante in nibh mauris cursus '
    'mattis molestie. Adipiscing elit duis tristique sollicitudin nibh sit '
    'amet commodo nulla. Pretium viverra suspendisse potenti nullam ac tortor '
    'vitae.\n'
    '\n'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Vulputate dignissim '
    'suspendisse in est. Ut ornare lectus sit amet. Eget nunc lobortis mattis '
    'aliquam faucibus purus in. Hendrerit gravida rutrum quisque non tellus '
    'orci ac auctor. Mattis aliquam faucibus purus in massa. Tellus rutrum '
    'tellus pellentesque eu tincidunt tortor. Nunc eget lorem dolor sed. Nulla '
    'at volutpat diam ut venenatis tellus in metus. Tellus cras adipiscing enim '
    'eu turpis. Pretium fusce id velit ut tortor. Adipiscing enim eu turpis '
    'egestas pretium. Quis varius quam quisque id. Blandit aliquam etiam erat '
    'velit scelerisque. In nisl nisi scelerisque eu. Semper risus in hendrerit '
    'gravida rutrum quisque. Suspendisse in est ante in nibh mauris cursus '
    'mattis molestie. Adipiscing elit duis tristique sollicitudin nibh sit '
    'amet commodo nulla. Pretium viverra suspendisse potenti nullam ac tortor '
    'vitae';

const double _fabDimension = 56;

class OpenContainerTransformDemo extends StatefulWidget {
  static const String routeName = '/examples/open_container_transform';
  const OpenContainerTransformDemo({
    Key? key,
  }) : super(key: key);

  @override
  _OpenContainerTransformDemoState createState() =>
      _OpenContainerTransformDemoState();
}

class _OpenContainerTransformDemoState
    extends State<OpenContainerTransformDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return Page(
      scaffoldKey: _scaffoldKey,
      transitionType: _transitionType,
      showSettingsBottomModalSheet: _showSettingsBottomModalSheet,
    );
  }

  void _showSettingsBottomModalSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 125,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '컨테이너 변환 (Cards, Lists & FAB)',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 12),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(2),
                    selectedBorderColor: Theme.of(context).colorScheme.primary,
                    onPressed: (index) {
                      setModalState(() {
                        setState(() {
                          _transitionType = index == 0
                              ? ContainerTransitionType.fade
                              : ContainerTransitionType.fadeThrough;
                        });
                      });
                    },
                    isSelected: <bool>[
                      _transitionType == ContainerTransitionType.fade,
                      _transitionType == ContainerTransitionType.fadeThrough,
                    ],
                    children: [
                      Text('제목'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('보조 텍스트'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class Page extends StatelessWidget {
  Page({
    Key? key,
    this.scaffoldKey,
    required this.transitionType,
    required this.showSettingsBottomModalSheet,
  }) : super(key: key);

  GlobalKey<ScaffoldState>? scaffoldKey;
  ContainerTransitionType transitionType;
  VoidCallback showSettingsBottomModalSheet;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text('컨테이너 변환'),
            Text(
              '(Cards, Lists & FAB)',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showSettingsBottomModalSheet(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _OpenContainerWrapper(
            transitionType: transitionType,
            closedBuilder: (context, openContainer) =>
                _DetailsCard(openContainer: openContainer),
          ),
          const SizedBox(height: 16),
          _OpenContainerWrapper(
            transitionType: transitionType,
            closedBuilder: (context, openContainer) =>
                _DetailsListTile(openContainer: openContainer),
          ),
          const SizedBox(height: 16),
          getFirstRow(),
          const SizedBox(height: 16),
          getSecondRow(),
          const SizedBox(height: 16),
          ...getList(),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionType: transitionType,
        openBuilder: (context, openContainer) => const _DetailsPage(),
        closedElevation: 6,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: colorScheme.secondary,
        closedBuilder: (context, openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: colorScheme.onSecondary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getFirstRow() {
    return Row(
      children: [
        Expanded(
          child: _OpenContainerWrapper(
            transitionType: transitionType,
            closedBuilder: (context, openContainer) {
              return _SmallDetailsCard(
                openContainer: openContainer,
                subtitle: '보조 텍스트',
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _OpenContainerWrapper(
            transitionType: transitionType,
            closedBuilder: (context, openContainer) {
              return _SmallDetailsCard(
                openContainer: openContainer,
                subtitle: '보조 텍스트',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getSecondRow() {
    return Row(
      children: [
        Expanded(
          child: _OpenContainerWrapper(
            transitionType: transitionType,
            closedBuilder: (context, openContainer) {
              return _SmallDetailsCard(
                openContainer: openContainer,
                subtitle: '보조',
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _OpenContainerWrapper(
            transitionType: transitionType,
            closedBuilder: (context, openContainer) {
              return _SmallDetailsCard(
                openContainer: openContainer,
                subtitle: '보조',
              );
            },
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: _OpenContainerWrapper(
            transitionType: transitionType,
            closedBuilder: (context, openContainer) {
              return _SmallDetailsCard(
                openContainer: openContainer,
                subtitle: '보조',
              );
            },
          ),
        ),
      ],
    );
  }

  List getList() {
    return List.generate(10, (index) {
      return OpenContainer<bool>(
        transitionType: transitionType,
        openBuilder: (context, openContainer) => const _DetailsPage(),
        tappable: false,
        closedShape: const RoundedRectangleBorder(),
        closedElevation: 0,
        transitionDuration: Duration(milliseconds: 500),
        closedBuilder: (context, openContainer) {
          return ListTile(
            leading: Image.asset('assets/ufo.png', width: 40),
            onTap: openContainer,
            title: Text('목록 항목 ${index + 1}'),
            subtitle: Text('보조 텍스트'),
          );
        },
      );
    });
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    required this.closedBuilder,
    required this.transitionType,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (context, openContainer) => const _DetailsPage(),
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.openContainer,
  });

  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    return _InkWellOverlay(
      openContainer: openContainer,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.black38,
              child: Center(
                child: Image.asset('assets/icon.png', width: 100),
              ),
            ),
          ),
          ListTile(
            title: Text('제목'),
            subtitle: Text('보조 텍스트'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur '
              'adipiscing elit, sed do eiusmod tempor.',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.black54, inherit: false),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallDetailsCard extends StatelessWidget {
  const _SmallDetailsCard({
    required this.openContainer,
    required this.subtitle,
  });

  final VoidCallback openContainer;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _InkWellOverlay(
      openContainer: openContainer,
      height: 225,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.black38,
            height: 150,
            child: Image.asset('assets/icon.png', width: 80),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('제목', style: textTheme.headline6),
                  const SizedBox(height: 4),
                  Text(subtitle, style: textTheme.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsListTile extends StatelessWidget {
  const _DetailsListTile({
    required this.openContainer,
  });

  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const height = 100.0;

    return _InkWellOverlay(
      openContainer: openContainer,
      height: height,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.black38,
            height: height,
            width: height,
            child: Image.asset('assets/icon.png', width: 60),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('제목', style: textTheme.subtitle1),
                  const SizedBox(height: 8),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur '
                    'adipiscing elit,',
                    style: textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    required this.openContainer,
    this.width,
    this.height,
    required this.child,
  });

  final VoidCallback openContainer;
  final double? width;
  final double? height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: openContainer,
        child: child,
      ),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  const _DetailsPage();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ListView(
        children: [
          Container(
            color: Colors.black38,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(70),
              child: Image.asset('assets/icon.png', width: 56),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '제목',
                  style: textTheme.headline5!.copyWith(
                    color: Colors.black54,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _loremIpsumParagraph,
                  style: textTheme.bodyText2!.copyWith(
                    color: Colors.black54,
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
