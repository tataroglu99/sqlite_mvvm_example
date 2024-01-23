import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sqlite_mvvm_example/view/unit_view.dart';
import '../model/UserModel.dart';
import '../view_model/view_model_user.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {

  final teNameController = TextEditingController();
  final tePhoneController = TextEditingController();
  final teEmailController = TextEditingController();
  final teIdentityNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<UserModel> userList = [];
  UserViewModel userViewModel = UserViewModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userViewModel.onLoadingChanged = () => setState(() {});
    userViewModel.onDataChanged = () => setState(() {});

    try{

      userViewModel.getActiveUserList();
      userViewModel.onDataChanged?.call();
      userViewModel.onLoadingChanged?.call();
    }
    on Exception catch (ex)
    {
      userViewModel.onDataChanged?.call();
      userViewModel.onLoadingChanged?.call();
    }
  }

  @override
  void dispose() {
    userViewModel.onLoadingChanged = null;
    userViewModel.onDataChanged = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white,),
              tooltip: 'Add Icon',
              onPressed: () {
               openAlertBox(UserModel());
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_circle_right, color: Colors.white,),
              tooltip: 'Go Icon',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UnitView()),
                );
              },
            ),//IconButton
          ],
          title: const Text("User List"),
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
          if (userViewModel.isLoading) {
            return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.green,
                  size: 100,
                ));
          }
          else if(userViewModel.isError){
            return const Center(
              child: Text("There is an error occured!"),
            );
          }
          else if (userViewModel.userList.isNotEmpty) {
            return Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(children: <Widget>[

                  Expanded(
                      child: ListView.builder(
                          itemCount: userViewModel.userList.length,
                          itemBuilder: (context, index)
                          {
                            final userModel = userViewModel.userList[index];
                            return _buildItem(userModel, index);
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

  Widget _buildItem(UserModel userModel, int index) {
    return  Card(
        child: ListTile(
          onTap: () => onItemClick(userModel),
          title: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.brown.shade800,
                    child: Text(
                      userModel.nameSurname.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 5.0)),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.account_circle),
                      const Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)),
                      InkWell(
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                              MediaQuery.of(context).size.width - 200),
                          child: Text(
                            userModel.nameSurname,
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.normal,
                                color: Colors.black),
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0)),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.phone),
                      const Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)),
                      InkWell(
                        child: Text(
                          userModel.phone.toString(),
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0)),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.email),
                      const Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0)),
                      InkWell(
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                              MediaQuery.of(context).size.width - 200),
                          child: Text(
                            userModel.eMail.toString(),
                            style:
                            const TextStyle(fontSize: 18.0, color: Colors.black),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 10.0)),
                ],
              ),
            ],
          ),
          trailing: Column(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.edit),
                    onPressed: () => onEdit(userModel, index)),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.delete),
                    onPressed: () => onDelete(userModel, index)),
              ),
            ],
          ),
        ),
      );
  }

  ///On Item Click
  onItemClick(UserModel userModel) {
    if (kDebugMode) {
      print("Clicked position is ${userModel.nameSurname}");
    }
  }

  /// Delete Click and delete item
  onDelete(UserModel userModel, int index) {
    userViewModel.setDeletedTrueUser(userModel);
    showToastMessage("Successfully Deleted Data");
    userViewModel.getActiveUserList();
  }

  /// Edit Click
  onEdit(UserModel userModel, int index) {
    openAlertBox(userModel);
  }

  /// openAlertBox to add/edit user
  openAlertBox(UserModel userModel) {
    bool isUpdate = false;
    if (userModel.id != 0) {
      teNameController.text = userModel.nameSurname;
      tePhoneController.text = userModel.phone;
      teEmailController.text = userModel.eMail;
      teIdentityNumberController.text = userModel.identityNumber.toString();
      isUpdate = true;
    } else {
      teIdentityNumberController.text = "";
      teNameController.text = "";
      tePhoneController.text = "";
      teEmailController.text = "";
      isUpdate = false;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        isUpdate ? "Edit User" : "Add User",
                        style: const TextStyle(fontSize: 28.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: teIdentityNumberController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Add Identity Number",
                              fillColor: Colors.grey[300],
                              border: InputBorder.none,
                            ),
                            validator: validateIdetityNumber,
                            onSaved: (String? val) {
                              teIdentityNumberController.text = val!;
                            },
                          ),
                          TextFormField(
                            controller: teNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Add Name Surname",
                              fillColor: Colors.grey[300],
                              border: InputBorder.none,
                            ),
                            validator: validateName,
                            onSaved: (String? val) {
                              teNameController.text = val!;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: tePhoneController,
                            decoration: InputDecoration(
                              hintText: "Add Phone",
                              fillColor: Colors.grey[300],
                              border: InputBorder.none,
                            ),
                            maxLines: 1,
                            validator: validateMobile,
                            onSaved: (String? val) {
                              tePhoneController.text = val!;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: teEmailController,
                            decoration: InputDecoration(
                              hintText: "Add Email",
                              fillColor: Colors.grey[300],
                              border: InputBorder.none,
                            ),
                            maxLines: 1,
                            validator: validateEmail,
                            onSaved: (String? val) {
                              teEmailController.text = val!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => isUpdate ? editUser(userModel) : addUser(),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: const BoxDecoration(
                        color: Color(0xff00bfa5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0)),
                      ),
                      child: Text(
                        isUpdate ? "Edit User" : "Add User",
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///edit User
  editUser(UserModel userModel) {

    try {
      userModel.identityNumber =  int.parse(teIdentityNumberController.text);
      userModel.nameSurname = teNameController.text;
      userModel.phone = tePhoneController.text;
      userModel.eMail = teEmailController.text;
      userViewModel.updateUser(userModel);
      userViewModel.getActiveUserList();

      teIdentityNumberController.text = "";
      teNameController.text = "";
      tePhoneController.text = "";
      teEmailController.text = "";
      Navigator.of(context).pop();
      showToastMessage("Data Saved successfully");
    }
    on Exception catch (ex)
    {
      showToastMessage(ex.toString());
    }

  }

  ///add User Method
  addUser() {
    try
    {
      UserModel userModel = UserModel();

      userModel.identityNumber =  int. parse(teIdentityNumberController.text);
      userModel.nameSurname = teNameController.text;
      userModel.phone = tePhoneController.text;
      userModel.eMail = teEmailController.text;
      userModel.isDeleted = false;
      userViewModel.addUser(userModel);
      userViewModel.userList.add(userModel);
      userViewModel.sortUserList();
      userViewModel.onDataChanged?.call();
      //userViewModel.getActiveUserList();

      teIdentityNumberController.text = "";
      teNameController.text = "";
      tePhoneController.text = "";
      teEmailController.text = "";
      Navigator.of(context).pop();
      showToastMessage("Data Saved successfully");
    }
    on Exception catch (ex)
    {
      showToastMessage(ex.toString());
    }

  }

  /// Validation Check
  String? validateName(String? value) {
    if (value!.length < 3) {
      return 'Name must be more than 2 charater';
    } else if (value.length > 30) {
      return 'Name must be less than 30 charater';
    } else{
      return "";}
  }

  String? validateMobile(String? value) {
    String pattern = r'^[0-9]*$';
    RegExp regex = RegExp(pattern);
    if (value?.trim().length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else if (value!.startsWith('+', 0)) {
      return 'Mobile Number should not contain +91';
    } else if (value.trim().contains(" ")) {
      return 'Blank space is not allowed';
    } else if (!regex.hasMatch(value)) {
      return 'Characters are not allowed';
    } else {
      return "";
    }
  }

  String? validateIdetityNumber(String? value) {
    String pattern = r'^[0-9]*$';
    RegExp regex = RegExp(pattern);
    if (value?.trim().length != 10) {
      return 'IdetityNumber must be of 10 digit';
    } else if (!regex.hasMatch(value!)) {
      return 'Characters are not allowed';
    } else {
      return "";
    }
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else if (value.length > 30) {
      return 'Email length exceeds';
    } else {
      return "";
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