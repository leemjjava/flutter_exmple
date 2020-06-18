import '../models/member.dart';
import '../models/member_input.dart';
import '../http_repository.dart';
import 'package:rxdart/rxdart.dart';

class MemberBloc {
  final _httpService = HttpRepository();
  final _memberFetcher = PublishSubject<List<Member>>();
  final _createFetcher = PublishSubject<MemberInputResult>();

  Stream<List<Member>> get members => _memberFetcher.stream;
  Stream<MemberInputResult> get create => _createFetcher.stream;

  fetchMembers() async{
    try{
      List<Member> member = await _httpService.getMembers();
      _memberFetcher.sink.add(member);
    }catch(e){
      _memberFetcher.sink.addError(e);
    }
  }

  fetchCreate(Map<String, String> parameter) async{
    try{
      MemberInputResult result = await _httpService.createMember(parameter);
      _createFetcher.sink.add(result);
    }catch(e){
      _createFetcher.sink.addError(e);
    }
  }
  dispose(){
    _memberFetcher.close();
    _createFetcher.close();
  }

}