import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../model/UnitModel.dart';
import '../view_model/view_model_unit.dart';

class UnitView extends StatefulWidget {
  @override
  _UnitView createState() => _UnitView();
}

class _UnitView extends State<UnitView> {

  final teNameController = TextEditingController();
  final tePhoneController = TextEditingController();
  final teEmailController = TextEditingController();
  final teIdentityNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<UnitModel> unitList = [];
  UnitViewModel unitViewModel = UnitViewModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    unitViewModel.onLoadingChanged = () => setState(() {});
    unitViewModel.onDataChanged = () => setState(() {});
    unitViewModel.getUnitList();
  }

  @override
  void dispose() {
    unitViewModel.onLoadingChanged = null;
    unitViewModel.onDataChanged = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white,),
              tooltip: 'Add Icon',
              onPressed: () {
                addUnit();
              },
            ), //IconButton
          ],
          title: const Text("Unit List"),
          titleSpacing: 00.0,
          centerTitle: true,
          toolbarHeight: 40,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          elevation: 0.00,
          backgroundColor: Colors.grey[600],
        ), //AppBar
        body: LayoutBuilder(builder: (context, constraints) {
          if (unitViewModel.isLoading) {
            return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.green,
                  size: 100,
                ));
          }
          else if (unitViewModel.unitList.isNotEmpty) {
            return Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(children: <Widget>[

                  Expanded(
                      child: ListView.builder(
                          itemCount: unitViewModel.unitList.length,
                          itemBuilder: (context, index)
                          {
                            final unitModel = unitViewModel.unitList[index];
                            return _buildItem(unitModel, index);
                          }
                      ))

                ])
            );
          }
          else {
            return const Center(
              child: Text(
                "No data available.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,),
              ),
            );
          }
        })



    );
  }

  Widget _buildItem(UnitModel unitModel, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3,10,0,10),
        child: ListTile(
          title: Text(
              unitModel.name,
              style: const TextStyle(
              fontSize: 16,
            ),
          ),
          leading: CircleAvatar(
            child: Text(
              unitModel.id.toString(),
              style:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          trailing: Flexible(
            fit: FlexFit.tight,
            child: IconButton(
                color: Colors.black,
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(unitModel, index)),
          ),
        ),
      ),
    );
  }

  ///On Item Click
  onItemClick(UnitModel unitModel) {
    if (kDebugMode) {
      print("Clicked position is ${unitModel.name}");
    }
  }

  /// Delete Click and delete item
  onDelete(UnitModel unitModel, int index) {
    unitViewModel.deleteUnit(unitModel);
    showToastMessage("Successfully Deleted Data");
    unitViewModel.getUnitList();
  }

  ///add Unit Method
  addUnit() {
    try
    {
      UnitModel unitModel = UnitModel();

      unitModel.name = "New Unit";

      unitViewModel.addUnit(unitModel);
      unitViewModel.getUnitList();
      unitViewModel.sortUnitList();
      unitViewModel.onDataChanged?.call();
      showToastMessage("Data Saved successfully");
    }
    on Exception catch (ex)
    {
      showToastMessage(ex.toString());
    }

  }

  showToastMessage(String? value){
    ScaffoldMessenger.of(context)
        .showSnackBar( SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'On Snap!',
        message: value!,
        contentType: ContentType.success,
      ),
    ));
  }
}