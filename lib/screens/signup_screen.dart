import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:furniture_store/components/background.dart';
import 'package:furniture_store/components/custom_button.dart';
import 'package:furniture_store/components/custom_textformfield.dart';
import 'package:furniture_store/controllers/auth_controller.dart';
import 'package:furniture_store/screens/login_screen.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController number = TextEditingController();
  String? grade;
  String? gradeError;
  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('SIGNUP',
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Full Name',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(height: 10.0),
                      CustomTextField(
                        controller: name,
                        obscureText: false,
                        hintText: 'Please enter your name',
                      ),
                      SizedBox(height: 20.0),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Address',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(height: 10.0),
                      CustomTextField(
                        controller: address,
                        obscureText: false,
                        hintText: 'Please enter your address',
                      ),
                      SizedBox(height: 20.0),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(height: 10.0),
                      CustomTextField(
                        isPhoneNumber: true,
                        controller: number,
                        obscureText: false,
                        hintText: 'Please enter your phone number',
                        customValidator: (value) {
                          //validate 10 digits
                          if (value.length != 10) {
                            return 'Please enter a valid phone number';
                          }
                        },
                      ),
                      SizedBox(height: 20.0),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email id',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(height: 10.0),
                      CustomTextField(
                        customValidator: (value) {
                          //email validation
                          final bool isValid = EmailValidator.validate(value);
                          if (!isValid) {
                            return 'Please enter a valid email';
                          }
                        },
                        controller: user,
                        obscureText: false,
                        hintText: 'Please enter your email',
                      ),
                      SizedBox(height: 20.0),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(height: 10.0),
                      CustomTextField(
                        customValidator: (value) {
                          //password validation
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                        },
                        controller: pass,
                        obscureText: true,
                        hintText: 'Please enter your password',
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      CustomButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              authController.signUp(
                                  email: user.text,
                                  name: name.text,
                                  phone: number.text,
                                  address: address.text,
                                  password: pass.text);
                            }
                          },
                          label: "Sign Up"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Have an login ID?",
                        style: TextStyle(fontSize: 15),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text('Log In',
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 16)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
