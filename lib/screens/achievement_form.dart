import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

// Halaman formulir untuk menambahkan Achievement (prestasi) baru.
// Memakai StatefulWidget karena isian formulir (teks, dropdown, tanggal)
// berubah-ubah selama pengguna mengisi.
class AchievementFormPage extends StatefulWidget {
  const AchievementFormPage({super.key});

  @override
  State<AchievementFormPage> createState() => _AchievementFormPageState();
}

class _AchievementFormPageState extends State<AchievementFormPage> {
  // Kunci untuk mengakses state Form: dipakai untuk validate() dan reset().
  final _formKey = GlobalKey<FormState>();

  // Controller untuk menampilkan tanggal yang dipilih di dalam kolom teks.
  final _dateController = TextEditingController();

  // Variabel penyimpan isian dari tiap field formulir.
  String _title = "";
  String _organizer = "";
  String _level = "Sekolah"; // nilai awal dropdown
  DateTime? _achievedDate; // null artinya tanggal belum dipilih
  String _proofLink = "";

  // Pilihan untuk dropdown tingkat prestasi.
  final List<String> _levels = [
    'Sekolah',
    'Kota',
    'Provinsi',
    'Nasional',
    'Internasional',
  ];

  // Mengubah DateTime menjadi teks dd-mm-yyyy untuk ditampilkan.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day-$month-${date.year}";
  }

  // Menampilkan date picker lalu menyimpan tanggal yang dipilih pengguna.
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _achievedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // prestasi tidak boleh di masa depan
    );
    if (picked != null) {
      setState(() {
        _achievedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  // Memeriksa apakah teks adalah URL http/https yang valid.
  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  // Melepaskan controller saat halaman ditutup agar tidak boros memori.
  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan warna indigo agar konsisten dengan halaman lain.
      appBar: AppBar(
        title: const Center(child: Text('Add Achievement Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // Drawer yang sama dengan halaman utama, supaya navigasi tetap konsisten.
      drawer: const LeftDrawer(),
      // Form menjadi wadah semua input. SingleChildScrollView membuat
      // isinya bisa di-scroll saat layar sempit atau papan ketik tampil.
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Judul Prestasi ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Juara 1 Lomba Web Design",
                    labelText: "Judul Prestasi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  // Simpan isian ke variabel setiap kali teks berubah.
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  // Tolak isian kosong, hanya spasi, atau lebih dari 100 karakter.
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Judul prestasi tidak boleh kosong!";
                    }
                    if (value.trim().length > 100) {
                      return "Judul prestasi maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Penyelenggara ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Fasilkom UI",
                    labelText: "Penyelenggara",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _organizer = value!;
                    });
                  },
                  // Penyelenggara wajib diisi (tidak boleh kosong atau hanya spasi).
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Penyelenggara tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tingkat Prestasi (dropdown) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Tingkat",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _level,
                  items: _levels
                      .map(
                        (level) =>
                            DropdownMenuItem(value: level, child: Text(level)),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _level = newValue!;
                    });
                  },
                ),
              ),

              // === Tanggal Diraih (date picker) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _dateController,
                  // readOnly: pengguna memilih lewat date picker, bukan mengetik.
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: InputDecoration(
                    hintText: "Pilih tanggal",
                    labelText: "Tanggal Diraih",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  // Tanggal wajib dipilih dan tidak boleh di masa depan.
                  validator: (String? value) {
                    if (_achievedDate == null) {
                      return "Tanggal diraih harus dipilih!";
                    }
                    if (_achievedDate!.isAfter(DateTime.now())) {
                      return "Tanggal tidak boleh di masa depan!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tautan Bukti (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://contoh.com/sertifikat (opsional)",
                    labelText: "Tautan Bukti",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _proofLink = value!;
                    });
                  },
                  // Boleh kosong, tetapi jika diisi harus berupa URL http/https.
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    if (!_isValidUrl(value.trim())) {
                      return "Tautan harus berupa URL http:// atau https://";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      // Dialog hanya muncul jika semua input lolos validasi.
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Achievement berhasil ditambahkan!',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Judul: ${_title.trim()}'),
                                    Text('Penyelenggara: ${_organizer.trim()}'),
                                    Text('Tingkat: $_level'),
                                    Text(
                                      'Tanggal: ${_formatDate(_achievedDate!)}',
                                    ),
                                    Text(
                                      'Tautan Bukti: ${_proofLink.trim().isEmpty ? "-" : _proofLink.trim()}',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    // Tutup dialog, lalu kosongkan formulir.
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _title = "";
                                      _organizer = "";
                                      _level = "Sekolah";
                                      _achievedDate = null;
                                      _proofLink = "";
                                      _dateController.clear();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
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
