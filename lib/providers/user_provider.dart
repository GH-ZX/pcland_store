import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String? address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      profileImage: json['profile_image'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
      'address': address,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImage,
    String? address,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
    );
  }
}

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  final String _userKey = 'user_data';
  final String _usersKey = 'registered_users';
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  Future<void> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      
      if (userData != null) {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        _user = User.fromJson(userMap);
        notifyListeners();
      }
    } catch (e) {
      print('Error during auto login: $e');
    }
  }

  // إضافة مستخدم جديد إلى قائمة المستخدمين المسجلين
  Future<void> _addUserToRegisteredUsers(User user, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      List<Map<String, dynamic>> users = [];
      if (usersJson != null) {
        users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
      }
      
      // التحقق من عدم وجود مستخدم بنفس البريد الإلكتروني
      final existingUserIndex = users.indexWhere((u) => u['email'] == user.email);
      if (existingUserIndex != -1) {
        // تحديث بيانات المستخدم الموجود
        users[existingUserIndex] = {
          ...user.toJson(),
          'password': password,
        };
      } else {
        // إضافة مستخدم جديد
        users.add({
          ...user.toJson(),
          'password': password,
        });
      }
      
      await prefs.setString(_usersKey, jsonEncode(users));
      // طباعة قائمة المستخدمين للتأكد من حفظ البيانات بشكل صحيح
      print('Registered users: ${users.length}');
      print('Last registered user: ${users.last['email']}');
    } catch (e) {
      print('Error adding user to registered users: $e');
      rethrow; // إعادة رمي الخطأ للتعامل معه في الدالة التي استدعت هذه الدالة
    }
  }

  // التحقق من صحة بيانات تسجيل الدخول
  Future<User?> _verifyCredentials(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      if (usersJson == null) {
        return null;
      }
      
      final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
      final userIndex = users.indexWhere(
        (u) => u['email'] == email && u['password'] == password
      );
      
      if (userIndex != -1) {
        final userData = Map<String, dynamic>.from(users[userIndex]);
        userData.remove('password'); // إزالة كلمة المرور من البيانات المُرجعة
        return User.fromJson(userData);
      }
      
      return null;
    } catch (e) {
      print('Error verifying credentials: $e');
      return null;
    }
  }

  Future<bool> loginWithCredentials({
    required String email,
    required String name,
    required String phoneNumber,
    String? profileImage,
    String? address,
    String password = '123', // كلمة مرور افتراضية
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // تسجيل الدخول بالبيانات المحددة مباشرة
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        profileImage: profileImage ?? 'https://via.placeholder.com/150',
        address: address,
      );
      
      // حفظ بيانات المستخدم في التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
      
      // إضافة المستخدم إلى قائمة المستخدمين المسجلين
      await _addUserToRegisteredUsers(_user!, password);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الدخول';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // تسجيل الخروج أولاً لضمان عدم وجود جلسة سابقة
      await _googleSignIn.signOut();
      
      // محاولة تسجيل الدخول باستخدام Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // المستخدم ألغى عملية تسجيل الدخول
        _error = 'تم إلغاء تسجيل الدخول';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('Google Sign-In successful for: ${googleUser.email}');
      
      // التحقق ما إذا كان المستخدم مسجل بالفعل
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      if (usersJson != null) {
        final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
        final existingUserIndex = users.indexWhere((u) => u['email'] == googleUser.email);
        
        // إذا كان المستخدم مسجل بالفعل، قم بتسجيل الدخول باستخدام بياناته المخزنة
        if (existingUserIndex != -1) {
          print('Found existing Google user');
          final userData = Map<String, dynamic>.from(users[existingUserIndex]);
          userData.remove('password'); // إزالة كلمة المرور من البيانات المُرجعة
          _user = User.fromJson(userData);
          
          // تحديث بيانات المستخدم من Google إذا تغيرت
          if (_user!.name != googleUser.displayName && googleUser.displayName != null) {
            _user = _user!.copyWith(name: googleUser.displayName);
            
            // تحديث بيانات المستخدم في قائمة المستخدمين المسجلين
            users[existingUserIndex]['name'] = googleUser.displayName;
            await prefs.setString(_usersKey, jsonEncode(users));
          }
          
          // حفظ بيانات المستخدم في التخزين المحلي
          await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
          
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
      
      print('Creating new Google user account');
      // إنشاء حساب جديد للمستخدم من بيانات Google
      _user = User(
        id: 'google_${googleUser.id}',
        name: googleUser.displayName ?? 'مستخدم Google',
        email: googleUser.email,
        phoneNumber: '', // لا يمكن الحصول على رقم الهاتف من Google
        profileImage: googleUser.photoUrl ?? 'https://via.placeholder.com/150',
        address: '',
      );
      
      // حفظ بيانات المستخدم في التخزين المحلي
      await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
      
      // إضافة المستخدم إلى قائمة المستخدمين المسجلين مع كلمة مرور عشوائية
      // (لن يستخدمها المستخدم لأنه يسجل الدخول عبر Google)
      final randomPassword = DateTime.now().millisecondsSinceEpoch.toString();
      await _addUserToRegisteredUsers(_user!, randomPassword);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الدخول بواسطة Google';
      print('Google Sign-In Error: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // التحقق من صحة بيانات تسجيل الدخول
      final user = await _verifyCredentials(email, password);
      
      if (user != null) {
        _user = user;
        
        // حفظ بيانات المستخدم في التخزين المحلي
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      // حالة خاصة للمستخدم الافتراضي ahmad@example.com
      if (email == 'ahmad@example.com' && password == '123') {
        return await loginWithCredentials(
          email: 'ahmad@example.com',
          name: 'Ahmad',
          phoneNumber: '+966500000000',
        );
      }
      
      _error = 'بيانات الدخول غير صحيحة';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String phoneNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // محاكاة تسجيل - في التطبيق الحقيقي، سيكون هذا استدعاء API
      await Future.delayed(const Duration(seconds: 1));
      
      // محاكاة نجاح تسجيل
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      );
      
      // حفظ بيانات المستخدم في التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
      
      // إضافة المستخدم إلى قائمة المستخدمين المسجلين
      await _addUserToRegisteredUsers(_user!, password);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'حدث خطأ أثناء إنشاء الحساب';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      print('Error during logout: $e');
    }
    
    notifyListeners();
  }

  Future<void> updateUserProfile(User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      // محاكاة تحديث - في التطبيق الحقيقي، سيكون هذا استدعاء API
      await Future.delayed(const Duration(seconds: 1));
      
      _user = updatedUser;
      
      // حفظ بيانات المستخدم المحدثة في التخزين المحلي
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'حدث خطأ أثناء تحديث البيانات';
      _isLoading = false;
      notifyListeners();
    }
  }
}
