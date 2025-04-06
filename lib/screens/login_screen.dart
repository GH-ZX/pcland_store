import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/services/app_localizations.dart';
import 'package:pcland_store/providers/user_provider.dart';
import 'package:pcland_store/screens/register_screen.dart';
import 'package:pcland_store/providers/language_provider.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isGoogleLoading = false;
  bool obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // للاختبار فقط
    emailController.text = 'ahmad@example.com';
    passwordController.text = '123';

    // إعداد الرسوم المتحركة
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (isLoading) return;
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final success = await userProvider.login(
        emailController.text,
        passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userProvider.error ??
                  AppLocalizations.of(context).translate('login_failed'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loginWithGoogle() async {
    if (isGoogleLoading) return;
    setState(() => isGoogleLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      print('Starting Google sign-in process');
      final success = await userProvider.loginWithGoogle();
      print('Google sign-in result: $success');

      if (mounted) {
        if (success) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home', (route) => false);
        } else {
          print('Google sign-in failed: ${userProvider.error}');
          // Only show error if there's a specific error message
          if (userProvider.error != null && userProvider.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(userProvider.error!),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        }
      }
    } catch (error) {
      print('Google sign-in exception: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate('google_login_failed'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isGoogleLoading = false;
        });
      }
    }
  }

  void toggleLanguage() {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    languageProvider.toggleLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDarkMode
                        ? [
                          theme.colorScheme.background,
                          theme.colorScheme.surface,
                          theme.colorScheme.background.withOpacity(0.8),
                        ]
                        : [
                          primaryColor.withOpacity(0.05),
                          theme.colorScheme.background,
                          primaryColor.withOpacity(0.1),
                        ],
              ),
            ),
          ),

          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(120),
              ),
            ),
          ),

          // زر تغيير اللغة
          Positioned(
            top: 40,
            right: 16,
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.language_rounded, color: primaryColor),
                        onPressed: toggleLanguage,
                        tooltip: localizations.translate('change_language'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: size.width * 0.85),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // مكان لإضافة الصورة - Image Placeholder
                          Container(
                            width: 160,
                            height: 160,
                            margin: const EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  blurRadius: 25,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color:
                                        isDarkMode
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/icon.png',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // بطاقة تسجيل الدخول
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.1),
                                  blurRadius: 25,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(28),
                                  decoration: BoxDecoration(
                                    color:
                                        isDarkMode
                                            ? Colors.black.withOpacity(0.5)
                                            : Colors.white.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color:
                                          isDarkMode
                                              ? Colors.white.withOpacity(0.1)
                                              : Colors.black.withOpacity(0.05),
                                      width: 1,
                                    ),
                                  ),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // عنوان
                                        Text(
                                          'PCLand Store',
                                          style: theme.textTheme.headlineMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                                letterSpacing: 0.5,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          localizations.translate('login'),
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                                letterSpacing: 0.5,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 40),

                                        // حقل البريد الإلكتروني
                                        _buildTextField(
                                          controller: emailController,
                                          label: localizations.translate(
                                            'email',
                                          ),
                                          hint: 'example@email.com',
                                          icon: Icons.email_outlined,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return localizations.translate(
                                                'required_field',
                                              );
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),

                                        // حقل كلمة المرور
                                        _buildTextField(
                                          controller: passwordController,
                                          label: localizations.translate(
                                            'password',
                                          ),
                                          icon: Icons.lock_outlined,
                                          isPassword: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return localizations.translate(
                                                'required_field',
                                              );
                                            }
                                            return null;
                                          },
                                        ),

                                        // نسيت كلمة المرور
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              // Navigate to forgot password screen
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: primaryColor,
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              localizations.translate(
                                                'forgot_password',
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),

                                        // زر تسجيل الدخول
                                        _buildGradientButton(
                                          text: localizations.translate(
                                            'login',
                                          ),
                                          isLoading: isLoading,
                                          onPressed: login,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // OR Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.2),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isDarkMode
                                            ? Colors.white.withOpacity(0.08)
                                            : Colors.black.withOpacity(0.03),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    localizations.translate('or'),
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.2),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Google Login Button
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap:
                                        isGoogleLoading
                                            ? null
                                            : loginWithGoogle,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isDarkMode
                                                ? Colors.white.withOpacity(0.08)
                                                : Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color:
                                              isDarkMode
                                                  ? Colors.white.withOpacity(
                                                    0.1,
                                                  )
                                                  : Colors.black.withOpacity(
                                                    0.05,
                                                  ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          isGoogleLoading
                                              ? SizedBox(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color:
                                                          theme
                                                              .colorScheme
                                                              .primary,
                                                    ),
                                              )
                                              : Container(
                                                height: 28,
                                                width: 28,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 3,
                                                      offset: const Offset(
                                                        0,
                                                        1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "G",
                                                    style: TextStyle(
                                                      color:
                                                          isDarkMode
                                                              ? Colors.black
                                                              : Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          const SizedBox(width: 12),
                                          Text(
                                            localizations.translate(
                                              'sign_in_with_google',
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Register Link
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isDarkMode
                                      ? Colors.white.withOpacity(0.08)
                                      : Colors.black.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: primaryColor,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    localizations.translate('register'),
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة لبناء حقول النص المخصصة
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool isPassword = false,
    required String? Function(String?) validator,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDarkMode = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryColor, size: 22),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: primaryColor.withOpacity(0.7),
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
                : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color:
                isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        filled: true,
        fillColor:
            isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.02),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      keyboardType:
          isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
      obscureText: isPassword && obscurePassword,
      validator: validator,
      style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            primaryColor,
            Color.lerp(primaryColor, Colors.black, 0.3) ??
                primaryColor.withBlue(20),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.transparent,
          child: Container(
            height: 58,
            alignment: Alignment.center,
            child:
                isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
