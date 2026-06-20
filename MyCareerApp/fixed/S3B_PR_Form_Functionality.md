# Performance Review Form — Functional Notes

Dokumentasi ini merangkum fungsi utama yang diterapkan pada
`S3B_PR_Form.yaml` dan dapat dijadikan pola untuk form Power Apps berikutnya.

## 1. Form membuat item baru

```powerfx
DefaultMode = FormMode.New
Item = Defaults(PerformanceReview)
```

Form selalu dibuka untuk membuat record baru pada SharePoint List
`PerformanceReview`.

## 2. Nilai default otomatis

| Field | Formula default |
|---|---|
| NIP | `Text(gblCurrentNIP)` |
| Tahun | `Year(Today())` |
| Tanggal | `Today()` |

NIP dibuat disabled agar pengguna tidak dapat mengubah identitas pegawai.

## 3. Pemilihan Line Manager

ComboBox menampilkan nama pegawai, tetapi menyimpan NIP:

```powerfx
Items =
ForAll(
    Pegawai,
    {
        Value: Nama,
        NIP: Title
    }
)
```

Nilai yang disimpan:

```powerfx
DataCardValue30.Selected.NIP
```

Pola ini berguna ketika tampilan membutuhkan nama yang mudah dibaca, sedangkan
database membutuhkan kode atau ID.

## 4. Validasi sebelum submit

Field berikut wajib diisi:

- Semester
- Line Manager
- Goal
- Reality
- Options
- Will

```powerfx
If(
    Or(
        IsBlank(DataCardValue28.Value),
        IsBlank(DataCardValue30.Selected.NIP),
        IsBlank(Trim(DataCardValue31.Value)),
        IsBlank(Trim(DataCardValue32.Value)),
        IsBlank(Trim(DataCardValue33.Value)),
        IsBlank(Trim(DataCardValue34.Value))
    ),
    Notify(
        "Lengkapi Semester, Line Manager, Goal, Reality, Options, dan Will.",
        NotificationType.Warning
    ),
    /* proses simpan */
)
```

`Trim()` dipakai pada input teks agar teks yang hanya berisi spasi tetap
dianggap kosong.

## 5. Pencegahan double submit

Sebelum penyimpanan dimulai:

```powerfx
Set(gblPRSubmitting, true)
```

Tombol dinonaktifkan selama proses:

```powerfx
If(
    Coalesce(gblPRSubmitting, false),
    DisplayMode.Disabled,
    DisplayMode.Edit
)
```

Setelah proses berhasil atau gagal:

```powerfx
Set(gblPRSubmitting, false)
```

Pola ini mencegah dua item tercipta akibat tombol diklik berulang kali.

## 6. Penyimpanan menggunakan `Patch`

Semua nilai dikirim secara eksplisit:

```powerfx
Patch(
    PerformanceReview,
    Defaults(PerformanceReview),
    {
        NIP: Text(gblCurrentNIP),
        Tahun: Value(DataCardValue27.Value),
        Semester: Value(DataCardValue28.Value),
        Tanggal: DataCardValue29.SelectedDate,
        LineManagerNIP: DataCardValue30.Selected.NIP,
        Goal: DataCardValue31.Value,
        Reality: DataCardValue32.Value,
        Options: DataCardValue33.Value,
        Will: DataCardValue34.Value,
        FotoBukti: ImageFotoBukti.Image
    }
)
```

Pendekatan ini dipilih agar nilai dari modern controls dan gambar terkirim
secara konsisten.

## 7. Upload dan preview FotoBukti

Data card gambar:

```powerfx
DataField = "FotoBukti"
Update = ImageFotoBukti.Image
```

Preview menggunakan gambar baru jika dipilih, atau nilai lama jika belum:

```powerfx
If(
    IsBlank(AddMediaFotoBukti.Media),
    Parent.Default,
    AddMediaFotoBukti.Media
)
```

Nilai yang dikirim ketika menyimpan:

```powerfx
FotoBukti: ImageFotoBukti.Image
```

## 8. Title mengikuti ID SharePoint

SharePoint memberikan `ID` setelah item dibuat. Karena itu dilakukan dua
`Patch` terhadap item yang sama:

```powerfx
With(
    {
        newPerformanceReview: Patch(
            PerformanceReview,
            Defaults(PerformanceReview),
            {
                Title: "TEMP_" & Text(GUID()),
                /* field lainnya */
            }
        )
    },
    Patch(
        PerformanceReview,
        newPerformanceReview,
        {
            Title: Text(newPerformanceReview.ID)
        }
    )
)
```

Proses tersebut:

1. Membuat satu record dengan Title sementara.
2. Mendapatkan record dan ID yang dihasilkan SharePoint.
3. Memperbarui Title pada record yang sama.

Ini tidak membuat row kedua. Nomor ID selalu meningkat, tetapi dapat memiliki
nomor terlewat jika item pernah dibuat lalu dihapus.

## 9. Penanganan error

```powerfx
IfError(
    /* proses penyimpanan */,
    Notify(
        "Gagal menyimpan: " & FirstError.Message,
        NotificationType.Error
    );
    Set(gblPRSubmitting, false)
)
```

`FirstError.Message` menampilkan pesan dari data source sehingga masalah lebih
mudah ditelusuri.

## 10. Aksi setelah berhasil

```powerfx
Refresh(PerformanceReview);
Notify(
    "Performance Review berhasil disimpan.",
    NotificationType.Success
);
Set(gblPRSubmitting, false);
Navigate(S3A_PR_List, ScreenTransition.Fade)
```

Urutannya:

1. Refresh data source.
2. Tampilkan notifikasi sukses.
3. Lepaskan status submit.
4. Navigasi ke halaman daftar.

## Pola reusable untuk form berikutnya

```text
Validasi input
    ↓
Kunci tombol submit
    ↓
Patch semua field
    ↓
Tangani error
    ↓
Refresh data source
    ↓
Tampilkan notifikasi
    ↓
Navigasi ke halaman tujuan
```

## Checklist form baru

- Tentukan data source dan mode form.
- Isi nilai default yang dapat diambil dari user atau tanggal aktif.
- Pastikan tipe nilai sesuai dengan tipe kolom SharePoint.
- Bedakan nilai yang ditampilkan dan nilai yang disimpan pada ComboBox.
- Validasi field wajib sebelum memanggil `Patch`.
- Gunakan variabel submitting untuk mencegah double submit.
- Kirim seluruh field penting secara eksplisit.
- Gunakan `Value()` untuk kolom angka dan `Text()` untuk kolom teks.
- Gunakan kontrol gambar yang sesuai untuk kolom Image/Thumbnail.
- Bungkus proses penyimpanan dengan `IfError`.
- Reset variabel submitting pada kondisi sukses dan gagal.
- Refresh data source sebelum kembali ke halaman daftar.
- Lakukan navigasi hanya setelah penyimpanan berhasil.
