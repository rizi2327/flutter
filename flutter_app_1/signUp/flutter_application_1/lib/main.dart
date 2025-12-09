import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignUp App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  String _passwordStrength = 'None';
  Color _strengthColor = Colors.grey;
  
  bool _isUsernameValid = false;
  bool _isPasswordValid = false;
  bool _doPasswordsMatch = false;
  
  // Check password complexity
  void _checkPasswordStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    setState(() {
      if (strength == 0) {
        _passwordStrength = 'None';
        _strengthColor = Colors.grey;
      } else if (strength <= 2) {
        _passwordStrength = 'Weak';
        _strengthColor = Colors.red;
      } else if (strength == 3) {
        _passwordStrength = 'Fair';
        _strengthColor = Colors.orange;
      } else if (strength == 4) {
        _passwordStrength = 'Good';
        _strengthColor = Colors.yellow;
      } else {
        _passwordStrength = 'Strong';
        _strengthColor = Colors.green;
      }
      
      _isPasswordValid = strength >= 3;
    });
  }
  
  // Check if passwords match
  void _checkPasswordMatch() {
    setState(() {
      _doPasswordsMatch = _passwordController.text == _confirmPasswordController.text 
          && _passwordController.text.isNotEmpty;
    });
  }
  
  void _validateUsername() {
    setState(() {
      _isUsernameValid = _usernameController.text.length >= 3;
    });
  }
  
  void _submitForm() {
    if (_isUsernameValid && _isPasswordValid && _doPasswordsMatch) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success!'),
          content: Text('Account created for ' + _usernameController.text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 30),
            
            // Username Field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                errorText: _isUsernameValid || _usernameController.text.isEmpty 
                    ? null 
                    : 'Username must be at least 3 characters',
              ),
              onChanged: (value) => _validateUsername(),
            ),
            SizedBox(height: 20),
            
            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(
                  _isPasswordValid ? Icons.check_circle : Icons.error,
                  color: _isPasswordValid ? Colors.green : Colors.red,
                ),
              ),
              onChanged: (value) {
                _checkPasswordStrength(value);
                _checkPasswordMatch();
              },
            ),
            SizedBox(height: 10),
            
            // Password Strength Indicator
            Row(
              children: [
                Text('Password Strength: '),
                Text(
                  _passwordStrength,
                  style: TextStyle(
                    color: _strengthColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            LinearProgressIndicator(
              value: _passwordStrength == 'Weak' ? 0.25 
                    : _passwordStrength == 'Fair' ? 0.5
                    : _passwordStrength == 'Good' ? 0.75
                    : _passwordStrength == 'Strong' ? 1.0 : 0.0,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
            ),
            SizedBox(height: 20),
            
            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_reset),
                errorText: _doPasswordsMatch || _confirmPasswordController.text.isEmpty
                    ? null
                    : 'Passwords do not match',
              ),
              onChanged: (value) => _checkPasswordMatch(),
            ),
            SizedBox(height: 30),
            
            // Sign Up Button
            ElevatedButton(
              onPressed: (_isUsernameValid && _isPasswordValid && _doPasswordsMatch)
                  ? _submitForm
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}