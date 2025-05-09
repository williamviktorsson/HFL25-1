import 'dart:ui';

import 'package:app/bloc/auth/auth_bloc.dart';
import 'package:app/bloc/items/items_bloc.dart';
import 'package:app/bloc/user/user_bloc.dart';
import 'package:app/cubit/selected_item_cubit.dart';
import 'package:app/repositories/item_repository.dart';
import 'package:app/services/notification_service.dart';
import 'package:app/views/example_view.dart';
import 'package:app/views/items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationsService.initialize();

  runApp(BlocProvider(
      create: (context) => AuthBloc()..add(AuthSubscribeToChanges()),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Managing App',
      home: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
          child: const AuthViewSwitcher()),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  const AuthViewSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final isLoggedIn = authState is AuthSuccess;

    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("${state.error}")));
        }
      },
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: isLoggedIn
              ? BlocProvider(
                  create: (context) => UserBloc(authenticated: authState)
                    ..add(UserSubscribeToChanges()),
                  child: const UserViewSwitcher())
              : const AuthView()),
    ));
  }
}

class UserViewSwitcher extends StatelessWidget {
  const UserViewSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      return BlocListener<UserBloc, UserState>(
        listener: (BuildContext context, UserState state) {
          if (state is UserExists) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.greenAccent,
                content: Text("Welcome ${state.username}")));
          }
        },
        child: Builder(builder: (context) {
          final userState = context.watch<UserBloc>().state;

          if (userState is UserInitial) {
            return Material(); // quick blank screen ...
          }

          final userExists = userState is UserExists;
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: userExists ? NavRailView() : const FinalizeAccountView());
        }),
      );
    }));
  }
}

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _isLoginView = true;

  void _toggleView() {
    setState(() {
      _isLoginView = !_isLoginView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(_isLoginView ? -1.0 : 1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _isLoginView
            ? LoginView(toggleView: _toggleView, key: const ValueKey('login'))
            : RegisterView(
                toggleView: _toggleView, key: const ValueKey('register')),
      ),
    );
  }
}

class FinalizeAccountView extends StatefulWidget {
  const FinalizeAccountView({super.key});

  @override
  State<FinalizeAccountView> createState() => _FinalizeAccountViewState();
}

class _FinalizeAccountViewState extends State<FinalizeAccountView> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocus = FocusNode();

  String _username = '';

  @override
  void initState() {
    super.initState();
    // Request focus after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _usernameFocus.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<UserBloc>().add(UserCreate(username: _username));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<UserBloc>().state;
    final bool isLoading = authStatus is UserCreateInProgress;

    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Finalize account',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                focusNode: _usernameFocus,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a username'
                    : null,
                onSaved: (value) => _username = value!,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _save(context),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Finalize'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  final VoidCallback toggleView;

  const LoginView({
    required this.toggleView,
    required Key key,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _email = 'test@test.com';
  String _password = 'abc123';

  @override
  void initState() {
    super.initState();
    // Request focus after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<AuthBloc>().login(email: _email, password: _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthBloc>().state;
    final bool isLoading = authStatus is AuthInProgress;

    return Form(
      key: _formKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: _email,
              focusNode: _emailFocus,
              enabled: !isLoading,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (value) => _email = value!,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _password,
              focusNode: _passwordFocus,
              obscureText: true,
              enabled: !isLoading,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a password'
                  : null,
              onSaved: (value) => _password = value!,
              onFieldSubmitted: (_) => _save(context),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _save(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Login'),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: !isLoading ? widget.toggleView : null,
              child: const Text('Need an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterView extends StatefulWidget {
  final VoidCallback toggleView;

  const RegisterView({
    required this.toggleView,
    required Key key,
  }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  String _username = '';
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    // Request focus after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<AuthBloc>().register(
            username: _username,
            email: _email,
            password: _password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthBloc>().state;
    final bool isLoading = authStatus is AuthInProgress;

    return Form(
      key: _formKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Register',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              focusNode: _usernameFocus,
              enabled: !isLoading,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a username'
                  : null,
              onSaved: (value) => _username = value!,
              onFieldSubmitted: (_) => _emailFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: _emailFocus,
              enabled: !isLoading,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (value) => _email = value!,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: _passwordFocus,
              obscureText: true,
              enabled: !isLoading,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              onSaved: (value) => _password = value!,
              onFieldSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _save(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Register'),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: !isLoading ? widget.toggleView : null,
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class NavRailView extends StatelessWidget {
  NavRailView({super.key});

  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  final List<NavigationDestination> destinations = const [
    NavigationDestination(
      icon: Icon(Icons.favorite_border),
      selectedIcon: Icon(Icons.favorite),
      label: 'Items',
    ),
    NavigationDestination(
      icon: Icon(Icons.bookmark_border),
      selectedIcon: Icon(Icons.book),
      label: 'Example',
    ),
    NavigationDestination(
      icon: Icon(Icons.star_border),
      selectedIcon: Icon(Icons.star),
      label: 'Example',
    ),
  ];

  final views = [
    ItemsView(),
    const ExampleView(
      index: 1,
    ),
    const ExampleView(
      index: 2,
    )
  ];

  @override
  Widget build(BuildContext context) {
    // TODO #5: Implement responsive navigation
    // - Add LayoutBuilder to switch between NavigationRail and NavigationBar
    // - Handle different layouts for <600px, >600px, >800px

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ItemsBloc(repository: ItemRepository())
              ..add(SubScribeToItems())),
        BlocProvider(create: (context) => SelectedItemCubit())
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: _selectedIndex,
                    builder: (context, index, _) {
                      return IndexedStack(
                        key: const GlobalObjectKey("indexedStack"),
                        index: index,
                        children: views,
                      );
                    }),
              ),
              ValueListenableBuilder(
                  valueListenable: _selectedIndex,
                  builder: (context, index, _) {
                    return NavigationBar(
                      selectedIndex: index,
                      onDestinationSelected: (index) {
                        _selectedIndex.value = index;
                      },
                      destinations: destinations,
                    );
                  })
            ],
          );
        }
        return Row(
          children: [
            ValueListenableBuilder(
                valueListenable: _selectedIndex,
                builder: (context, index, _) {
                  return NavigationRail(
                    extended: constraints.maxWidth >= 800,
                    selectedIndex: index,
                    onDestinationSelected: (index) {
                      _selectedIndex.value = index;
                    },
                    trailing: Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Material(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                constraints.maxWidth >= 800
                                    ? FilledButton.icon(
                                        label: const Text("Logout"),
                                        icon: const Icon(Icons.logout),
                                        onPressed: () =>
                                            context.read<AuthBloc>().logout(),
                                      )
                                    : FilledButton(
                                        child: const Icon(Icons.logout),
                                        onPressed: () =>
                                            context.read<AuthBloc>().logout(),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    destinations: destinations
                        .map((e) => NavigationRailDestination(
                              icon: e.icon,
                              selectedIcon: e.selectedIcon,
                              label: Text(e.label),
                            ))
                        .toList(),
                  );
                }),
            VerticalDivider(),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: _selectedIndex,
                  builder: (context, index, _) {
                    return IndexedStack(
                      key: const GlobalObjectKey("indexedStack"),
                      index: index,
                      children: views,
                    );
                  }),
            ),
          ],
        );
      }),
    );
  }
}
