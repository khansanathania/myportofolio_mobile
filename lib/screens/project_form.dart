import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _projectName = "";
  String _description = "";
  String _category = "Web Development";
  String _technologies = "";
  String _projectLink = "";
  String _projectImageUrl = "";

  bool _isSubmitting = false;

  final List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  // Validasi format URL.
  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  // Mengirim data proyek ke backend Django.
  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final loggedIn = await ensureLoggedIn(context);
      if (!mounted || !loggedIn) return;

      final token = context.read<AuthState>().token;
      if (token == null) return;

      final newProject = Project(
        title: _projectName.trim(),
        description: _description.trim(),
        techStack: _technologies.trim(),
        projectUrl: _projectLink.trim(),
        projectImageUrl: _projectImageUrl.trim(),
      );

      final createdProject = await context.read<ApiClient>().createProject(
        newProject,
        token: token,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Proyek berhasil ditambahkan!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama Proyek: ${createdProject.title}'),
                  Text('Deskripsi: ${createdProject.description}'),
                  Text('Kategori: $_category'),
                  Text('Teknologi: ${createdProject.techStack}'),
                  Text('Tautan: ${createdProject.projectUrl}'),
                  if (createdProject.projectImageUrl.isNotEmpty)
                    Text('URL Gambar: ${createdProject.projectImageUrl}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      _formKey.currentState!.reset();

      setState(() {
        _projectName = "";
        _description = "";
        _category = "Web Development";
        _technologies = "";
        _projectLink = "";
        _projectImageUrl = "";
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401) {
        await context.read<AuthState>().logout();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi berakhir. Silakan login kembali.'),
          ),
        );

        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan proyek: ${e.statusCode}')),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal terhubung ke server.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Proyek",
                    labelText: "Nama Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _projectName = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama proyek tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // Description
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Proyek",
                    labelText: "Deskripsi Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi proyek tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // Category
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // Technologies
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Flutter, Django, Figma",
                    labelText: "Teknologi yang Digunakan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _technologies = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Teknologi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // Project Link
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://example.com",
                    labelText: "Tautan Proyek",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _projectLink = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Tautan proyek tidak boleh kosong!";
                    }
                    if (!_isValidUrl(value)) {
                      return "Masukkan URL yang valid!";
                    }
                    return null;
                  },
                ),
              ),

              // Project Image URL
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://example.com/image.png",
                    labelText: "URL Gambar Proyek (Opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _projectImageUrl = value;
                    });
                  },
                  validator: (value) {
                    if (value != null &&
                        value.trim().isNotEmpty &&
                        !_isValidUrl(value)) {
                      return "Masukkan URL gambar yang valid!";
                    }
                    return null;
                  },
                ),
              ),

              // Tombol Simpan
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
