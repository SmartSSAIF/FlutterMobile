import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:THAS/authentication/authentication.dart';
import 'package:THAS/login/login.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;

  LoginForm({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc get _loginBloc => widget.loginBloc;
  final _formKey = GlobalKey<FormState>();

  String senha;
  bool textoObscuro = true;

  void toggle() {
    setState(() {
      textoObscuro = !textoObscuro;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        FocusNode textSecond = new FocusNode();

        return new Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(50),
                      ),
                      Row(
                        children: <Widget>[
                          Center(
                            child: Image.asset("assets/thasCompleto.png",
                                width: 350),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(100),
                      ),
                      Form(
                        //  elevation: 8.0,
                        key: _formKey,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    labelText: "Email",
                                    border: OutlineInputBorder()),
                                validator: (val) => val.length < 2
                                    ? "Digite o seu usuário"
                                    : null,
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(textSecond);
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              // Row(
                              //   children: <Widget>[
                              new TextFormField(
                                controller: _passwordController,
                                focusNode: textSecond,
                                decoration: InputDecoration(
                                    labelText: 'Senha',
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(textoObscuro
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: toggle,
                                    ),
                                    prefixIcon: const Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: const Icon(Icons.lock))),
                                validator: (val) => val.length < 4
                                    ? 'Senha muito curta.'
                                    : null,
                                onSaved: (val) => senha = val,
                                obscureText: textoObscuro,
                              ),

                              //   ],
                              // ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(30.0),
                                //elevation: 5.0,
                                child: MaterialButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      if (state is! LoginLoading) {
                                        _onLoginButtonPressed();
                                      }
                                    }
                                  },
                                  //child: Text('Login'),
                                  // Route route = MaterialPageRoute(
                                  //     builder: (context) => new MyApp());

                                  // Navigator.pushReplacement(context, route);

                                  minWidth: 150.0,
                                  height: 50.0,
                                  color: Color(0xFF179CDF),
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    _loginBloc.dispatch(LoginButtonPressed(
      username: _usernameController.text,
      password: _passwordController.text,
    ));
  }
}
