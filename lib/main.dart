import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App Oscura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB71C1C),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _ultimaFoto;

  Future<void> _tomarFoto() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (foto == null) return;

      final Directory dir = await getApplicationDocumentsDirectory();

      final String nuevoPath =
          '${dir.path}/foto_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final File nuevaFoto = await File(foto.path).copy(nuevoPath);

      setState(() {
        _ultimaFoto = nuevaFoto;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        title: const Text(
          'Pantalla Principal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Botón 1 toma una foto y la guarda.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              if (_ultimaFoto != null)
                Column(
                  children: [
                    const Text(
                      'Última foto tomada:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Image.file(
                      _ultimaFoto!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
              else
                const Text(
                  'Todavía no has tomado ninguna foto.',
                  style: TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _CustomButton(
                    label: 'Tomar foto',
                    icon: Icons.camera_alt,
                    onPressed: _tomarFoto,
                  ),
                  _CustomButton(
                    label: 'Botón 2',
                    icon: Icons.settings,
                    onPressed: () {},
                  ),
                  _CustomButton(
                    label: 'Botón 3',
                    icon: Icons.star,
                    onPressed: () {},
                  ),
                  _CustomButton(
                    label: 'Botón 4',
                    icon: Icons.info,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const _CustomButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 150,
      height: 48,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorScheme.primary),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevation: MaterialStateProperty.all(3),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        icon: Icon(
          icon,
          size: 20,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
