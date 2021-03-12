class Address {
  Common common;
  List<Juso> jusoList;

  Address({
    required this.common,
    required this.jusoList,
  });

  factory Address.formJson(Map<String, dynamic> json) {
    final results = json['results'];
    final common = Common.fromJson(results['common']);
    List<Juso> jusoList = [];
    if (results['juso'] != null) {
      final jusoJsonList = results['juso'] as List;
      jusoList = jusoJsonList.map((item) => Juso.fromJson(item)).toList();
    }

    return Address(
      common: common,
      jusoList: jusoList,
    );
  }
}

class Common {
  String? errorMessage;
  String? countPerPage;
  String? totalCount;
  String? errorCode;
  String? currentPage;

  Common({
    this.errorMessage,
    this.countPerPage,
    this.totalCount,
    this.errorCode,
    this.currentPage,
  });

  factory Common.fromJson(Map<String, dynamic> json) {
    return Common(
      errorMessage: json['errorMessage'],
      countPerPage: json['countPerPage'],
      totalCount: json['totalCount'],
      errorCode: json['errorCode'],
      currentPage: json['currentPage'],
    );
  }
}

class Juso {
  String? detBdNmList, engAddr, rn;
  String? emdNm, zipNo, roadAddrPart2;
  String? emdNo, sggNm, jibunAddr;
  String? siNm, roadAddrPart1, bdNm;
  String? admCd, udrtYn, lnbrMnnm;
  String? roadAddr, lnbrSlno, buldMnnm;
  String? bdKdcd, liNm, rnMgtSn;
  String? mtYn, bdMgtSn, buldSlno;

  Juso({
    this.detBdNmList,
    this.engAddr,
    this.rn,
    this.emdNm,
    this.zipNo,
    this.roadAddrPart2,
    this.emdNo,
    this.sggNm,
    this.jibunAddr,
    this.siNm,
    this.roadAddrPart1,
    this.bdNm,
    this.admCd,
    this.udrtYn,
    this.lnbrMnnm,
    this.roadAddr,
    this.lnbrSlno,
    this.buldMnnm,
    this.bdKdcd,
    this.liNm,
    this.rnMgtSn,
    this.mtYn,
    this.bdMgtSn,
    this.buldSlno,
  });

  factory Juso.fromJson(Map<String, dynamic> json) {
    return Juso(
      detBdNmList: json["detBdNmList"],
      engAddr: json["engAddr"],
      rn: json["rn"],
      emdNm: json["emdNm"],
      zipNo: json["zipNo"],
      roadAddrPart2: json["roadAddrPart2"],
      emdNo: json["emdNo"],
      sggNm: json["sggNm"],
      jibunAddr: json["jibunAddr"],
      siNm: json["siNm"],
      roadAddrPart1: json["roadAddrPart1"],
      bdNm: json["bdNm"],
      admCd: json["admCd"],
      udrtYn: json["udrtYn"],
      lnbrMnnm: json["lnbrMnnm"],
      roadAddr: json["roadAddr"],
      lnbrSlno: json["lnbrSlno"],
      buldMnnm: json["buldMnnm"],
      bdKdcd: json["bdKdcd"],
      liNm: json["liNm"],
      rnMgtSn: json["rnMgtSn"],
      mtYn: json["mtYn"],
      bdMgtSn: json["bdMgtSn"],
      buldSlno: json["buldSlno"],
    );
  }
}
