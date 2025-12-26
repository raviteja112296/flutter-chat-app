import 'dart:io';

import 'package:chat_app/services/cloudinary_service.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _pickedImageFile;

  String _email = '';
  String _password = '';
  String _username = '';

  bool _isLogin = true;
  bool _isLoading = false;

  // ---------------- SUBMIT ----------------
  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) return;

    if (!_isLogin && _pickedImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() => _isLoading = true);

      if (_isLogin) {
        // 🔐 LOGIN
        await _firebase.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } else {
        // 🆕 SIGNUP
        final cred = await _firebase.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        final uid = cred.user!.uid;

        final imageUrl =
            await CloudinaryService.uploadImage(_pickedImageFile!);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({
          'username': _username,
          'email': _email,
          'image_url': imageUrl,
          'createdAt': Timestamp.now(),
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication failed')),
      );
    }

    setState(() => _isLoading = false);
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),

              Image.asset(
                'assets/images/chat.png',
                width: 180,
              ),

              const SizedBox(height: 20),

              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // IMAGE (SIGNUP)
                        if (!_isLogin)
                          UserImagePicker(
                            onPickImage: (image) {
                              _pickedImageFile = image;
                            },
                          ),

                        // EMAIL
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!.trim();
                          },
                        ),

                        // USERNAME (SIGNUP)
                        if (!_isLogin)
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Username'),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().length < 4) {
                                return 'Min 4 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _username = value!.trim();
                            },
                          ),

                        // PASSWORD
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Min 6 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),

                        const SizedBox(height: 16),

                        if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          ElevatedButton(
                            onPressed: _submit,
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                          ),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? 'Create new account'
                                : 'I already have an account Login',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
