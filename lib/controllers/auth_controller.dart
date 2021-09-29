import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vybez_radio/models/user.dart';
import 'package:vybez_radio/utils/api.dart';
import 'package:vybez_radio/widget/vybez_buttons.dart';

class AuthController extends GetxController {
  Rxn? _user = Rxn<VybezUser>();
  final _isLoading = false.obs;

  // final _isSignUpSuccessful = false.obs;
  final userSharedPrefs = GetStorage();

  bool get isLoading => _isLoading.value;

  set isLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  VybezUser? get user => _user!.value;

  set user(VybezUser? newUser) {
    isLoading = false;
    _user!.value = newUser;
    userSharedPrefs.write('user', newUser);
    print("writing to shared prefs $newUser");
    print(
        "reading from shared prefs in the write ${userSharedPrefs.read('user')}");
  }

  AuthController() {
    loadUser();
  }

  void loadUser() async {
    isLoading = true;
    var userFromSharedPrefs = userSharedPrefs.read('user');
    if (userFromSharedPrefs == null) {
      print("shared prefs is null");
      user = null;
      return null;
    }

    if (userSharedPrefs.read('user') is VybezUser) {
      user = userSharedPrefs.read('user');
      print("reading from shared prefs ${userSharedPrefs.read('user')}");
    } else {
      print("reading from the user object");
      user = VybezUser.fromJson(userSharedPrefs.read('user'));
    }
  }

  void updateProfile({
    @required name,
    @required email,
    @required phoneNumber,
    @required password,
  }) async {
    isLoading = true;
    try {
      API
          .profileUpdate(
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            //Read from storage
            providerID: '',
            provider: '',
          )
          .then((result) => {});
    } on Exception catch (e) {
      print(e.toString());

      Get.dialog(Dialog(
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: Text('An error occured. Please try again'),
        ),
      ));
    } finally {
      isLoading = false;
    }
  }

  void logOut() {
    userSharedPrefs.remove('user');
    user = null;
    // ignore: invalid_return_type_for_catch_error
    GoogleSignIn().signOut().catchError(print);
  }

  // google login
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final phoneNumberController = TextEditingController();
    final locationController = TextEditingController();
    final yearOfBirthController = TextEditingController();
    final genderController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    var genderList = ["Male", "Female"];

    String? selectedGender;

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(credential).then((firebaseUser) {
      Get.dialog(
        Dialog(
          child: Container(
            height: 450,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "More Information",
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: phoneNumberController,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please enter your phone number';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'What is your Phone Number ?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: locationController,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please enter your location';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Listener County',
                          hintText: 'Where are you listening to us from ?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.datetime,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: yearOfBirthController,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Please enter your year of birth';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Year Of Birth',
                          hintText: 'Kindly enter your year of birth',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FormField<String>(
                        initialValue: selectedGender,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        builder: (FormFieldState<String> state) {
                          return StatefulBuilder(builder: (context, setState) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                hintText: 'Kindly Select the gender',
                                errorStyle: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              isEmpty: selectedGender == "",
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Select Gender"),
                                  value: selectedGender,
                                  isDense: true,
                                  onChanged: (String? newValue) {
                                    setState(() => selectedGender = newValue!);
                                  },
                                  items: genderList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          });
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      VybezButtons(
                          text: "Save",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String phoneNumber = phoneNumberController.text;
                              String location = locationController.text;
                              String yearOfBirth =
                                  yearOfBirthController.text.toString();

                              print("phone number is $phoneNumber");
                              print("location is $location");
                              print("Year is $yearOfBirth");
                              print("The selected gender is  $selectedGender");

                              API
                                  .socialSignIn(
                                email: firebaseUser.user!.email,
                                providerID: firebaseUser.user!.uid,
                                name: firebaseUser.user!.displayName,
                                provider: "Google",
                                phoneNumber: phoneNumber,
                                location: location,
                                yearOfBirth: yearOfBirth,
                                gender: selectedGender,
                              )
                                  .then((result) {
                                if (result.statusCode == 200) {
                                  var json = jsonDecode(result.body);
                                  String? photoUrl =
                                      firebaseUser.user!.photoURL;

                                  VybezUser vybezUser = VybezUser(
                                    id: json['user']['id'],
                                    email: json['user']['email'],
                                    name: json['user']['name'],
                                    phone: phoneNumber,
                                    photoUrl: photoUrl,
                                  );
                                  user = vybezUser;
                                }
                                // ignore: invalid_return_type_for_catch_error
                              }).catchError(print);
                            }
                            // print("save Details");

                            Get.back();
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      print(firebaseUser.user?.email);
      print(firebaseUser.user?.displayName);
      print(firebaseUser.user?.phoneNumber);
    });
  }

  Future appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId: 'ke.co.standardmedia.vybezradio',
        redirectUri: Uri.parse(
          'https://standardgroupall.firebaseapp.com/__/auth/handler',
        ),
      ),
    );

    final phoneNumberController = TextEditingController();
    final locationController = TextEditingController();
    final yearOfBirthController = TextEditingController();
    final genderController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    var genderList = ["Male", "Female"];

    String? selectedGender;

    Get.dialog(
      Dialog(
        child: Container(
          height: 450,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "More Information",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: phoneNumberController,
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please enter your phone number';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'What is your Phone Number ?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: locationController,
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter your location';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Listener County',
                        hintText: 'Where are you listening to us from ?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: yearOfBirthController,
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please enter your year of birth';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Year Of Birth',
                        hintText: 'Kindly enter your year of birth',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FormField<String>(
                      initialValue: selectedGender,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      builder: (FormFieldState<String> state) {
                        return StatefulBuilder(builder: (context, setState) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              hintText: 'Kindly Select the gender',
                              errorStyle: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            isEmpty: selectedGender == "",
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Text("Select Gender"),
                                value: selectedGender,
                                isDense: true,
                                onChanged: (String? newValue) {
                                  setState(() => selectedGender = newValue!);
                                },
                                items: genderList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    VybezButtons(
                        text: "Save",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            String phoneNumber = phoneNumberController.text;
                            String location = locationController.text;
                            String yearOfBirth =
                                yearOfBirthController.text.toString();

                            print("phone number is $phoneNumber");
                            print("location is $location");
                            print("Year is $yearOfBirth");
                            print("The selected gender is  $selectedGender");

                            API
                                .socialSignIn(
                              email: credential.email,
                              providerID: credential.userIdentifier,
                              name: credential.givenName,
                              provider: "Apple",
                              phoneNumber: phoneNumber,
                              location: location,
                              yearOfBirth: yearOfBirth,
                              gender: selectedGender,
                            )
                                .then((result) {
                              if (result.statusCode == 200) {
                                var json = jsonDecode(result.body);

                                VybezUser vybezUser = VybezUser(
                                  id: json['user']['id'],
                                  email: json['user']['email'],
                                  name: json['user']['name'],
                                  phone: phoneNumber,
                                );
                                user = vybezUser;
                              }
                              // ignore: invalid_return_type_for_catch_error
                            }).catchError(print);
                          }
                          // print("save Details");

                          Get.back();
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    print("The user credentials are $credential");
  }
}
