import 'package:flutter/cupertino.dart';
import '../database/DataAccess.dart';
import '../model/UserModel.dart';

class UserViewModel with ChangeNotifier {
  List<UserModel> userList = [];
  late UserModel userModel;
  bool isLoading = false;
  bool isError = false;

  Function()? onLoadingChanged;
  Function()? onDataChanged;

  Future<void> getUserList() async {
    try{
      isLoading = true;
      onLoadingChanged?.call();

      userList = await DataAccess().getAllUsers();

      isLoading = false;
      onLoadingChanged?.call();
      onDataChanged?.call();
    }
    on Exception catch (ex)
    {
      isError = true;
      onLoadingChanged?.call();
    }
  }

  Future<void> getActiveUserList() async {
    try{
      isLoading = true;
      onLoadingChanged?.call();

      userList = await DataAccess().getAllActiveUsers();

      isLoading = false;
      onLoadingChanged?.call();
      onDataChanged?.call();
    }
    on Exception catch (ex)
    {
      isError = true;
      onLoadingChanged?.call();
      onDataChanged?.call();
    }
  }

  getUser(int id) async {
    userModel = (await DataAccess().getUserModel(id))!;
  }

  addUser(UserModel userModel) async {
    await DataAccess().insert(userModel);
  }

  deleteUser(UserModel userModel) async {
    await DataAccess().deleteUserModel(userModel.id);
  }

  setDeletedTrueUser(UserModel userModel) async {
    await DataAccess().setDeletedTrue(userModel);
  }

  updateUser(UserModel userModel) async {
    await DataAccess().updateUserModel(userModel);
  }

  sortUserList()  {
    userList.sort((a, b) => a.nameSurname.compareTo(b.nameSurname));
  }
}