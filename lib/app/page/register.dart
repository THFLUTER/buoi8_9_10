import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/register.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _gender = 0;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURL = TextEditingController();
  String gendername = 'None';
  String temp = '';

  Future<String> register() async {
    return await APIRepository().register(Signup(
        accountID: _accountController.text,
        birthDay: _birthDayController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneNumberController.text,
        schoolKey: _schoolKeyController.text,
        schoolYear: _schoolYearController.text,
        gender: getGender(),
        imageUrl: _imageURL.text,
        numberID: _numberIDController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Đăng ký tài khoản',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),
                signUpWidget(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String response = await register();
                        if (response == 'ok') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        } else {
                          print(response);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal, // Màu văn bản của nút
                        elevation: 2, // Độ nổi của nút
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Đường viền cong
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 160, vertical: 14), // Độ lớn của nút
                      ),
                      child: const Text('Register'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getGender() {
    if (_gender == 1) {
      return "Male";
    } else if (_gender == 2) {
      return "Female";
    }
    return "Other";
  }

  Widget textField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        onChanged: (value) {
          setState(() {
            temp = value;
          });
        },
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          border: const OutlineInputBorder(),
          errorText: controller.text.trim().isEmpty ? 'Please enter' : null,
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget signUpWidget() {
    return Column(
      children: [
        _buildInputField(
          controller: _accountController,
          labelText: "Account",
          icon: Icons.person,
          iconColor: Colors.teal,
        ),
        const SizedBox(height: 20),
        _buildInputField(
            controller: _passwordController,
            labelText: "Password",
            icon: Icons.lock,
            obscureText: true,
            iconColor: Colors.teal),
        const SizedBox(height: 20),
        _buildInputField(
            controller: _confirmPasswordController,
            labelText: "Confirm Password",
            icon: Icons.lock,
            obscureText: true,
            iconColor: Colors.teal),
        const SizedBox(height: 20),
        _buildInputField(
            controller: _fullNameController,
            labelText: "Full Name",
            icon: Icons.person_outline,
            iconColor: Colors.teal),
        const SizedBox(height: 20),
        _buildInputField(
            controller: _numberIDController,
            labelText: "Number ID",
            icon: Icons.confirmation_num,
            iconColor: Colors.teal),
        const SizedBox(height: 20),
        _buildInputField(
            controller: _phoneNumberController,
            labelText: "Phone Number",
            icon: Icons.phone,
            iconColor: Colors.teal),
        const SizedBox(height: 20),
        _buildInputField(
            controller: _birthDayController,
            labelText: "Birth Day",
            icon: Icons.calendar_today,
            iconColor: Colors.teal),
        const SizedBox(height: 20),
        _buildInputField(
            controller: _schoolYearController,
            labelText: "School Year",
            icon: Icons.school,
            iconColor: Colors.teal),
        const SizedBox(height: 20),
        _buildInputField(
            controller: _schoolKeyController,
            labelText: "School Key",
            icon: Icons.school,
            iconColor: Colors.teal),
        const SizedBox(height: 20),
        const Text("What is your Gender?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: 1,
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            const Text("Male"),
            Radio(
              value: 2,
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            const Text("Female"),
            Radio(
              value: 3,
              groupValue: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            const Text("Other"),
          ],
        ),
        const SizedBox(height: 20),
        _buildInputField(
          controller: _imageURL,
          labelText: "Image URL",
          icon: Icons.image,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    Color? iconColor, // Thêm một tham số để truyền màu của icon
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: iconColor, // Sử dụng màu của icon
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
