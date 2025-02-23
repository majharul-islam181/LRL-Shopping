import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lrl_shopping/feature/auth/presentation/pages/login_page.dart';
import 'package:lrl_shopping/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:lrl_shopping/feature/auth/presentation/cubit/login_state.dart';
import 'package:lrl_shopping/feature/home-settings/presentation/pages/home_page.dart';
import 'package:lrl_shopping/feature/auth/domain/entites/user.dart';

class MockLoginCubit extends Mock implements LoginCubit {}

void main() {
  late MockLoginCubit mockLoginCubit;

  // ✅ Mock User Definition
  final mockUser = User(
    id: 1,
    name: "Test User",
    email: "test@example.com",
    mobile: "1234567890",
    token: "mock_token_123",
  );

  setUp(() {
    mockLoginCubit = MockLoginCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<LoginCubit>(
        create: (context) => mockLoginCubit,
        child: EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'assets/language',
          fallbackLocale: const Locale('en'),
          child: LoginPage(),
        ),
      ),
    );
  }

  testWidgets('✅ Displays email, password fields, and login button',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify text fields and button exist
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text("login".tr()), findsOneWidget);
  });

  testWidgets('✅ User enters credentials and taps login button',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Enter email and password
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password123');

    // Tap login button
    await tester.tap(find.text("login".tr()));
    await tester.pump();

    // Verify loginUser was called
    verify(() => mockLoginCubit.loginUser('test@example.com', 'password123'))
        .called(1);
  });

  testWidgets('✅ Shows loading indicator when LoginCubit is in LoginLoading state',
      (WidgetTester tester) async {
    when(() => mockLoginCubit.state).thenReturn(LoginLoading());

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Verify CircularProgressIndicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('✅ Navigates to HomePage on successful login',
      (WidgetTester tester) async {
    when(() => mockLoginCubit.state)
        .thenReturn(LoginSuccess(user: mockUser));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify navigation to HomePage
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('✅ Displays error message when LoginCubit emits LoginError',
      (WidgetTester tester) async {
    when(() => mockLoginCubit.state)
        .thenReturn(LoginError(message: "Invalid credentials"));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Verify error message appears in Snackbar
    expect(find.text("Invalid credentials"), findsOneWidget);
  });
}
