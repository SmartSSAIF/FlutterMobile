import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:THAS/user_repository/user_repository.dart';

import 'package:THAS/authentication/authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository userRepository;

  static final AuthenticationBloc _singleton =
      new AuthenticationBloc._internal();

  factory AuthenticationBloc() {
    return _singleton;
  }

  AuthenticationBloc._internal();

  setUser(UserRepository user) {
    this.userRepository = user;
  }

  // AuthenticationBloc({@required this.userRepository})
  //     : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
