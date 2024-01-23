import 'package:flutter/cupertino.dart';
import '../database/DataAccess.dart';
import '../model/UnitModel.dart';

class UnitViewModel with ChangeNotifier {
  List<UnitModel> unitList = [];
  late UnitModel unitModel;
  bool isLoading = false;
  Function()? onLoadingChanged;
  Function()? onDataChanged;

  Future<void> getUnitList() async {
    isLoading = true;
    onLoadingChanged?.call();

    unitList = await DataAccess().getAllUnitModels();
    sortUnitList();
    isLoading = false;
    onLoadingChanged?.call();
    onDataChanged?.call();
  }

  getUnit(int id) async {
    unitModel = (await DataAccess().getUnitModel(id))!;
  }

  addUnit(UnitModel unitModel) async {
    await DataAccess().insertUnit(unitModel);
  }

  deleteUnit(UnitModel unitModel) async {
    await DataAccess().deleteUnitModel(unitModel.id);
  }

  updateUnit(UnitModel unitModel) async {
    await DataAccess().updateUnitModel(unitModel);
  }

  sortUnitList()  {
    unitList.sort((a, b) => a.id.compareTo(b.id));
  }
}