import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const LagonaApp());
}

// ─── App Colors ───────────────────────────────────────────────────────────────
class AppColors {
  static const Color primary = Color(0xFFFBBE61);
  static const Color primaryDark = Color(0xFFE8A84D);
  static const Color primaryLight = Color(0xFFFFD280);
  static const Color secondary = Color(0xFF191B1E);
  static const Color secondaryDark = Color(0xFF0F1114);
  static const Color secondaryLight = Color(0xFF2D2F33);
  static const Color accent = primary;
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF191B1E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = border;
  static const Color buttonPrimary = primary;
  static const Color buttonDisabled = Color(0xFFD1D5DB);
  static const Color cardBackground = surface;
  static const Color cardShadow = Color(0x1A000000);
  static const Color inputBorder = border;
  static const Color inputBorderFocused = primary;
  static const Color inputBackground = surface;
  static const Color navSelected = primary;
  static const Color navUnselected = textSecondary;
}

// ─── App ──────────────────────────────────────────────────────────────────────
class LagonaApp extends StatelessWidget {
  const LagonaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lagona Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        fontFamily: 'Georgia',
      ),
      home: const LandingPage(),
    );
  }
}

// ─── Landing Page ─────────────────────────────────────────────────────────────
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _orbController;

  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;
  late Animation<double> _pulse;
  late Animation<double> _orbRotate;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _fadeIn = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideUp = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    );

    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _orbRotate = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.linear),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isNarrow = size.width < 680;

    return Scaffold(
      backgroundColor: AppColors.secondaryDark,
      body: Stack(
        children: [
          // ── Animated background orbs ──────────────────────────────────────
          AnimatedBuilder(
            animation: _orbRotate,
            builder: (_, __) {
              return CustomPaint(
                size: size,
                painter: _OrbPainter(angle: _orbRotate.value),
              );
            },
          ),

          // ── Subtle grid overlay ───────────────────────────────────────────
          CustomPaint(
            size: size,
            painter: _GridPainter(),
          ),

          // ── Main content ──────────────────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 24 : 48,
                  vertical: 60,
                ),
                child: AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeIn.value,
                      child: Transform.translate(
                        offset: Offset(0, 40 * (1 - _slideUp.value)),
                        child: child,
                      ),
                    );
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ── Logo mark ───────────────────────────────────────
                        AnimatedBuilder(
                          animation: _pulse,
                          builder: (_, __) => Transform.scale(
                            scale: _pulse.value,
                            child: _LogoMark(),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ── Verified badge ──────────────────────────────────
                        _VerifiedBadge(),

                        const SizedBox(height: 28),

                        // ── Headline ────────────────────────────────────────
                        Text(
                          'Welcome to Lagona',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isNarrow ? 36 : 52,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textWhite,
                            letterSpacing: -1.2,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ── Platform label ──────────────────────────────────
                        Text(
                          'PLATFORM',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: 6,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── Divider ─────────────────────────────────────────
                        _GoldDivider(),

                        const SizedBox(height: 36),

                        // ── Body message ────────────────────────────────────
                        Text(
                          'Your email address has been successfully verified.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isNarrow ? 16 : 18,
                            color: AppColors.textWhite.withOpacity(0.85),
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'You may now proceed to the designated application linked to your account. If you haven\'t received access instructions, please check your inbox for a follow-up email from our team.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isNarrow ? 14 : 15,
                            color: AppColors.textWhite.withOpacity(0.5),
                            height: 1.75,
                          ),
                        ),

                        const SizedBox(height: 52),

                        // ── Info card ────────────────────────────────────────
                        _InfoCard(isNarrow: isNarrow),

                        const SizedBox(height: 52),

                        // ── Footer ───────────────────────────────────────────
                        _Footer(),
                      ],
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
}

// ─── Logo Mark ────────────────────────────────────────────────────────────────
class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [AppColors.primaryLight, AppColors.primaryDark],
          center: Alignment(-0.3, -0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.45),
            blurRadius: 32,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'L',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryDark,
            height: 1,
          ),
        ),
      ),
    );
  }
}

// ─── Verified Badge ───────────────────────────────────────────────────────────
class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: AppColors.success.withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 15,
            color: AppColors.success,
          ),
          const SizedBox(width: 7),
          Text(
            'Email Verified',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gold Divider ─────────────────────────────────────────────────────────────
class _GoldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, AppColors.primary.withOpacity(0.5)],
            ),
          ),
        ),
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
        ),
        Container(
          width: 48,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final bool isNarrow;
  const _InfoCard({required this.isNarrow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isNarrow ? 20 : 28),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'What\'s next?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.devices_rounded,
            text: 'Open the application assigned to your account role.',
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.login_rounded,
            text: 'Sign in using the credentials you registered with.',
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.support_agent_rounded,
            text:
            'Need help? Reach out to your Lagona account administrator.',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 13, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textWhite.withOpacity(0.6),
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '© ${DateTime.now().year} Lagona Platform. All rights reserved.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: AppColors.textWhite.withOpacity(0.25),
        letterSpacing: 0.3,
      ),
    );
  }
}

// ─── Background Orb Painter ───────────────────────────────────────────────────
class _OrbPainter extends CustomPainter {
  final double angle;
  _OrbPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    void drawOrb(double offsetAngle, Color color, double opacity, double radius) {
      final dx = cx + math.cos(angle + offsetAngle) * r * 0.6;
      final dy = cy + math.sin(angle + offsetAngle) * r * 0.35;
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color.withOpacity(opacity), Colors.transparent],
        ).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: radius));
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }

    drawOrb(0, AppColors.primary, 0.18, size.width * 0.42);
    drawOrb(math.pi, AppColors.primaryDark, 0.12, size.width * 0.35);
    drawOrb(math.pi / 2, AppColors.secondaryLight, 0.25, size.width * 0.30);
  }

  @override
  bool shouldRepaint(_OrbPainter oldDelegate) => oldDelegate.angle != angle;
}

// ─── Grid Painter ─────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textWhite.withOpacity(0.025)
      ..strokeWidth = 1;

    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}