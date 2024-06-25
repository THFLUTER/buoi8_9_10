import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/mainpage.dart';
import 'package:flutter/material.dart';
import '../register.dart';
import '../../data/sharepre.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    String token = await APIRepository().login(
      accountController.text,
      passwordController.text,
    );
    var user = await APIRepository().current(token);
    saveUser(user);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Mainpage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Image.asset(
                  urlLogo,
                  width: 200,
                  height: 200,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: accountController,
                      labelText: 'Account',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: passwordController,
                      labelText: 'Mật khẩu',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    _buildButton(
                      label: 'Đăng nhập',
                      onPressed: login,
                      backgroundColor: Colors.teal,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    _buildButton(
                      label: 'Đăng ký',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      },
                      backgroundColor: Colors.white,
                      textColor: Colors.teal,
                      outlined: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    bool outlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: outlined ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
