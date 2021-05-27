import 'package:flutter/material.dart';
import 'package:navigator/components/button/primary_button.dart';
import 'package:navigator/components/grid/box_grid.dart';
import 'package:navigator/components/topbar/back_top_bar.dart';
import 'package:navigator/layouts/bar_change_custom_layout.dart';

class BarChangeNested extends StatefulWidget {
  static const String routeName = '/examples/bar_change_nested';

  @override
  _BarChangeNestedState createState() => _BarChangeNestedState();
}

class _BarChangeNestedState extends State<BarChangeNested> {
  final double collapsedHeight = 50.0, expandedHeight = 100.0;
  bool pinned = true, floating = false;
  List<BoxGridModel> models = [];

  @override
  void initState() {
    super.initState();
    _setModel();
  }

  @override
  Widget build(BuildContext context) {
    return BarChangeCustomLayout(
      collapsedHeight: collapsedHeight,
      expandedHeight: expandedHeight,
      collapsedTopBar: renderCollapsedTop(),
      expandedTopBar: renderExpandedTop(),
      body: renderMain(),
      floating: floating,
      pinned: pinned,
    );
  }

  Widget renderCollapsedTop() {
    return BackTopBar(
      title: 'TopBarTest',
      height: expandedHeight,
      rightButtons: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          renderPlusBtn(),
          renderFloatingBtn(),
          renderPinnedBtn(),
        ],
      ),
    );
  }

  Widget renderPlusBtn() {
    return InkWell(
      child: Container(
        width: 50,
        color: Colors.transparent,
        child: Icon(Icons.add),
      ),
      onTap: () {
        _setModel();
        setState(() {});
      },
    );
  }

  Widget renderFloatingBtn() {
    return InkWell(
      child: Container(
        width: 50,
        child: Icon(
          Icons.ad_units,
          color: floating ? Color(0xff6CC4BF) : Color(0xffF29061),
        ),
      ),
      onTap: () => setState(() => floating = !floating),
    );
  }

  Widget renderPinnedBtn() {
    return InkWell(
      child: Container(
        width: 50,
        child: Icon(
          Icons.present_to_all_outlined,
          color: pinned ? Color(0xff6CC4BF) : Color(0xffF29061),
        ),
      ),
      onTap: () => setState(() => pinned = !pinned),
    );
  }

  Widget renderExpandedTop() {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Color(0xff4042ab),
      child: Text(
        'TopBarTest',
        style: TextStyle(
          color: Color(0xffffffff),
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
      ),
    );
  }

  renderMain() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: BoxGrid(models: models),
          ),
          renderSubmitBtn(),
        ],
      ),
    );
  }

  _setModel() {
    for (int i = 0; i < 6; ++i) {
      models.add(
        BoxGridModel(
          title: '교육비',
          ratio: 105 / 90,
          selectColor: Color(0xff4042ab),
        ),
      );
    }
  }

  Widget renderSubmitBtn() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      height: 60,
      child: PrimaryButton(
        label: '다음',
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      ),
    );
  }
}
