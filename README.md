# MyPortfolio Mobile



## 1. Identitas

| Informasi | Keterangan |
|---|---|
| Nama | Khansa Nathania K |
| NPM | 2506618061 |
| Kelas | PBP E |

## 2. Menu Aksi

Aplikasi MyPortfolio Mobile memiliki tiga tombol menu dengan ikon dan warna yang berbeda.

| Menu | Ikon | Warna |
|---|---|---|
| Lihat Proyek | `Icons.folder` | Biru |
| Tambah Proyek | `Icons.add_circle` | Hijau |
| Logout | `Icons.logout` | Merah |

Setiap tombol dapat ditekan dan akan menampilkan pesan melalui `SnackBar`, yaitu:

**"Kamu telah menekan tombol [Nama Tombol]!"**

Saat ini, ketiga tombol masih digunakan untuk menampilkan pesan interaktif dan belum terhubung ke halaman atau fitur lainnya.

## 3. Cara Menjalankan Aplikasi

Untuk menjalankan aplikasi, ikuti langkah-langkah berikut:

1. Pastikan Flutter SDK dan Google Chrome sudah terpasang.
2. Buka folder `myportofolio_mobile` menggunakan Visual Studio Code.
3. Buka terminal pada folder utama proyek.
4. Jalankan perintah berikut untuk menyiapkan dependensi:

   ```bash
   flutter pub get
   ```

5. Setelah selesai, jalankan aplikasi menggunakan:

   ```bash
   flutter run -d chrome
   ```

Aplikasi akan terbuka melalui Google Chrome. Untuk memeriksa apakah terdapat masalah pada kode, gunakan perintah:

```bash
flutter analyze
```

Jika tidak ada masalah yang terdeteksi, terminal akan menampilkan pesan `No issues found!`.

---

## 4. Pertanyaan Reflektif

### Tugas 7

**1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!**

*Widget tree* adalah struktur yang menunjukkan bagaimana widget disusun dalam aplikasi Flutter. Susunannya berbentuk hierarki, di mana sebuah widget bisa memiliki widget lain di dalamnya. Widget yang membungkus disebut *parent*, sedangkan widget yang berada di dalamnya disebut *child*. Hubungan ini membuat setiap bagian tampilan saling terhubung dan memiliki susunan yang jelas.

Pada aplikasi MyPortfolio Mobile, `MaterialApp` digunakan untuk menampilkan halaman utama `MyHomePage`. Di dalamnya terdapat `Scaffold` yang mengatur struktur halaman, seperti `AppBar` dan `body`. Selanjutnya, `Row`, `Column`, dan `GridView.count` digunakan untuk menyusun kartu identitas serta tombol menu. Dengan susunan seperti ini, tampilan aplikasi menjadi lebih mudah diatur dan dikembangkan.

**2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!**

Berikut adalah widget yang digunakan dalam aplikasi MyPortfolio Mobile beserta fungsinya:

| Widget | Fungsi |
|---|---|
| `MyApp` | Widget utama yang mengatur konfigurasi aplikasi. |
| `MaterialApp` | Mengatur tema, judul, dan halaman awal aplikasi. |
| `MyHomePage` | Menampilkan halaman utama aplikasi. |
| `Scaffold` | Menyediakan struktur dasar halaman aplikasi. |
| `AppBar` | Menampilkan judul di bagian atas halaman. |
| `Padding` | Memberikan jarak di sekitar widget. |
| `Column` | Menyusun widget dari atas ke bawah. |
| `Row` | Menyusun widget secara mendatar. |
| `Center` | Menempatkan widget di tengah area yang tersedia. |
| `Text` | Menampilkan tulisan pada aplikasi. |
| `SizedBox` | Memberikan jarak antarwidget. |
| `GridView.count` | Menyusun tombol menu menjadi tiga kolom. |
| `Card` | Menampilkan informasi dalam bentuk kartu. |
| `Container` | Mengatur ukuran dan jarak bagian dalam widget. |
| `InfoCard` | Menampilkan informasi NPM, nama, dan kelas. |
| `Material` | Menjadi dasar tampilan tombol yang memiliki warna tertentu. |
| `InkWell` | Membuat tombol dapat ditekan dan memberikan efek sentuhan. |
| `Icon` | Menampilkan ikon pada masing-masing tombol. |
| `ItemCard` | Menampilkan tombol menu yang dapat berinteraksi dengan pengguna. |
| `SnackBar` | Menampilkan pesan singkat ketika tombol ditekan. |

Selain widget tersebut, aplikasi menggunakan `StatelessWidget` untuk membuat komponen yang tidak perlu mengelola perubahan state lokal.

Terdapat juga kelas `ItemHomepage` yang digunakan untuk menyimpan nama, ikon, dan warna setiap tombol. Namun, `ItemHomepage` bukan widget, melainkan kelas model data.

**3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!**

`MaterialApp` merupakan widget yang digunakan untuk mengatur konfigurasi utama aplikasi Flutter, seperti judul, tema warna, halaman awal, dan navigasi. Widget ini juga menyediakan berbagai fitur yang mendukung tampilan aplikasi berbasis Material Design.

`MaterialApp` biasanya digunakan sebagai *root widget* karena menjadi dasar konfigurasi bagi widget lain di dalam aplikasi. Dengan begitu, kita tidak perlu mengatur tema atau konfigurasi yang sama secara berulang pada setiap halaman.

Pada MyPortfolio Mobile, `MaterialApp` digunakan di dalam `MyApp` untuk mengatur judul aplikasi menjadi `MyPortfolio`, menentukan tema warna indigo dan amber, serta menampilkan `MyHomePage` sebagai halaman pertama melalui properti `home`.

**4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?**

`StatelessWidget` adalah widget yang tidak memiliki objek `State` untuk menyimpan dan mengelola data yang berubah secara lokal. Widget ini cocok digunakan untuk tampilan yang tidak membutuhkan pengelolaan state internal, seperti teks, informasi profil, atau kartu menu. Meskipun begitu, `StatelessWidget` masih bisa dibangun ulang ketika data atau konfigurasi yang diterimanya berubah.

Sementara itu, `StatefulWidget` memiliki objek `State` yang dapat menyimpan data selama aplikasi berjalan. Jika data tersebut berubah, kita bisa menggunakan `setState()` agar Flutter memperbarui tampilan sesuai kondisi terbaru.

Jadi, `StatelessWidget` sebaiknya dipilih ketika suatu komponen tidak perlu mengelola perubahan state sendiri. Sebaliknya, `StatefulWidget` lebih cocok untuk komponen yang perlu menyimpan dan memperbarui data, misalnya penghitung angka, checkbox, atau formulir interaktif.

Pada MyPortfolio Mobile, `MyHomePage`, `InfoCard`, dan `ItemCard` menggunakan `StatelessWidget` karena tidak perlu menyimpan state lokal. Tombol yang tersedia hanya menampilkan pesan melalui `SnackBar` ketika ditekan.

**5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?**

`BuildContext` adalah objek yang menunjukkan posisi suatu widget di dalam *widget tree*. Melalui `BuildContext`, sebuah widget dapat mengakses informasi atau layanan dari widget lain yang berada di atasnya dalam struktur aplikasi.

`BuildContext` penting karena beberapa hal, seperti tema aplikasi, ukuran layar, dan penampilan notifikasi, perlu mengambil informasi dari lingkungan tempat widget digunakan.

Pada Flutter, `BuildContext` biasanya digunakan melalui parameter `context` dalam method `build(BuildContext context)`. Contoh penggunaannya pada MyPortfolio Mobile adalah:

- `Theme.of(context).colorScheme.primary` digunakan untuk mengambil warna utama dari tema aplikasi.
- `MediaQuery.of(context).size.width` digunakan untuk mengetahui lebar layar agar ukuran kartu informasi bisa disesuaikan.
- `ScaffoldMessenger.of(context)` digunakan untuk menampilkan `SnackBar` ketika pengguna menekan tombol.

Dengan adanya `BuildContext`, kita bisa mengambil informasi yang dibutuhkan langsung dari lingkungan widget tanpa harus mengaturnya secara manual di setiap bagian kode.

**6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?**

*Hot reload* adalah fitur Flutter yang memungkinkan kita melihat perubahan kode pada aplikasi yang sedang berjalan tanpa perlu menjalankannya kembali dari awal. Fitur ini biasanya digunakan ketika mengubah tampilan, seperti warna, teks, atau posisi widget. Keuntungan hot reload adalah state aplikasi yang sedang berjalan tetap dipertahankan.

Berbeda dengan hot reload, *hot restart* akan menjalankan ulang aplikasi dari fungsi `main()` dan mengembalikan state aplikasi ke kondisi awal. Hot restart biasanya digunakan ketika perubahan kode tidak bisa diterapkan dengan baik melalui hot reload, misalnya saat mengubah proses inisialisasi aplikasi.

Sementara itu, *full restart* dilakukan dengan menghentikan aplikasi, lalu menjalankannya kembali dari awal. Cara ini dibutuhkan ketika ada perubahan yang memerlukan proses build ulang, seperti mengubah kode native Android atau iOS, konfigurasi platform, maupun menambahkan plugin tertentu.

Dalam pengembangan MyPortfolio Mobile, hot reload dapat digunakan untuk melihat perubahan warna tombol atau tulisan secara langsung. Jika perubahan berkaitan dengan inisialisasi aplikasi, hot restart bisa digunakan. Namun, jika perubahan membutuhkan kompilasi ulang, kita perlu melakukan full restart.

## 5. Deklarasi Penggunaan AI

Saya tidak menggunakan AI dalam pengerjaan Tugas Individu 7. Pengerjaan dilakukan secara mandiri berdasarkan instruksi dari Tugas Individu 7 yang sudah memberikan clue pengerjaan dengan sangat jelas.