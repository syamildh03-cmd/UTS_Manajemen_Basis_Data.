-- UTS Manajemen Basis Data
-- Jalankan otomatis saat volume PostgreSQL pertama kali dibuat.
-- Role: backend_dev (CRUD), bi_dev (SELECT), data_engineer (owner/pengelola objek).

CREATE ROLE backend_dev LOGIN PASSWORD 'BackendDev_Ganti123!';
CREATE ROLE bi_dev LOGIN PASSWORD 'BiDev_Ganti123!';
CREATE ROLE data_engineer LOGIN PASSWORD 'DataEngineer_Ganti123!';

CREATE SCHEMA "SALAM" AUTHORIZATION data_engineer;

SET ROLE data_engineer;

CREATE TABLE "SALAM".mahasiswas (
    nim VARCHAR(20) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    angkatan INTEGER NOT NULL CHECK (angkatan BETWEEN 2000 AND 2100),
    ipk NUMERIC(3,2) CHECK (ipk >= 0.00 AND ipk <= 4.00)
);

INSERT INTO "SALAM".mahasiswas (nim, nama, email, angkatan, ipk) VALUES
('1247050112', 'Mahasiswa Contoh', 'mahasiswa.contoh@example.com', 2024, 3.50);

RESET ROLE;

-- Akses schema
GRANT USAGE ON SCHEMA "SALAM" TO backend_dev, bi_dev;
GRANT USAGE, CREATE ON SCHEMA "SALAM" TO data_engineer;

-- Izin objek yang sudah ada
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "SALAM" TO backend_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA "SALAM" TO bi_dev;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA "SALAM" TO backend_dev, data_engineer;

-- Hak akses default untuk tabel/sequence yang dibuat data_engineer berikutnya
ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA "SALAM"
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA "SALAM"
GRANT SELECT ON TABLES TO bi_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA "SALAM"
GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO backend_dev;

-- data_engineer memiliki objek awal karena membuat tabel dengan SET ROLE.
-- Catatan: PostgreSQL tidak menyediakan privilege ALTER/DROP terpisah;
-- pemilik objek (owner) dapat mengubah dan menghapus objek tersebut.
