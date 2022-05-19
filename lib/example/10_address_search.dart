import 'package:flutter/material.dart';
import 'package:navigator/components/topbar/top_bar.dart';
import 'package:navigator/http/blocs/address_bloc.dart';
import 'package:navigator/http/models/address.dart';
import 'package:navigator/http/models/error.dart';

class SearchAddress extends StatefulWidget {
  static const String routeName = '/examples/address_search';

  @override
  SearchAddressState createState() => SearchAddressState();
}

class SearchAddressState extends State<SearchAddress> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final searchTec = TextEditingController();
  final scrollController = ScrollController();
  final addressBloc = AddressBloc();
  List<Juso> addressList = [];
  String? keyword;
  String errorMessage = "검색어를 입력하세요.";
  int page = 0;

  @override
  void initState() {
    super.initState();
    addAddressStreamListener();
    addScrollListener();
    addTextEditListener();
  }

  addAddressStreamListener() {
    addressBloc.address.listen(
      (list) {
        addressList = list;
        setState(() {});
      },
      onError: (error, stacktrace) {
        print("onError: $error");
        print(stacktrace.toString());

        if (error is ErrorModel == false) return;

        ErrorModel errorModel = error;
        if (page == 1) addressList = [];
        if (errorModel.error == -101) page = -1;

        errorMessage = errorModel.message ?? errorMessage;
        setState(() {});
      },
    );
  }

  addScrollListener() {
    scrollController.addListener(() {
      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

  addTextEditListener() {
    searchTec.addListener(() async {
      if (keyword == searchTec.text) return;
      keyword = searchTec.text;
      page = 1;
      addressBloc.fetchAddress(keyword, page);
    });
  }

  @override
  void dispose() {
    addressBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Column(
            children: [
              TopBar(
                title: "주소 검색",
                height: 50,
                closeIcon: Icon(Icons.arrow_back_ios),
              ),
              Row(
                children: [
                  Expanded(child: searchTextField()),
                  cancelWidget(),
                  SizedBox(width: 10)
                ],
              ),
              Expanded(child: listView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchTextField() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 50,
      alignment: Alignment.center,
      child: TextField(
        controller: searchTec,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "주소 입력",
          hintStyle: TextStyle(color: Color(0xFFA0A0A0)),
        ),
      ),
    );
  }

  Widget cancelWidget() {
    if (keyword == null || keyword!.isEmpty) return Container();

    return GestureDetector(
      child: Icon(
        Icons.cancel,
        color: Color(0xFFBFBFBF),
        size: 20,
      ),
      onTap: () => searchTec.clear(),
    );
  }

  Widget listView() {
    if (addressList.length == 0) {
      return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          children: [
            Container(height: 15, color: Color(0xFFEdEdEd)),
            Expanded(child: Center(child: Text(errorMessage)))
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: addressList.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) return Container(height: 15, color: Color(0xFFEdEdEd));
        if (index == addressList.length) addAddressList();

        final address = addressList[index - 1];
        return Column(
          children: [
            listItem(address),
            Container(height: 1, color: Color(0xFFEdEdEd)),
          ],
        );
      },
    );
  }

  Widget listItem(Juso address) {
    final roadLast =
        address.buldSlno == '0' ? '' : '-' + (address.buldSlno ?? '');
    final rodaTitle = '${address.rn} ${address.buldMnnm}$roadLast';
    final String title =
        address.bdNm?.isEmpty == true ? rodaTitle : address.bdNm!;

    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 5),
          Text(
            address.jibunAddr ?? '',
            style: TextStyle(color: Color(0xFFA8A8A8)),
          ),
          Text(
            '[도로명] ' + (address.roadAddr ?? ''),
            style: TextStyle(color: Color(0xFFA8A8A8)),
          ),
        ],
      ),
    );
  }

  addAddressList() {
    if (page == -1) return;
    ++page;
    addressBloc.fetchAddress(keyword, page);
  }
}
