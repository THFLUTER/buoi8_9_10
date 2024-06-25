import 'dart:convert';

import 'package:app_api/app/data/api.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // Khởi tạo user trong initState
  APIRepository apiRepository = APIRepository();
  String _token = "";
  User _currentUser = User(
      idNumber: '',
      accountId: '',
      fullName: '',
      phoneNumber: '',
      imageURL: '',
      birthDay: '',
      gender: '',
      schoolYear: '',
      schoolKey: '',
      dateCreated: '',
      status: null);

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";
    setState(() {
      _token = token;
    });
    if (token.isNotEmpty) {
      try {
        User user = await apiRepository.current(token);
        setState(() {
          _currentUser = user;
        });
      } catch (ex) {
        print("Error fetching user info: $ex");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin người dùng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0, // Độ nâng của AppBar, giảm để không có bóng
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        '${_currentUser.imageURL}',
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${_currentUser.fullName}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: const Text(
                    'Account ID',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${_currentUser.accountId}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  leading: const Icon(Icons.person, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: const Text(
                    'Số điện thoại',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${_currentUser.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  leading: const Icon(Icons.phone, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: const Text(
                    'Ngày sinh',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${_currentUser.birthDay}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  leading: const Icon(Icons.calendar_today, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: const Text(
                    'Giới tính',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${_currentUser.gender}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  leading: const Icon(Icons.person_outline, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: const Text(
                    'Năm học',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${_currentUser.schoolYear}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  leading: Icon(Icons.school, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: const Text(
                    'Khóa học',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${_currentUser.schoolKey}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  leading: Icon(Icons.school, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: const Text(
                    'Ngày tạo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${_currentUser.dateCreated}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  leading: const Icon(Icons.date_range, color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
