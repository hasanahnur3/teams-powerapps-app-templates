# Panduan Halaman List CRUD yang Compatible dengan Pimpinan

Dokumen ini menjadi acuan untuk membuat halaman list objek lain, misalnya IDP,
Coaching Karir, Coaching Tematik, atau Checklist Mentoring.

## 1. Pisahkan user login dan subjek yang dilihat

Jangan mengganti identitas user login ketika Pimpinan melihat data pegawai lain.

Gunakan tiga variabel berikut:

```powerfx
gblCurrentNIP
```

NIP user yang sedang login.

```powerfx
gblSubjectNIP
```

NIP pegawai yang dipilih oleh Pimpinan.

```powerfx
gblPimpinanView
```

Penanda apakah halaman dibuka dari menu Pimpinan.

Gunakan pola ini pada filter data:

```powerfx
NIP = Text(
    If(
        Coalesce(gblPimpinanView, false),
        gblSubjectNIP,
        gblCurrentNIP
    )
)
```

Hasilnya:

- Mode normal menampilkan data user login.
- Mode Pimpinan menampilkan data pegawai pilihan.
- Satu halaman dapat dipakai untuk dua konteks.

## 2. Aktifkan mode Pimpinan hanya dari menu Pimpinan

Saat halaman pemilihan pegawai dibuka:

```powerfx
Set(gblPimpinanView, false)
```

Saat pegawai dipilih:

```powerfx
Set(gblSelectedEmployee, Self.Selected);
Set(gblSubjectNIP, Self.Selected.NIP)
```

Pemilihan pegawai belum mengaktifkan mode Pimpinan. Mode tersebut baru aktif
ketika tab tujuan diklik:

```powerfx
Set(gblPimpinanView, true);
Navigate(TargetScreen, ScreenTransition.Fade)
```

Saat keluar dari menu Pimpinan:

```powerfx
Set(gblPimpinanView, false);
Set(gblSubjectNIP, Blank());
Set(gblSelectedEmployee, Blank());
Back()
```

## 3. Jangan membuat halaman list duplikat

Gunakan halaman list yang sama untuk pegawai dan Pimpinan.

Yang berbeda hanya:

- NIP yang dipakai untuk filter.
- Context bar yang terlihat pada mode Pimpinan.
- Hak untuk membuat, mengedit, dan menghapus data.

Ini mengurangi duplikasi formula dan biaya maintenance.

## 4. Tambahkan context bar untuk Pimpinan

Context bar hanya terlihat ketika:

```powerfx
Coalesce(gblPimpinanView, false)
```

Context bar minimal menampilkan:

- Nama pegawai yang sedang dilihat.
- Link kembali ke halaman pemilihan pegawai.
- Tab menuju halaman lain yang sudah tersedia.

Nama pegawai:

```powerfx
Coalesce(
    LookUp(
        Pegawai,
        Title = Text(gblSubjectNIP),
        Nama
    ),
    Text(gblSubjectNIP),
    "-"
)
```

## 5. Filter list berdasarkan subjek

Contoh gallery:

```powerfx
Filter(
    DataSourceName,
    NIP = Text(
        If(
            Coalesce(gblPimpinanView, false),
            gblSubjectNIP,
            gblCurrentNIP
        )
    )
)
```

Pastikan tipe data dibandingkan sama:

- Kolom SharePoint text: gunakan `Text(...)`.
- Kolom SharePoint number: gunakan `Value(...)`.
- Lookup/person column membutuhkan struktur record yang sesuai.

## 6. Sorting list

Untuk sorting satu kolom:

```powerfx
Sort(
    Filter(...),
    Tanggal,
    SortOrder.Descending
)
```

Untuk Tahun dan Semester:

```powerfx
Sort(
    Filter(...),
    Value(Tahun) * 10 + Value(Semester),
    SortOrder.Descending
)
```

Pola ini dipilih karena `SortByColumns()` dapat menghasilkan invalid arguments
untuk nama atau tipe kolom SharePoint tertentu.

Jika tetap memakai `SortByColumns()`, pastikan:

- Nama internal kolom benar.
- Kolom dikenali data source terbaru.
- Data source sudah di-refresh atau dihubungkan ulang.

## 7. Struktur layout list

Pola yang disarankan:

```text
Screen container
├── Header
└── Main content
    ├── Page title
    ├── Pimpinan context (conditional)
    └── List card
        ├── Table header (desktop/large)
        └── Gallery
```

Gallery tetap menjadi sumber data utama. Header tabel hanya berfungsi sebagai
label visual.

## 8. Responsive table dan card

Gunakan mode tabel pada layar besar dan compact card pada layar kecil.

Gunakan `App.Width` untuk memilih mode:

```powerfx
App.Width >= 1200
```

Jangan menggunakan `Parent.TemplateWidth` untuk menentukan breakpoint halaman.
Lebar gallery dipengaruhi padding dan container sehingga ukuran Large dapat
salah terbaca sebagai Medium.

Contoh:

```powerfx
TableHeader.Visible = App.Width >= 1200

Gallery.TemplateSize =
If(
    App.Width < 1200,
    152,
    92
)
```

Pada compact card, tampilkan informasi terpenting:

- Foto atau icon.
- Tahun/tanggal.
- Status atau kategori.
- Nama pihak terkait.
- CTA Detail.

## 9. Sinkronkan header dan posisi row

Header dan row harus memakai pembagian lebar yang sama.

Contoh:

| Kolom | Proporsi |
|---|---:|
| Foto | 10% |
| Tahun | 13% |
| Semester | 13% |
| Tanggal | 18% |
| Pihak terkait | 30% |
| Aksi | 16% |

Header:

```powerfx
Width = (Parent.Width - TotalPadding) * 0.13
```

Row:

```powerfx
Width = (Parent.TemplateWidth - TotalPadding) * 0.13
```

Posisi `X` harus menggunakan jumlah proporsi kolom sebelumnya.

Hindari campuran lebar tetap dan `FillPortions` jika row memakai koordinat
manual. Campuran tersebut sering membuat header dan isi tidak sejajar.

## 10. Gallery di dalam AutoLayout

Gallery di dalam vertical AutoLayout perlu ruang yang eksplisit:

```powerfx
FillPortions = 1
```

Tanpa ini, gallery dapat jatuh ke `LayoutMinHeight` dan terlihat kosong walaupun
`Items` sebenarnya memiliki data.

Gunakan juga:

```powerfx
LayoutMinHeight = 16
LayoutMinWidth = 16
```

## 11. Navigasi ke detail

Simpan record terpilih sebelum navigasi:

```powerfx
Set(gblSelectedObject, ThisItem);
Navigate(ObjectDetailScreen, ScreenTransition.Fade)
```

Contoh Performance Review:

```powerfx
Set(gblSelectedPR, ThisItem);
Navigate(S3C_PR_Detail, ScreenTransition.Fade)
```

Detail screen membaca `gblSelectedObject`, bukan melakukan lookup ulang jika
tidak diperlukan.

## 12. CTA pada list

Setiap row minimal memiliki CTA Detail.

```powerfx
Set(gblSelectedObject, ThisItem);
Navigate(ObjectDetailScreen, ScreenTransition.Fade)
```

Untuk aksesibilitas:

- Gunakan label jelas seperti `Detail`, bukan hanya icon.
- Pastikan ukuran tombol cukup pada mobile.
- Jangan letakkan tombol terlalu jauh dari informasi row.

## 13. Hak Create, Edit, dan Delete

Menampilkan data pegawai lain tidak berarti Pimpinan otomatis boleh mengubahnya.

Contoh tombol tambah hanya untuk pemilik data:

```powerfx
!Coalesce(gblPimpinanView, false)
```

Atau:

```powerfx
Text(gblCurrentNIP) =
Text(
    If(
        Coalesce(gblPimpinanView, false),
        gblSubjectNIP,
        gblCurrentNIP
    )
)
```

Untuk role tertentu:

```powerfx
Or(
    !Coalesce(gblPimpinanView, false),
    gblCurrentUserRole = "Admin"
)
```

Tetap terapkan permission pada SharePoint atau data source. Properti `Visible`
di Power Apps bukan sistem keamanan.

## 14. Create

Saat membuka form baru:

```powerfx
Set(gblEditMode, false);
Set(gblSelectedObject, Blank());
Navigate(ObjectFormScreen, ScreenTransition.Fade)
```

Pada form:

```powerfx
DefaultMode =
If(
    Coalesce(gblEditMode, false),
    FormMode.Edit,
    FormMode.New
)
```

```powerfx
Item =
If(
    Coalesce(gblEditMode, false),
    gblSelectedObject,
    Defaults(DataSourceName)
)
```

## 15. Edit

Sebelum membuka form:

```powerfx
Set(gblSelectedObject, ThisItem);
Set(gblEditMode, true);
Navigate(ObjectFormScreen, ScreenTransition.Fade)
```

Update record yang sama:

```powerfx
Patch(
    DataSourceName,
    gblSelectedObject,
    {
        FieldA: ControlA.Value,
        FieldB: ControlB.Value
    }
)
```

Jangan gunakan `Defaults(DataSourceName)` untuk edit karena itu membuat row
baru.

## 16. Delete

Selalu gunakan confirmation dialog:

```powerfx
UpdateContext({locShowDeleteConfirm: true})
```

Setelah dikonfirmasi:

```powerfx
IfError(
    Remove(
        DataSourceName,
        gblSelectedObject
    );
    Refresh(DataSourceName);
    UpdateContext({locShowDeleteConfirm: false});
    Notify(
        "Data berhasil dihapus.",
        NotificationType.Success
    );
    Navigate(ObjectListScreen, ScreenTransition.Fade),
    Notify(
        "Gagal menghapus: " & FirstError.Message,
        NotificationType.Error
    )
)
```

## 17. Empty state

Sediakan pesan jika gallery kosong:

```powerfx
IsEmpty(GalleryName.AllItems)
```

Contoh pesan:

```text
Belum ada data untuk pegawai ini.
```

Bedakan antara:

- Pegawai belum dipilih.
- Pegawai sudah dipilih tetapi belum memiliki data.
- Data gagal dimuat.

## 18. Error handling

Bungkus operasi mutasi dengan `IfError()`:

```powerfx
IfError(
    Patch(...),
    Notify(
        "Gagal menyimpan: " & FirstError.Message,
        NotificationType.Error
    )
)
```

Setelah berhasil:

```powerfx
Refresh(DataSourceName);
Notify(
    "Data berhasil disimpan.",
    NotificationType.Success
)
```

## 19. Pencegahan double submit

Gunakan variabel:

```powerfx
Set(gblSubmitting, true)
```

Tombol:

```powerfx
If(
    Coalesce(gblSubmitting, false),
    DisplayMode.Disabled,
    DisplayMode.Edit
)
```

Reset pada sukses dan gagal:

```powerfx
Set(gblSubmitting, false)
```

## 20. Source Code schema yang perlu diperhatikan

Beberapa aturan yang sudah ditemukan:

- `Rectangle@2.3.0` tidak mendukung properti radius.
- Gunakan `GroupContainer` atau control lain jika membutuhkan rounded corner.
- Formula multiline harus memakai YAML block:

```yaml
OnSelect: |-
  =Set(...);
  Navigate(...)
```

- Formula yang memiliki record literal `{...}` kadang perlu block atau quoted
  scalar agar tidak dianggap sebagai mapping YAML.
- Control type harus sesuai schema, misalnya `AddMedia@2.2.1`, bukan
  `AddMediaButton`.
- Valid YAML belum menjamin semua properti dikenali Power Apps. Tetap cek error
  PA2101/PA2108 setelah paste.

## 21. Checklist sebelum halaman list dianggap selesai

- Data tampil untuk user login.
- Data tampil untuk pegawai pilihan Pimpinan.
- Context Pimpinan hanya muncul dari menu Pimpinan.
- Keluar dari menu Pimpinan mengembalikan mode normal.
- Filter membandingkan tipe data yang sama.
- Sorting tidak menghasilkan formula error.
- Gallery memiliki `FillPortions`.
- Desktop menampilkan mode tabel.
- Medium dan mobile menampilkan compact card.
- Header dan row sejajar.
- Line Manager/pihak terkait tampil pada mobile.
- CTA Detail menyimpan record terpilih.
- Create/Edit/Delete mengikuti permission.
- Delete memiliki confirmation dialog.
- Empty state tersedia.
- Formula error menampilkan pesan yang berguna.
- YAML valid dan Source Code schema diterima Power Apps.

