# UTS Manajemen Basis Data
### Dockerized PostgreSQL Environment, Database Administration, and Role-Based Access Control

Repository ini merupakan dokumentasi implementasi tugas Ujian Tengah Semester (UTS) mata kuliah **Manajemen Basis Data**. Project berfokus pada penerapan database PostgreSQL menggunakan Docker Compose, pengelolaan database melalui pgAdmin dan DBeaver, serta konfigurasi hak akses pengguna berdasarkan kebutuhan dan tanggung jawab masing-masing role.

Project ini dirancang agar konfigurasi database lebih terstruktur, mudah dijalankan kembali, dan dapat diperiksa melalui perangkat administrasi database.

---

## 1. Identitas Project

| Informasi | Keterangan |
|---|---|
| Nama Mahasiswa | Syamil Dhiyaul Haq |
| NIM | 1247050112 |
| Mata Kuliah | Manajemen Basis Data |
| Jenis Tugas | Ujian Tengah Semester (UTS) |
| Database Management System | PostgreSQL |
| Container Orchestration | Docker Compose |
| Database Administration Tools | pgAdmin 4 dan DBeaver |

## 2. Latar Belakang

Pengelolaan database tidak hanya mencakup pembuatan tabel dan penyimpanan data, tetapi juga konfigurasi lingkungan, pengaturan koneksi, integritas data, serta pembatasan hak akses pengguna.

Pada project ini, PostgreSQL dijalankan menggunakan Docker Compose agar lingkungan database dapat dikelola melalui konfigurasi yang terstruktur. pgAdmin digunakan sebagai antarmuka administrasi berbasis web, sedangkan DBeaver digunakan untuk menjalankan query SQL, memeriksa struktur database, dan menguji hak akses role.

Selain itu, project menerapkan pembagian hak akses berdasarkan peran pengguna. Pendekatan ini membantu membedakan kebutuhan akses aplikasi, analisis data, dan pengelolaan data sehingga setiap role memperoleh izin sesuai tanggung jawabnya.

## 3. Tujuan Project

Tujuan implementasi ini meliputi:

1. Menjalankan PostgreSQL dalam container Docker.
2. Mengelola layanan database menggunakan Docker Compose.
3. Menghubungkan PostgreSQL dengan pgAdmin dan DBeaver.
4. Membuat schema `SALAM` dan tabel `mahasiswas`.
5. Menerapkan constraint untuk membantu menjaga integritas data.
6. Mengonfigurasi tiga role database dengan hak akses berbeda.
7. Memeriksa konektivitas database dan menguji hak akses setiap role.
8. Mendokumentasikan konfigurasi project melalui repository GitHub.

## 4. Teknologi yang Digunakan

| Teknologi | Fungsi |
|---|---|
| Docker | Menjalankan layanan dalam container terisolasi. |
| Docker Compose | Mendefinisikan dan mengelola layanan berdasarkan file konfigurasi. |
| PostgreSQL 15 | Sistem manajemen basis data relasional yang digunakan dalam project. |
| pgAdmin 4 | Antarmuka berbasis web untuk administrasi PostgreSQL. |
| DBeaver | Aplikasi database client untuk menjalankan SQL dan memeriksa hasil query. |
| SQL | Bahasa untuk mendefinisikan struktur database, mengatur izin, dan menguji data. |
| Git dan GitHub | Mengelola versi kode dan menyimpan dokumentasi project secara daring. |

## 5. Arsitektur Sistem

Secara umum, project menggunakan dua layanan utama: PostgreSQL sebagai server database dan pgAdmin sebagai antarmuka administrasi.

```text
                 LOCAL COMPUTER
                       |
              +--------+--------+
              |                 |
           DBeaver            Browser
              |                 |
       localhost:22112    localhost:44112
              |                 |
              |          +------v-------+
              |          |   pgAdmin 4  |
              |          | Docker       |
              |          +------+-------+
              |                 |
              +-----------------+
                                |
                       Docker Network
                                |
                       +--------v--------+
                       |   PostgreSQL    |
                       |   Version 15    |
                       | Container:      |
                       | postgres_Syamil |
                       +--------+--------+
                                |
                      Database: postgres
                                |
                       Schema: SALAM
                                |
                      Table: mahasiswas
```

**Penjelasan arsitektur:**

- **DBeaver:** terhubung ke PostgreSQL melalui port host `22112`.
- **pgAdmin 4:** diakses melalui browser menggunakan port host `44112`.
- **PostgreSQL:** berjalan dalam container bernama `postgres_Syamil` dan menggunakan port internal `5432`.
- **Docker Network:** memungkinkan pgAdmin berkomunikasi dengan PostgreSQL menggunakan nama service atau container yang sesuai dengan konfigurasi Compose.
- **Database:** menggunakan database `postgres`, dengan schema `SALAM` dan tabel `mahasiswas`.

Port host digunakan untuk akses dari komputer lokal, sedangkan port internal digunakan oleh layanan yang berkomunikasi di dalam jaringan Docker.

## 6. Struktur Repository

```text
UTS_Manajemen_Basis_Data/
├── docker-compose.yml
├── .gitignore
├── README.md
└── sql/
    └── 01_setup.sql
```

File `.env` juga digunakan secara lokal untuk menyimpan konfigurasi lingkungan, tetapi tidak disertakan dalam repository.

### Fungsi setiap file

| File atau Folder | Keterangan |
|---|---|
| `docker-compose.yml` | Mendefinisikan konfigurasi layanan PostgreSQL dan pgAdmin, termasuk port serta variabel lingkungan yang diperlukan. |
| `.gitignore` | Mengatur file yang tidak perlu dilacak oleh Git, termasuk file `.env` yang berisi konfigurasi sensitif. |
| `README.md` | Menjelaskan tujuan, arsitektur, konfigurasi, pengujian, dan penggunaan project. |
| `sql/01_setup.sql` | Berisi script SQL untuk menyiapkan role database, schema, tabel, constraint, dan hak akses sesuai implementasi project. |
| `.env` | Konfigurasi lokal yang digunakan Docker Compose dan tidak boleh diunggah jika mengandung password asli. |

## 7. Konfigurasi Docker Compose

File `docker-compose.yml` digunakan untuk mendefinisikan layanan database dan administrasi database.

### Layanan PostgreSQL

PostgreSQL berjalan dalam container `postgres_Syamil` dengan port internal `5432`. Port host yang digunakan untuk mengakses database dari komputer lokal adalah `22112`.

Informasi koneksi dari komputer lokal:

| Parameter | Nilai |
|---|---|
| Host | `localhost` atau `127.0.0.1`, sesuai konfigurasi koneksi |
| Port | `22112` |
| Database | `postgres` |
| Username administrasi | `postgres` |

Jika koneksi melalui DBeaver menggunakan konfigurasi IPv6 yang telah berhasil diuji, host `::1` juga dapat digunakan pada lingkungan tersebut.

### Layanan pgAdmin

pgAdmin digunakan untuk mengelola database melalui browser.

| Parameter | Nilai |
|---|---|
| URL akses lokal | `http://localhost:44112` |
| Port internal container | `80` |
| Port host | `44112` |

Untuk koneksi dari pgAdmin ke PostgreSQL di dalam jaringan Docker, gunakan host `postgres_Syamil`, port `5432`, database `postgres`, dan kredensial PostgreSQL yang sesuai.

**Catatan keamanan:** password PostgreSQL dan pgAdmin merupakan dua kredensial berbeda. Nilai aslinya disimpan dalam konfigurasi lokal, bukan di dokumentasi publik.

## 8. Implementasi Database

### 8.1 Database dan Schema

Project menggunakan database `postgres` dengan schema khusus bernama `SALAM`.

Schema membantu mengelompokkan objek database secara logis sehingga struktur tabel lebih terorganisasi.

### 8.2 Tabel `mahasiswas`

Tabel `mahasiswas` berada di dalam schema `SALAM` dan digunakan sebagai objek utama untuk pengujian struktur database serta hak akses.

Nama objek yang digunakan dalam query SQL:

```sql
"SALAM".mahasiswas
```

Penulisan schema menggunakan tanda kutip ganda untuk mempertahankan kapitalisasi `SALAM` yang digunakan dalam implementasi.

### 8.3 Constraint dan Integritas Data

Script SQL project mencakup tiga jenis constraint utama:

| Constraint | Tujuan |
|---|---|
| `PRIMARY KEY` | Mengidentifikasi setiap baris secara unik. |
| `UNIQUE` | Mencegah duplikasi nilai pada kolom yang ditetapkan unik. |
| `CHECK` | Membatasi nilai agar memenuhi kondisi yang ditentukan. |

Constraint membantu menjaga konsistensi data pada tingkat database. Penerapannya perlu diperiksa pada definisi tabel dan script SQL yang digunakan.

### 8.4 Script Setup

Seluruh konfigurasi SQL utama didokumentasikan pada:

`sql/01_setup.sql`

Script tersebut digunakan untuk menyiapkan role, schema, tabel, constraint, serta pemberian hak akses sesuai implementasi project.

Sebelum menjalankan ulang script setup, periksa perintah yang ada di dalamnya dan pastikan dampaknya terhadap objek database yang telah dibuat.

## 9. Role-Based Access Control

Project menerapkan tiga role database dengan pembagian hak akses yang berbeda. Tujuannya adalah menyesuaikan izin database dengan kebutuhan masing-masing peran.

### 9.1 `backend_dev`

Role ini ditujukan untuk kebutuhan pengembangan aplikasi yang memerlukan operasi baca dan manipulasi data.

Hak akses yang dikonfigurasi:

- `SELECT`
- `INSERT`
- `UPDATE`
- `DELETE`

### 9.2 `bi_dev`

Role ini ditujukan untuk kebutuhan pembacaan data dan analisis.

Hak akses yang dikonfigurasi:

- `SELECT`

Role ini tidak diberikan izin `INSERT`, `UPDATE`, atau `DELETE` pada tabel yang diuji.

### 9.3 `data_engineer`

Role ini memperoleh izin untuk membaca dan memanipulasi data, serta hak tertentu yang berkaitan dengan integritas dan pengelolaan objek tabel.

Hak akses yang dikonfigurasi:

- `SELECT`
- `INSERT`
- `UPDATE`
- `DELETE`
- `REFERENCES`
- `TRIGGER`

### 9.4 Ringkasan Hak Akses

| Hak Akses | `backend_dev` | `bi_dev` | `data_engineer` |
|---|:---:|:---:|:---:|
| SELECT | ✓ | ✓ | ✓ |
| INSERT | ✓ | — | ✓ |
| UPDATE | ✓ | — | ✓ |
| DELETE | ✓ | — | ✓ |
| REFERENCES | Tidak termasuk konfigurasi yang direncanakan | Tidak termasuk konfigurasi yang direncanakan | ✓ |
| TRIGGER | Tidak termasuk konfigurasi yang direncanakan | Tidak termasuk konfigurasi yang direncanakan | ✓ |

Tanda centang menunjukkan izin yang dikonfigurasi dalam script setup. Tanda pisah menunjukkan izin tersebut tidak termasuk dalam konfigurasi yang direncanakan untuk role terkait.

Pemberian izin pada tabel tidak otomatis berarti suatu role dapat menjalankan seluruh operasi administrasi database. Izin schema, kepemilikan objek, dan izin lain tetap mengikuti konfigurasi PostgreSQL yang berlaku.

## 10. Prosedur Instalasi dan Menjalankan Project

### Prasyarat

Sebelum menjalankan project, pastikan perangkat telah memiliki:

- Docker Desktop yang sudah terpasang dan berjalan.
- Git untuk mengelola repository.
- DBeaver atau pgAdmin untuk mengakses PostgreSQL.
- File project beserta konfigurasi lingkungan yang diperlukan.

### Langkah 1 — Siapkan konfigurasi lingkungan

Siapkan file `.env` lokal sesuai variabel yang dirujuk oleh `docker-compose.yml`.

Gunakan nilai konfigurasi yang sesuai dengan project. Jangan mengandalkan contoh password dari dokumentasi sebagai kredensial produksi.

### Langkah 2 — Jalankan layanan

Buka terminal di folder project, kemudian jalankan:

```bash
docker compose up -d
```

Perintah tersebut menjalankan layanan di latar belakang.

### Langkah 3 — Periksa status container

```bash
docker compose ps
```

Pastikan layanan yang dibutuhkan berada dalam kondisi berjalan dan periksa status health check jika dikonfigurasi.

### Langkah 4 — Periksa log bila diperlukan

```bash
docker compose logs --tail=50
```

Perintah ini menampilkan log terbaru untuk membantu memeriksa startup atau menemukan error.

### Langkah 5 — Hubungkan DBeaver

Buat atau gunakan koneksi PostgreSQL dengan parameter koneksi yang sesuai pada bagian konfigurasi Docker Compose.

Gunakan akun `postgres` untuk administrasi awal, atau akun role yang sesuai untuk pengujian hak akses.

### Langkah 6 — Hubungkan pgAdmin

Buka:

`http://localhost:44112`

Login menggunakan kredensial web pgAdmin yang telah dikonfigurasi. Daftarkan koneksi server PostgreSQL menggunakan hostname internal Docker, port `5432`, database `postgres`, serta kredensial PostgreSQL yang sesuai.

### Langkah 7 — Periksa objek database

Pada DBeaver atau pgAdmin, periksa keberadaan schema `SALAM` dan tabel `mahasiswas`.

Script setup yang disediakan berada pada `sql/01_setup.sql`.

## 11. Pengujian dan Validasi

Pengujian dilakukan untuk memastikan layanan database dapat diakses dan pembagian hak akses berjalan sesuai konfigurasi.

### 11.1 Pengujian layanan

Pemeriksaan dilakukan melalui status container dan koneksi database.

Hasil pengerjaan yang telah dilaporkan:

- PostgreSQL berhasil dijalankan menggunakan Docker.
- DBeaver berhasil terhubung ke PostgreSQL.
- pgAdmin berhasil terhubung ke server PostgreSQL.
- Tabel `SALAM.mahasiswas` dapat diakses melalui pgAdmin.

### 11.2 Pengujian role

Setiap role diuji melalui koneksi tersendiri menggunakan DBeaver.

Pemeriksaan hak akses menggunakan fungsi PostgreSQL `has_table_privilege`, sehingga izin pada tabel dapat diperiksa tanpa melakukan perubahan data.

Contoh pemeriksaan:

```sql
SELECT
    has_table_privilege(
        current_user,
        '"SALAM".mahasiswas',
        'SELECT'
    ) AS boleh_select,
    has_table_privilege(
        current_user,
        '"SALAM".mahasiswas',
        'INSERT'
    ) AS boleh_insert,
    has_table_privilege(
        current_user,
        '"SALAM".mahasiswas',
        'UPDATE'
    ) AS boleh_update,
    has_table_privilege(
        current_user,
        '"SALAM".mahasiswas',
        'DELETE'
    ) AS boleh_delete;
```

Jalankan pemeriksaan menggunakan masing-masing koneksi role agar `current_user` menunjukkan akun yang benar-benar sedang digunakan.

Untuk `data_engineer`, pemeriksaan juga mencakup izin `REFERENCES` dan `TRIGGER`.

### 11.3 Pengujian integritas data

Definisi constraint dapat diperiksa melalui metadata PostgreSQL menggunakan query berikut:

```sql
SELECT
    conname AS nama_constraint,
    contype AS tipe_constraint
FROM pg_constraint
WHERE conrelid = '"SALAM".mahasiswas'::regclass;
```

Arti nilai `contype`:

| Kode | Jenis |
|---|---|
| `p` | Primary Key |
| `u` | Unique |
| `c` | Check |

Query ini bersifat pemeriksaan dan tidak mengubah isi tabel.

### 11.4 Ringkasan hasil

Berdasarkan hasil pengerjaan yang telah dilaporkan, koneksi PostgreSQL melalui DBeaver dan pgAdmin berhasil, ketiga role berhasil diuji, dan tabel `mahasiswas` dapat diakses.

Hasil rinci setiap constraint serta pengujian operasi tulis perlu mengacu pada output aktual dan bukti pengujian yang disimpan oleh mahasiswa.

## 12. Keamanan dan Pengelolaan Kredensial

Pengelolaan kredensial merupakan bagian penting dari project database.

Praktik yang diterapkan dalam repository ini:

1. File `.env` lokal tidak disertakan dalam commit.
2. `.gitignore` digunakan untuk mencegah file konfigurasi sensitif ikut dilacak.
3. Password akun PostgreSQL, role database, dan pgAdmin diperlakukan sebagai kredensial yang berbeda.
4. Akses database diuji menggunakan role yang sesuai, bukan selalu menggunakan akun administrator.
5. Dokumentasi publik tidak memuat password asli.

**Penting:** file `.env` yang berisi password tidak boleh diunggah ke repository publik. Pastikan juga tidak ada password asli yang ditulis di dalam README, script, screenshot, atau file dokumentasi lain.

## 13. Troubleshooting

### DBeaver gagal terhubung

Periksa status container, port host `22112`, hostname, database, username, dan password. Gunakan konfigurasi host yang telah terbukti bekerja pada lingkungan lokal.

### pgAdmin tidak dapat terhubung ke PostgreSQL

Periksa apakah hostname internal `postgres_Syamil`, port `5432`, database `postgres`, username, dan password sudah benar.

Pesan `fe_sendauth: no password supplied` menunjukkan koneksi tidak mengirimkan password yang dibutuhkan oleh server.

### Container tidak berjalan

Periksa status layanan:

```bash
docker compose ps
```

Kemudian periksa log:

```bash
docker compose logs --tail=50
```

### Role tidak memiliki akses yang diharapkan

Periksa script `sql/01_setup.sql`, role yang sedang digunakan, serta izin pada schema dan tabel. Jalankan pemeriksaan hak akses melalui koneksi role yang bersangkutan.

### Git tidak mengunggah file yang diharapkan

Periksa status repository:

```bash
git status
```

Periksa juga aturan pada `.gitignore` untuk memastikan file yang diperlukan masuk ke repository, sedangkan file sensitif tetap diabaikan.

## 14. Version Control dan Repository

Project dikelola menggunakan Git dan disimpan di GitHub.

Repository digunakan untuk menyimpan file konfigurasi Docker Compose, script SQL, aturan `.gitignore`, dan dokumentasi project.

Perintah dasar yang digunakan untuk memperbarui dokumentasi:

```bash
git add README.md
git commit -m "Update README documentation"
git push
```

Perintah tersebut memperbarui dokumentasi di repository setelah perubahan disimpan secara lokal.

## 15. Kesimpulan

Project UTS Manajemen Basis Data ini mengimplementasikan lingkungan PostgreSQL berbasis Docker Compose dengan dukungan administrasi melalui pgAdmin dan DBeaver.

Implementasi juga mencakup schema `SALAM`, tabel `mahasiswas`, constraint untuk integritas data, serta pembagian hak akses melalui tiga role database: `backend_dev`, `bi_dev`, dan `data_engineer`.

Berdasarkan pengerjaan yang telah dilaporkan, koneksi PostgreSQL melalui DBeaver dan pgAdmin berhasil, serta ketiga role telah berhasil diuji. Dokumentasi ini disusun untuk menjelaskan konfigurasi dan proses validasi secara terstruktur, dengan hasil rinci tetap mengacu pada script SQL dan bukti pengujian yang tersedia.

---

**Dokumentasi Project UTS Manajemen Basis Data**  
Syamil Dhiyaul Haq · 1247050112
