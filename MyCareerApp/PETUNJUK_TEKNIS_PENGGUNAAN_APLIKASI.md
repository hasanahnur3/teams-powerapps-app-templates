# Petunjuk Teknis Penggunaan Aplikasi MyCareerApp

## 1. Ringkasan Aplikasi

MyCareerApp adalah aplikasi Power Apps untuk mendukung pengelolaan profil karier pegawai, performance review, coaching karier, coaching tematik, IDP, mentoring, dan monitoring oleh pimpinan atau admin. Aplikasi menggunakan beberapa sumber data berbasis Excel/SharePoint list yang merepresentasikan data pegawai, review, coaching, action item, IDP, mentoring, serta komponen profil quantitative dan qualitative.

Dokumen ini menjelaskan panduan teknis penggunaan aplikasi, alur pengguna berdasarkan peran, sumber data utama, serta kebutuhan penambahan fitur indikator warna profil pegawai berdasarkan feedback terbaru.

## 2. Peran Pengguna

| Peran | Akses Utama | Keterangan |
| --- | --- | --- |
| Pegawai | Profil Pegawai, Mentoring, Performance Review, Coaching Karir, Coaching Tematik, IDP | Mengisi dan melihat data pribadi serta aktivitas pengembangan karier. |
| Line Manager | Performance Review | Melihat dan memproses performance review pegawai sesuai kewenangan. |
| Coach/Mentor | Coaching Karir, Coaching Tematik, indikator warna profil pegawai | Membuat catatan coaching, action item, dan memberi indikator warna pada komponen profil pegawai. |
| Pimpinan | Daftar Pegawai, Profil Pegawai, Performance Review, Coaching Karir, Coaching Tematik | Melihat ringkasan dan detail pegawai untuk kebutuhan pemantauan dan pengambilan keputusan. |
| Admin | Monitoring Mentoring | Memantau pelaksanaan mentoring dan status tindak lanjut. |

## 3. Menu Utama Aplikasi

### 3.1 Homepage

Layar `S1_Homepage` menjadi pintu masuk aplikasi. Pada layar ini pengguna dapat melihat status pribadi dan mengakses menu berdasarkan perannya.

Komponen status yang tersedia:

| Komponen | Fungsi |
| --- | --- |
| Performance Review 1 | Menampilkan status pengisian performance review semester 1. |
| Performance Review 2 | Menampilkan status pengisian performance review semester 2. |
| Performance Review 3 | Menampilkan status pengisian performance review tambahan sesuai kebutuhan organisasi. |
| Coaching Karir Terakhir | Menampilkan status atau data coaching karier terakhir. |
| IDP Tahun Berjalan | Menampilkan status IDP berdasarkan tahun berjalan. |

Menu yang tersedia pada homepage:

| Kelompok Menu | Menu |
| --- | --- |
| Menu Pegawai | Profil Pegawai, Mentoring, Performance Review, Coaching Karir, Coaching Tematik, IDP |
| Menu Line Manager | Performance Review |
| Menu Mentor/Coach | Coaching Karir, Coaching Tematik |
| Menu Pimpinan | Daftar Pegawai |
| Menu Admin | Monitoring Mentoring |

## 4. Profil Pegawai

Layar `S2_ProfilPegawai` digunakan untuk melihat dan mengelola data profil pegawai. Profil pegawai terdiri dari tiga bagian utama:

### 4.1 Identitas Pegawai

Bagian identitas pegawai menampilkan informasi dasar:

| Field | Keterangan |
| --- | --- |
| Nama Pegawai | Nama pegawai sesuai data master. |
| Satuan Kerja | Unit kerja pegawai. |
| NIP | Nomor induk pegawai. |
| Jabatan | Jabatan pegawai saat ini. |
| Pangkat | Pangkat pegawai saat ini. |
| Tanggal Pengisian | Tanggal data profil diperbarui. |

### 4.2 Quantitative

Bagian quantitative berisi komponen profil yang dapat diukur secara angka atau periode.

| Komponen | Fungsi |
| --- | --- |
| Nilai Kinerja Rata-rata 5 Tahun | Menampilkan ringkasan nilai kinerja pegawai dalam lima tahun terakhir. |
| Masa Dinas Pangkat | Menampilkan durasi masa dinas pada pangkat saat ini. |
| Pendidikan | Menampilkan riwayat pendidikan pegawai. |
| Sertifikasi Tier 1 | Menampilkan sertifikasi tier 1 yang dimiliki pegawai. |
| Sertifikasi Tier 2 | Menampilkan sertifikasi tier 2 yang dimiliki pegawai. |
| PMK / External Learning | Menampilkan data program peningkatan kompetensi atau pembelajaran eksternal. |
| Kum Mengajar | Menampilkan data kegiatan mengajar atau internal knowledge sharing. |

### 4.3 Qualitative

Bagian qualitative berisi komponen profil berbasis pengalaman, exposure, dan kontribusi.

| Komponen | Fungsi |
| --- | --- |
| Penugasan DN/LN atau Strategis | Menampilkan riwayat penugasan domestik, luar negeri, atau strategis. |
| Prestasi BI Wide atau Lainnya | Menampilkan prestasi pegawai. |
| Kepanitiaan / Proyek / Tim Kerja / Adhoc | Menampilkan pengalaman pegawai dalam kegiatan proyek atau tim. |
| Plt / Penunjukan / Rangkap Jabatan | Menampilkan riwayat pelaksana tugas, penunjukan, atau rangkap jabatan. |

## 5. Pengelolaan Data Profil Pegawai

Pada setiap tabel profil terdapat tombol tambah baris atau aksi edit. Pengguna dapat melakukan langkah berikut:

1. Buka menu `Profil Pegawai`.
2. Pilih bagian profil yang akan diperbarui.
3. Klik `Tambah Baris` untuk membuat data baru.
4. Isi field wajib pada form.
5. Simpan data.
6. Pastikan data baru muncul kembali pada tabel profil.

Form profil yang tersedia:

| Layar | Fungsi |
| --- | --- |
| `S2A_Profil_Pendidikan_Form` | Input/edit riwayat pendidikan. |
| `S2B_Profil_SertifikasiTier1_Form` | Input/edit sertifikasi tier 1. |
| `S2C_Profil_SertifikasiTier2_Form` | Input/edit sertifikasi tier 2. |
| `S2D_Profil_PMK_Form` | Input/edit PMK atau external learning. |
| `S2E_Profil_KumMengajar_Form` | Input/edit kum mengajar. |
| `S2F_Profil_Penugasan_Form` | Input/edit penugasan. |
| `S2G_Profil_Prestasi_Form` | Input/edit prestasi. |
| `S2H_Profil_Kepanitiaan_Form` | Input/edit kepanitiaan/proyek/tim kerja. |
| `S2I_Profil_Plt_Form` | Input/edit Plt, penunjukan, atau rangkap jabatan. |

## 6. Performance Review

Modul Performance Review digunakan untuk pengisian, pemantauan, dan review kinerja pegawai.

| Layar | Fungsi |
| --- | --- |
| `S3A_PR_List` | Daftar performance review pegawai. |
| `S3B_PR_Form` | Form input/edit performance review. |
| `S3C_PR_Detail` | Detail performance review. |
| `S3D_PR_LM_List` | Daftar performance review untuk line manager. |

Alur umum:

1. Pegawai membuka menu `Performance Review`.
2. Pegawai membuat atau memperbarui data review sesuai periode.
3. Line manager membuka menu `Performance Review` pada menu line manager.
4. Line manager melakukan pemantauan atau tindak lanjut sesuai kewenangan.

## 7. Coaching Karir

Modul Coaching Karir digunakan untuk mencatat sesi coaching antara coach dan mentee.

| Layar | Fungsi |
| --- | --- |
| `S9A_CoachingKarir_Mentee_List` | Daftar coaching karier dari sisi mentee. |
| `S9A_CoachingKarir_Coach_List` | Daftar coaching karier dari sisi coach. |
| `S9B_CoachingKarir_Coach_Form` | Form pembuatan/edit coaching karier oleh coach. |
| `S9C_CoachingKarir_Detail` | Detail coaching karier. |

Data yang diisi pada form coaching karier:

| Field | Keterangan |
| --- | --- |
| Tanggal | Tanggal pelaksanaan coaching. |
| Mentee | Pegawai yang menerima coaching. |
| Catatan | Catatan utama hasil sesi coaching. |
| Foto Bukti | Bukti pelaksanaan coaching. |
| Action Items | Tindak lanjut yang harus dilakukan setelah sesi coaching. |

Alur coach:

1. Buka menu `Coaching Karir` pada menu mentor/coach.
2. Klik `Tambah Coaching Karir`.
3. Pilih mentee.
4. Isi tanggal, catatan, foto bukti, dan action item.
5. Klik `Simpan`.
6. Pastikan data muncul pada daftar coaching karier.

## 8. Coaching Tematik

Modul Coaching Tematik digunakan untuk mencatat sesi coaching berdasarkan topik tertentu.

| Layar | Fungsi |
| --- | --- |
| `S7A_CoachingTematik_List` | Daftar coaching tematik dari sisi pegawai. |
| `S7B_CoachingTematik_Form` | Form input/edit coaching tematik. |
| `S7C_CoachingTematik_Detail` | Detail coaching tematik dari sisi pegawai. |
| `S10A_CoachingTematik_Coach_List` | Daftar coaching tematik dari sisi coach. |
| `S10B_CoachingTematik_Coach_Detail` | Detail coaching tematik dari sisi coach. |

## 9. IDP

Modul IDP digunakan untuk melihat dan memperbarui Individual Development Plan.

| Layar | Fungsi |
| --- | --- |
| `S5A_IDP_View` | Melihat IDP. |
| `S5B_IDP_Edit` | Mengubah IDP. |

Alur umum:

1. Pegawai membuka menu `IDP`.
2. Pegawai melihat IDP tahun berjalan.
3. Jika perlu perubahan, pegawai membuka form edit.
4. Pegawai menyimpan perubahan.

## 10. Mentoring dan Monitoring

| Layar | Fungsi |
| --- | --- |
| `S6A_ChecklistMentoring_List` | Daftar checklist mentoring. |
| `S6B_ChecklistMentoring_Form` | Form checklist mentoring. |
| `S6C_ChecklistMentoring_Detail` | Detail checklist mentoring. |
| `S12_Admin_MonitoringMentoring` | Monitoring mentoring oleh admin. |

Admin menggunakan halaman monitoring untuk melihat status pelaksanaan mentoring dan menindaklanjuti data yang belum lengkap.

## 11. Menu Pimpinan

Layar `S11_Pimpinan_DaftarPegawai` digunakan pimpinan untuk memilih pegawai yang akan dilihat. Dari daftar pegawai, pimpinan dapat masuk ke:

| Menu | Fungsi |
| --- | --- |
| Profil Pegawai | Melihat identitas, quantitative, qualitative, dan executive summary pegawai. |
| Performance Review | Melihat data performance review pegawai. |
| Coaching Karir | Melihat riwayat coaching karier pegawai. |
| Coaching Tematik | Melihat riwayat coaching tematik pegawai. |

## 12. Penambahan Fitur Indikator Warna Profil Pegawai

### 12.1 Latar Belakang

Berdasarkan feedback, perlu ditambahkan halaman agar coach manajemen karier dapat melakukan penambahan indikator warna pada setiap komponen profil pegawai. Indikator ini berlaku untuk seluruh komponen quantitative dan qualitative.

Opsi warna yang tersedia:

| Warna | Makna Teknis yang Disarankan |
| --- | --- |
| Putih | Belum dinilai, tidak ada isu, atau data belum cukup. |
| Kuning | Perlu perhatian atau perlu pengembangan lanjutan. |
| Hijau | Kondisi baik atau memenuhi ekspektasi. |
| Merah | Perlu prioritas tindak lanjut. |

Makna warna dapat disesuaikan oleh pemilik proses bisnis, tetapi pilihan warna harus dibatasi hanya pada empat opsi di atas agar konsisten pada semua komponen.

### 12.2 Komponen yang Diberi Indikator

Indikator warna diterapkan pada seluruh komponen profil berikut:

| Area | Komponen |
| --- | --- |
| Quantitative | Nilai Kinerja Rata-rata 5 Tahun |
| Quantitative | Masa Dinas Pangkat |
| Quantitative | Pendidikan |
| Quantitative | Sertifikasi Tier 1 |
| Quantitative | Sertifikasi Tier 2 |
| Quantitative | PMK / External Learning |
| Quantitative | Kum Mengajar |
| Qualitative | Penugasan DN/LN atau Strategis |
| Qualitative | Prestasi BI Wide atau Lainnya |
| Qualitative | Kepanitiaan / Proyek / Tim Kerja / Adhoc |
| Qualitative | Plt / Penunjukan / Rangkap Jabatan |

### 12.3 Data Source Baru

Disarankan menambahkan data source baru:

`19_Profil_IndikatorWarna.xlsx` atau SharePoint list `ProfilIndikatorWarna`.

Struktur kolom:

| Kolom | Tipe | Wajib | Keterangan |
| --- | --- | --- | --- |
| Title | Text | Ya | ID unik, contoh `NIP_KodeKomponen_Tahun`. |
| NIP | Text | Ya | NIP pegawai yang dinilai. |
| Tahun | Number | Ya | Tahun penilaian indikator. |
| KodeKomponen | Text | Ya | Kode komponen, contoh `NILAI_KINERJA`, `MASA_DINAS_PANGKAT`. |
| NamaKomponen | Text | Ya | Nama komponen yang tampil di profil. |
| Area | Choice/Text | Ya | `Quantitative` atau `Qualitative`. |
| Warna | Choice/Text | Ya | `Putih`, `Kuning`, `Hijau`, atau `Merah`. |
| CatatanCoach | Multiline Text | Tidak | Catatan coach terkait alasan pemberian warna. |
| CoachNIP | Text | Ya | NIP coach yang memberi penilaian. |
| TanggalUpdate | DateTime | Ya | Waktu terakhir indikator diperbarui. |

Kode komponen yang disarankan:

| KodeKomponen | NamaKomponen |
| --- | --- |
| `NILAI_KINERJA` | Nilai Kinerja Rata-rata 5 Tahun |
| `MASA_DINAS_PANGKAT` | Masa Dinas Pangkat |
| `PENDIDIKAN` | Pendidikan |
| `SERTIFIKASI_TIER_1` | Sertifikasi Tier 1 |
| `SERTIFIKASI_TIER_2` | Sertifikasi Tier 2 |
| `PMK` | PMK / External Learning |
| `KUM_MENGAJAR` | Kum Mengajar |
| `PENUGASAN` | Penugasan DN/LN atau Strategis |
| `PRESTASI` | Prestasi BI Wide atau Lainnya |
| `KEPANITIAAN` | Kepanitiaan / Proyek / Tim Kerja / Adhoc |
| `PLT` | Plt / Penunjukan / Rangkap Jabatan |

### 12.4 Halaman Baru untuk Coach

Disarankan membuat layar baru:

`S13_Coach_IndikatorWarnaProfil`

Fungsi layar:

| Area | Fungsi |
| --- | --- |
| Filter pegawai | Coach memilih pegawai/mentee yang akan dinilai. |
| Filter tahun | Coach memilih tahun indikator. |
| Daftar komponen | Menampilkan semua komponen quantitative dan qualitative. |
| Pilihan warna | Coach memilih salah satu warna: Putih, Kuning, Hijau, Merah. |
| Catatan coach | Coach dapat memberi catatan opsional per komponen. |
| Simpan | Menyimpan indikator warna ke data source. |

Alur penggunaan oleh coach:

1. Coach membuka menu `Indikator Profil Pegawai` dari menu mentor/coach.
2. Coach memilih pegawai/mentee.
3. Coach memilih tahun penilaian.
4. Sistem menampilkan semua komponen quantitative dan qualitative.
5. Coach memilih warna untuk setiap komponen.
6. Coach mengisi catatan jika diperlukan.
7. Coach klik `Simpan`.
8. Sistem menyimpan atau memperbarui data berdasarkan kombinasi `NIP`, `Tahun`, dan `KodeKomponen`.

### 12.5 Validasi Halaman Coach

Validasi yang wajib diterapkan:

| Validasi | Aturan |
| --- | --- |
| Pegawai wajib dipilih | Tombol simpan nonaktif jika pegawai belum dipilih. |
| Tahun wajib dipilih | Tombol simpan nonaktif jika tahun kosong. |
| Warna wajib valid | Nilai hanya boleh `Putih`, `Kuning`, `Hijau`, atau `Merah`. |
| Satu data per komponen | Untuk satu NIP dan tahun, setiap komponen hanya memiliki satu indikator aktif. |
| Coach tercatat | `CoachNIP` otomatis menggunakan NIP pengguna aktif. |
| Tanggal update otomatis | `TanggalUpdate` diisi dengan `Now()`. |

### 12.6 Integrasi ke Profil Pegawai

Halaman `S2_ProfilPegawai` perlu ditambah executive summary indikator warna.

Lokasi yang disarankan:

1. Setelah bagian `Identitas Pegawai`, sebelum section `Quantitative`.
2. Atau pada bagian atas profil sebagai ringkasan visual agar pimpinan langsung melihat kondisi umum pegawai.

Komponen executive summary:

| Komponen | Fungsi |
| --- | --- |
| Total Putih | Jumlah komponen dengan indikator putih. |
| Total Kuning | Jumlah komponen dengan indikator kuning. |
| Total Hijau | Jumlah komponen dengan indikator hijau. |
| Total Merah | Jumlah komponen dengan indikator merah. |
| Ringkasan Area | Distribusi warna untuk quantitative dan qualitative. |
| Detail Komponen | Daftar komponen beserta warna terakhir dan catatan coach. |

Formula ringkasan yang disarankan:

```powerfx
CountRows(
    Filter(
        ProfilIndikatorWarna,
        NIP = Text(If(Coalesce(gblPimpinanView, false), gblSubjectNIP, gblCurrentNIP)) &&
        Tahun = Year(Today()) &&
        Warna = "Hijau"
    )
)
```

Formula warna badge yang disarankan:

```powerfx
Switch(
    ThisItem.Warna,
    "Putih", RGBA(255, 255, 255, 1),
    "Kuning", RGBA(255, 244, 206, 1),
    "Hijau", RGBA(223, 246, 221, 1),
    "Merah", RGBA(253, 231, 233, 1),
    RGBA(245, 245, 245, 1)
)
```

Formula warna teks/border yang disarankan:

```powerfx
Switch(
    ThisItem.Warna,
    "Putih", RGBA(96, 94, 92, 1),
    "Kuning", RGBA(122, 70, 0, 1),
    "Hijau", RGBA(16, 124, 16, 1),
    "Merah", RGBA(196, 43, 28, 1),
    RGBA(96, 94, 92, 1)
)
```

### 12.7 Integrasi ke Homepage

Pada `S1_Homepage`, menu mentor/coach dapat ditambahkan tombol:

`Indikator Profil Pegawai`

Navigasi:

```powerfx
Navigate(S13_Coach_IndikatorWarnaProfil, ScreenTransition.Fade)
```

Tombol ini hanya ditampilkan untuk pengguna dengan peran coach/mentor sesuai mekanisme role yang sudah digunakan aplikasi.

### 12.8 Integrasi ke Menu Pimpinan

Pada `S11_Pimpinan_DaftarPegawai`, pimpinan tetap masuk melalui profil pegawai. Executive summary indikator warna ditampilkan pada `S2_ProfilPegawai` ketika `gblPimpinanView = true`, sehingga pimpinan tidak perlu membuka layar tambahan.

### 12.9 Contoh Alur End-to-End Fitur Warna

1. Coach membuka menu `Indikator Profil Pegawai`.
2. Coach memilih pegawai `A`.
3. Coach memilih tahun berjalan.
4. Coach memberi indikator:
   - Nilai Kinerja: Hijau
   - Masa Dinas Pangkat: Kuning
   - Pendidikan: Putih
   - Penugasan: Merah
5. Coach menyimpan data.
6. Pimpinan membuka `Daftar Pegawai`.
7. Pimpinan memilih pegawai `A`.
8. Pada halaman profil pegawai, executive summary menampilkan total warna dan daftar komponen yang sudah diberi indikator.

## 13. Sumber Data Aplikasi

Sumber data yang digunakan aplikasi:

| File/Data Source | Fungsi |
| --- | --- |
| `01_Pegawai.xlsx` | Data master pegawai. |
| `02_PerformanceReview.xlsx` | Data performance review. |
| `03_CoachingKarir.xlsx` | Data coaching karier. |
| `04_ActionItem.xlsx` | Data action item coaching. |
| `05_IDP.xlsx` | Data Individual Development Plan. |
| `06_ChecklistMentoring.xlsx` | Data checklist mentoring. |
| `07_MentoringSesi.xlsx` | Data sesi mentoring. |
| `08_CoachingTematik.xlsx` | Data coaching tematik. |
| `09_Profil_Pendidikan.xlsx` | Data riwayat pendidikan. |
| `10_Profil_SertifikasiTier1.xlsx` | Data sertifikasi tier 1. |
| `11_Profil_SertifikasiTier2.xlsx` | Data sertifikasi tier 2. |
| `12_Profil_PMK.xlsx` | Data PMK atau external learning. |
| `13_Profil_KumMengajar.xlsx` | Data kum mengajar. |
| `14_Profil_Penugasan.xlsx` | Data penugasan. |
| `15_Profil_Prestasi.xlsx` | Data prestasi. |
| `16_Profil_Kepanitiaan.xlsx` | Data kepanitiaan/proyek/tim kerja. |
| `17_Profil_Plt.xlsx` | Data Plt, penunjukan, atau rangkap jabatan. |
| `18_Pengumuman.xlsx` | Data pengumuman. |
| `19_Profil_IndikatorWarna.xlsx` | Data indikator warna profil pegawai yang perlu ditambahkan. |

## 14. Rekomendasi Implementasi Teknis

1. Tambahkan data source `ProfilIndikatorWarna`.
2. Tambahkan layar `S13_Coach_IndikatorWarnaProfil`.
3. Tambahkan menu `Indikator Profil Pegawai` pada menu mentor/coach di homepage.
4. Tambahkan executive summary indikator warna pada `S2_ProfilPegawai`.
5. Pastikan data disimpan dengan key unik `NIP`, `Tahun`, dan `KodeKomponen`.
6. Pastikan pilihan warna hanya empat opsi: Putih, Kuning, Hijau, Merah.
7. Pastikan halaman profil tetap dapat dibaca oleh pegawai dan pimpinan, tetapi perubahan indikator hanya dapat dilakukan oleh coach manajemen karier.

## 15. Checklist Pengujian

| No | Skenario | Hasil yang Diharapkan |
| --- | --- | --- |
| 1 | Coach membuka halaman indikator warna | Halaman terbuka dan daftar pegawai dapat dipilih. |
| 2 | Coach memilih pegawai dan tahun | Daftar komponen quantitative dan qualitative muncul. |
| 3 | Coach memilih warna pada semua komponen | Semua pilihan warna tersimpan secara lokal sebelum submit. |
| 4 | Coach klik simpan | Data tersimpan ke `ProfilIndikatorWarna`. |
| 5 | Coach mengubah warna yang sudah ada | Data lama diperbarui, tidak membuat duplikasi untuk komponen yang sama. |
| 6 | Pimpinan membuka profil pegawai | Executive summary indikator warna tampil. |
| 7 | Pegawai membuka profil sendiri | Executive summary tampil sesuai data pegawai tersebut. |
| 8 | Warna tidak valid dimasukkan dari data source | Aplikasi menampilkan default warna netral atau menolak nilai. |
| 9 | Data indikator belum tersedia | Executive summary tetap tampil dengan angka 0 atau status belum dinilai. |
| 10 | Responsif mobile/desktop | Komponen ringkasan tidak saling tumpang tindih. |

## 16. Catatan Operasional

- Coach bertanggung jawab memastikan warna yang diberikan sesuai hasil asesmen atau coaching.
- Pimpinan menggunakan executive summary sebagai bahan pemantauan, bukan sebagai satu-satunya dasar keputusan.
- Admin perlu memastikan data source indikator warna memiliki permission yang benar.
- Audit perubahan dapat dilakukan melalui kolom `CoachNIP` dan `TanggalUpdate`.
- Jika definisi warna berubah, perubahan harus terdokumentasi agar interpretasi antar unit tetap konsisten.
