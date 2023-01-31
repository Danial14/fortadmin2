import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'invoice_input.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formState = GlobalKey<FormState>();
  final _hidePassword = ValueNotifier<bool>(true);
  String _email = "";
  String _password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Flexible(flex: 1,
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(child: Image(
                  image: AssetImage("assets/images/Fortline-logo-white.png"),
                ), flex: 1,),
              ],
            ))
            ,
            SizedBox(
              height: 10,
            ),
            Flexible(flex: 1,
            child: Container(child: Center(child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),elevation: 10,
              child: Form(key: _formState,
                child: Column(

                children: <Widget>[
                  SizedBox(height: 10,),
                  Flexible(child: Text("Login", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),),
                  flex: 1,
                  ),
                  SizedBox(height: 10,),
                  Flexible(child: Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      validator: (val){
                        if(val!.isEmpty || !val.contains("@")){
                          return "Please provide valid email";
                        }
                      },
                      onSaved: (val){
                        _email = val!;
                      },
                    decoration: InputDecoration(
                        hintText: "EMail",
                        prefixIcon: Icon(Icons.alternate_email),
                        fillColor: Color(0xfff6f7fa),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xfff6f7fa)),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        hintStyle: TextStyle(
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfff6f7fa)
                            ),
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                  ),),
                    flex: 1,
                  )
                  ,
                  SizedBox(height: 10,),
                  Flexible(flex: 1,child: Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _hidePassword,
                      builder: (ctx, value, child){
                        return TextFormField(
                          onSaved: (val){
                            _password = val!;
                          },
                          validator: (val){
                            if(val!.length < 6){
                              return "Please provide a password of atleast 6 character";
                            }
                          },
                          obscureText: _hidePassword.value,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(icon: _hidePassword.value ? Icon(Icons.visibility_off) : Icon(Icons.visibility), onPressed: (){
                              _hidePassword.value = !_hidePassword.value;
                            },),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xfff6f7fa)),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xfff6f7fa)),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            filled: true,
                            fillColor: Color(0xfff6f7fa),
                          ),
                        );
                      },
                    )))
                  ,
                  SizedBox(height: 30,),
                  Flexible(child: InkWell(onTap: (){
                    _validateAdmin();
                  },child: Container(
                    width: 300,
                    height: 35,
                    decoration: BoxDecoration(color: Color(0xfff75a27),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(blurRadius: 1.0, offset: Offset(1, 5), color: Colors.black12)
                        ]
                    ),
                    child: Center(child: Text("Login", style: TextStyle(
                        color: Colors.white
                    ),),),
                  ),
                  ),
                    flex: 1,
                  )

                ],
              ),),),), width: 400,),
            )


          ],
        ),
      ),
    );
  }
  void _validateAdmin() async{
    bool isValid = _formState.currentState!.validate();
    if(isValid){
      _formState.currentState!.save();
      try {
        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: _email, password: _password);
        print("Signin successful");
        print(userCredential.user!.email);
        print(userCredential.user!.displayName);
        print(userCredential.user!.uid);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
          return InvoiceInputForm();
        }));
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not login")));
      }
    }
  }
}
