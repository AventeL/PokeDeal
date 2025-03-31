// Mocks generated by Mockito 5.4.5 from annotations
// in pokedeal/test/mocks/generated_mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:bloc/bloc.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i8;
import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart'
    as _i4;
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart'
    as _i2;
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart'
    as _i3;
import 'package:supabase_flutter/supabase_flutter.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAuthenticationRepository_0 extends _i1.SmartFake
    implements _i2.AuthenticationRepository {
  _FakeAuthenticationRepository_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeAuthenticationState_1 extends _i1.SmartFake
    implements _i3.AuthenticationState {
  _FakeAuthenticationState_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeIAuthenticationDataSource_2 extends _i1.SmartFake
    implements _i4.IAuthenticationDataSource {
  _FakeIAuthenticationDataSource_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeAuthResponse_3 extends _i1.SmartFake implements _i5.AuthResponse {
  _FakeAuthResponse_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [AuthenticationBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationBloc extends _i1.Mock
    implements _i3.AuthenticationBloc {
  @override
  _i2.AuthenticationRepository get authenticationRepository =>
      (super.noSuchMethod(
            Invocation.getter(#authenticationRepository),
            returnValue: _FakeAuthenticationRepository_0(
              this,
              Invocation.getter(#authenticationRepository),
            ),
            returnValueForMissingStub: _FakeAuthenticationRepository_0(
              this,
              Invocation.getter(#authenticationRepository),
            ),
          )
          as _i2.AuthenticationRepository);

  @override
  _i3.AuthenticationState get state =>
      (super.noSuchMethod(
            Invocation.getter(#state),
            returnValue: _FakeAuthenticationState_1(
              this,
              Invocation.getter(#state),
            ),
            returnValueForMissingStub: _FakeAuthenticationState_1(
              this,
              Invocation.getter(#state),
            ),
          )
          as _i3.AuthenticationState);

  @override
  _i6.Stream<_i3.AuthenticationState> get stream =>
      (super.noSuchMethod(
            Invocation.getter(#stream),
            returnValue: _i6.Stream<_i3.AuthenticationState>.empty(),
            returnValueForMissingStub:
                _i6.Stream<_i3.AuthenticationState>.empty(),
          )
          as _i6.Stream<_i3.AuthenticationState>);

  @override
  bool get isClosed =>
      (super.noSuchMethod(
            Invocation.getter(#isClosed),
            returnValue: false,
            returnValueForMissingStub: false,
          )
          as bool);

  @override
  void add(_i3.AuthenticationEvent? event) => super.noSuchMethod(
    Invocation.method(#add, [event]),
    returnValueForMissingStub: null,
  );

  @override
  void onEvent(_i3.AuthenticationEvent? event) => super.noSuchMethod(
    Invocation.method(#onEvent, [event]),
    returnValueForMissingStub: null,
  );

  @override
  void emit(_i3.AuthenticationState? state) => super.noSuchMethod(
    Invocation.method(#emit, [state]),
    returnValueForMissingStub: null,
  );

  @override
  void on<E extends _i3.AuthenticationEvent>(
    _i7.EventHandler<E, _i3.AuthenticationState>? handler, {
    _i7.EventTransformer<E>? transformer,
  }) => super.noSuchMethod(
    Invocation.method(#on, [handler], {#transformer: transformer}),
    returnValueForMissingStub: null,
  );

  @override
  void onTransition(
    _i7.Transition<_i3.AuthenticationEvent, _i3.AuthenticationState>?
    transition,
  ) => super.noSuchMethod(
    Invocation.method(#onTransition, [transition]),
    returnValueForMissingStub: null,
  );

  @override
  _i6.Future<void> close() =>
      (super.noSuchMethod(
            Invocation.method(#close, []),
            returnValue: _i6.Future<void>.value(),
            returnValueForMissingStub: _i6.Future<void>.value(),
          )
          as _i6.Future<void>);

  @override
  void onChange(_i7.Change<_i3.AuthenticationState>? change) =>
      super.noSuchMethod(
        Invocation.method(#onChange, [change]),
        returnValueForMissingStub: null,
      );

  @override
  void addError(Object? error, [StackTrace? stackTrace]) => super.noSuchMethod(
    Invocation.method(#addError, [error, stackTrace]),
    returnValueForMissingStub: null,
  );

  @override
  void onError(Object? error, StackTrace? stackTrace) => super.noSuchMethod(
    Invocation.method(#onError, [error, stackTrace]),
    returnValueForMissingStub: null,
  );
}

/// A class which mocks [AuthenticationRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationRepository extends _i1.Mock
    implements _i2.AuthenticationRepository {
  @override
  _i4.IAuthenticationDataSource get authenticationDataSource =>
      (super.noSuchMethod(
            Invocation.getter(#authenticationDataSource),
            returnValue: _FakeIAuthenticationDataSource_2(
              this,
              Invocation.getter(#authenticationDataSource),
            ),
            returnValueForMissingStub: _FakeIAuthenticationDataSource_2(
              this,
              Invocation.getter(#authenticationDataSource),
            ),
          )
          as _i4.IAuthenticationDataSource);

  @override
  _i6.Future<_i5.AuthResponse> signInWithEmail(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#signInWithEmail, [email, password]),
            returnValue: _i6.Future<_i5.AuthResponse>.value(
              _FakeAuthResponse_3(
                this,
                Invocation.method(#signInWithEmail, [email, password]),
              ),
            ),
            returnValueForMissingStub: _i6.Future<_i5.AuthResponse>.value(
              _FakeAuthResponse_3(
                this,
                Invocation.method(#signInWithEmail, [email, password]),
              ),
            ),
          )
          as _i6.Future<_i5.AuthResponse>);

  @override
  _i6.Future<_i5.AuthResponse> signUpWithEmail(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#signUpWithEmail, [email, password]),
            returnValue: _i6.Future<_i5.AuthResponse>.value(
              _FakeAuthResponse_3(
                this,
                Invocation.method(#signUpWithEmail, [email, password]),
              ),
            ),
            returnValueForMissingStub: _i6.Future<_i5.AuthResponse>.value(
              _FakeAuthResponse_3(
                this,
                Invocation.method(#signUpWithEmail, [email, password]),
              ),
            ),
          )
          as _i6.Future<_i5.AuthResponse>);

  @override
  _i6.Future<void> signOut() =>
      (super.noSuchMethod(
            Invocation.method(#signOut, []),
            returnValue: _i6.Future<void>.value(),
            returnValueForMissingStub: _i6.Future<void>.value(),
          )
          as _i6.Future<void>);
}

/// A class which mocks [IAuthenticationDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockIAuthenticationDataSource extends _i1.Mock
    implements _i4.IAuthenticationDataSource {
  @override
  _i6.Future<_i5.AuthResponse> signInWithEmail(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#signInWithEmail, [email, password]),
            returnValue: _i6.Future<_i5.AuthResponse>.value(
              _FakeAuthResponse_3(
                this,
                Invocation.method(#signInWithEmail, [email, password]),
              ),
            ),
            returnValueForMissingStub: _i6.Future<_i5.AuthResponse>.value(
              _FakeAuthResponse_3(
                this,
                Invocation.method(#signInWithEmail, [email, password]),
              ),
            ),
          )
          as _i6.Future<_i5.AuthResponse>);

  @override
  _i6.Future<_i5.AuthResponse> signUpWithEmail(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#signUpWithEmail, [email, password]),
            returnValue: _i6.Future<_i5.AuthResponse>.value(
              _FakeAuthResponse_3(
                this,
                Invocation.method(#signUpWithEmail, [email, password]),
              ),
            ),
            returnValueForMissingStub: _i6.Future<_i5.AuthResponse>.value(
              _FakeAuthResponse_3(
                this,
                Invocation.method(#signUpWithEmail, [email, password]),
              ),
            ),
          )
          as _i6.Future<_i5.AuthResponse>);

  @override
  _i6.Future<void> signOut() =>
      (super.noSuchMethod(
            Invocation.method(#signOut, []),
            returnValue: _i6.Future<void>.value(),
            returnValueForMissingStub: _i6.Future<void>.value(),
          )
          as _i6.Future<void>);

  @override
  String getCurrentUserEmail() =>
      (super.noSuchMethod(
            Invocation.method(#getCurrentUserEmail, []),
            returnValue: _i8.dummyValue<String>(
              this,
              Invocation.method(#getCurrentUserEmail, []),
            ),
            returnValueForMissingStub: _i8.dummyValue<String>(
              this,
              Invocation.method(#getCurrentUserEmail, []),
            ),
          )
          as String);
}
