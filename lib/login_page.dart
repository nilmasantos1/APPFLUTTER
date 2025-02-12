import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'user.dart';
import 'todo_page.dart';

class LoginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Nome de Usuário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  fillColor: Colors.white,
                  filled: true,
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                var box = await Hive.openBox<User>('users');
                var user = box.values.firstWhere(
                    (user) => user.username == usernameController.text && user.password == passwordController.text,
                    orElse: () => User('default', 'default'));

                if (user.username != 'default') {
                  // Login bem-sucedido
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Login bem-sucedido'),
                    backgroundColor: Colors.green,
                  ));
                  // Redirecione para a TodoPage após o login bem-sucedido
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TodoPage()));
                } else {
                  // Login falhou
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Nome de usuário ou senha incorretos'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
              ),
              child: Text(
                'Fazer Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
