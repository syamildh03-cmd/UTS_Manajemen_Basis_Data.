# UTS Manajemen Basis Data — PostgreSQL + pgAdmin 4

## Konfigurasi yang digunakan
- PostgreSQL image: `postgres:15` (sesuai rentang versi 9–15)
- Container PostgreSQL: `postgres_Syamil`
- Container pgAdmin: `pgadmin_Syamil`
- Port eksternal PostgreSQL: `22112` (NIM berakhir 112)
- Port eksternal pgAdmin: `44112`
- Password PostgreSQL disimpan di `.env`, bukan di `docker-compose.yml`.

> Sebelum dikumpulkan, sesuaikan nama container bila dosen mengharuskan format tertentu. Jangan unggah file `.env` ke repositori publik.

## Menjalankan
Dari folder yang berisi `docker-compose.yml`:
```bash
docker compose config
docker compose up -d
docker compose ps
docker compose logs postgres
```
Buka pgAdmin di `http://localhost:44112`.
Login email `admin@example.com` dan password sesuai `PGADMIN_PASSWORD` di `.env`.

## Daftarkan server PostgreSQL di pgAdmin (internal Docker)
Pada pgAdmin: **Add New Server**
- General → Name: `PostgreSQL Docker`
- Connection → Host name/address: `postgres`
- Port: `5432`
- Maintenance database: `postgres`
- Username: `postgres`
- Password: nilai `POSTGRES_PASSWORD` dari `.env`
- Save password: boleh dicentang untuk praktikum.

Nama host internal adalah `postgres` (nama service Compose), bukan `localhost`.

## Koneksi DBeaver (external)
- Host: `localhost`
- Port: `22112`
- Database: `postgres`
- Username: `postgres`
- Password: nilai `POSTGRES_PASSWORD` dari `.env`

## Menguji constraints
Jalankan di DBeaver/pgAdmin:
```sql
SELECT * FROM "SALAM".mahasiswas;

-- Harus gagal: email duplikat (UNIQUE)
INSERT INTO "SALAM".mahasiswas(nim,nama,email,angkatan,ipk)
VALUES ('999','Uji Duplikat','mahasiswa.contoh@example.com',2024,3.2);

-- Harus gagal: IPK di luar rentang (CHECK)
INSERT INTO "SALAM".mahasiswas(nim,nama,email,angkatan,ipk)
VALUES ('998','Uji Check','uji.check@example.com',2024,4.5);

-- Harus gagal: NIM duplikat (PRIMARY KEY)
INSERT INTO "SALAM".mahasiswas(nim,nama,email,angkatan,ipk)
VALUES ('1247050112','Uji PK','uji.pk@example.com',2024,3.0);
```
Uji setiap perintah gagal secara terpisah agar transaksi tidak tertahan oleh error sebelumnya.

## Menguji hak akses
Buat koneksi baru di DBeaver untuk masing-masing username/password role yang tercantum di `sql/01_setup.sql`.
- `backend_dev`: SELECT/INSERT/UPDATE/DELETE pada tabel di schema SALAM.
- `bi_dev`: SELECT diperbolehkan; INSERT/UPDATE/DELETE seharusnya ditolak.
- `data_engineer`: pemilik schema dan tabel awal; dapat membuat/mengubah/menghapus objek yang dimilikinya serta CRUD tabel.
Catatan: di PostgreSQL, ALTER/DROP tidak diberikan lewat GRANT biasa; kewenangan tersebut berasal dari kepemilikan objek atau role superuser.

## Jika script SQL tidak berjalan
File dalam `/docker-entrypoint-initdb.d` hanya dijalankan saat direktori data PostgreSQL masih kosong (volume baru).
Untuk mengulang dari awal (PERINGATAN: menghapus data volume database):
```bash
docker compose down -v
docker compose up -d
```
Gunakan perintah tersebut hanya jika data boleh dihapus.

## Dokumentasi PDF
Masukkan screenshot asli hasil kerja:
1. `docker compose ps` memperlihatkan kedua container `Up`.
2. Browser pgAdmin berhasil dibuka.
3. pgAdmin terhubung ke PostgreSQL melalui hostname internal `postgres`.
4. DBeaver berhasil terhubung melalui `localhost:22112`.
5. Hasil `SELECT * FROM "SALAM".mahasiswas`.
6. Error nyata saat menguji UNIQUE, CHECK, dan PRIMARY KEY.
7. Pengujian izin `backend_dev`, `bi_dev`, dan `data_engineer`.
8. Repositori GitHub/GitLab yang berisi compose dan SQL (tanpa `.env`).
Sertakan keterangan singkat di bawah setiap gambar. Jangan membuat screenshot simulasi; gunakan hasil dari komputer sendiri.
