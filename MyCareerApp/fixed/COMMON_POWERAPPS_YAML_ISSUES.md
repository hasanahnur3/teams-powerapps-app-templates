# Common Power Apps YAML Issues

Dokumen ini menjadi checklist wajib saat membuat atau mengubah screen YAML di
folder `MyCareerApp/fixed`. Tujuannya adalah mencegah masalah layout dan formula
yang sudah pernah berulang.

## 1. Text tidak mengikuti lebar parent

### Masalah

Modern text tidak selalu otomatis memakai seluruh lebar container. Akibatnya
teks terlihat sempit, terpotong, atau tidak sejajar dengan control lain.

### Aturan

- Tambahkan `Width: =Parent.Width` untuk text yang harus memenuhi container.
- Pada horizontal container, gunakan `FillPortions: =1` jika text harus memakai
  sisa ruang.
- Kurangi padding parent ketika menghitung lebar manual.
- Jangan menetapkan `Width` tetap tanpa kebutuhan desain yang jelas.

Contoh yang disarankan:

```yaml
- PageTitle:
    Control: ModernText@1.0.0
    Properties:
      AutoHeight: =true
      FillPortions: =1
      Text: ="Judul Halaman"
      Width: =Parent.Width
```

Untuk dua control di horizontal container:

```powerfx
(Parent.Width - Parent.LayoutGap) / 2
```

Jangan menghitung dari `App.Width` apabila control sebenarnya berada di dalam
container yang memiliki padding.

## 2. Text memiliki scrollbar atau terpotong karena height

### Masalah

Text panjang diberi `Height` tetap atau ditempatkan di container yang terlalu
pendek. Hasilnya adalah scrollbar internal, teks terpotong, atau content saling
menimpa.

### Aturan

- Gunakan `AutoHeight: =true` untuk judul, deskripsi, hasil coaching, dan text
  lain yang panjangnya dinamis.
- Jangan memasangkan `AutoHeight: =true` dengan `Height` tetap tanpa alasan.
- Tinggi parent harus mengikuti tinggi child dinamis.
- Container utama yang menampung banyak content boleh memakai
  `LayoutOverflowY: =LayoutOverflow.Scroll`; text individual sebaiknya tidak.
- Beri ruang untuk padding dan `LayoutGap` ketika menghitung tinggi container.

Contoh tinggi parent dinamis:

```powerfx
Max(
    400,
    Header.Height +
    Description.Height +
    Result.Height +
    Parent.PaddingTop +
    Parent.PaddingBottom +
    2 * Parent.LayoutGap
)
```

Contoh text:

```yaml
- ResultText:
    Control: ModernText@1.0.0
    Properties:
      AutoHeight: =true
      PaddingBottom: =16
      PaddingLeft: =16
      PaddingRight: =16
      PaddingTop: =16
      Text: =Coalesce(ThisItem.Hasil, "-")
      Width: =Parent.Width
```

## 3. Referensi field data source secara langsung atau memakai alias lama

### Masalah

Formula memakai nama internal/generated seperti `field_2`, atau masih
melakukan konversi berdasarkan tipe kolom lama. Ini sering terjadi setelah
kolom SharePoint dihapus lalu dibuat ulang.

Contoh yang tidak boleh dipakai:

```powerfx
ThisItem.field_2
```

```powerfx
Date(1899, 12, 30) + Value(ThisItem.Tanggal)
```

### Aturan

- Gunakan nama field semantik yang dikenali connector, misalnya
  `ThisItem.Tanggal`.
- Setelah kolom SharePoint dihapus, dibuat ulang, atau diubah tipenya, refresh
  atau reconnect data source sebelum memperbaiki formula.
- Cari seluruh pemakaian field pada list, form, detail, coach, dan admin screen.
- Pastikan tipe nilai yang ditulis sama dengan tipe kolom SharePoint.
- Jangan mempertahankan fallback tipe lama setelah migrasi selesai.

Contoh field Date SharePoint:

```powerfx
Text(ThisItem.Tanggal, "[$-id-ID]dd mmmm yyyy")
```

```powerfx
Patch(
    CoachingTematik,
    Defaults(CoachingTematik),
    {
        Tanggal: DateTanggal.SelectedDate
    }
)
```

Jangan mengubah Date menjadi serial number menggunakan `DateDiff()` jika kolom
tujuan sudah bertipe Date.

Sebelum selesai, lakukan pencarian repository:

```text
field_2
field_[angka]
Date(1899, 12, 30)
DateDiff(Date(1899, 12, 30), ...)
```

Konversi tanggal lama boleh tetap ada pada data source yang memang masih
menyimpan serial number. Jangan menghapusnya tanpa memeriksa schema sumber.

## 4. Container tidak memiliki margin atau padding yang layak

### Masalah

Control menempel ke border container, jarak antar-field tidak konsisten, atau
perhitungan width menyebabkan overflow.

### Aturan

- Card utama minimal memiliki padding yang konsisten pada empat sisi.
- Gunakan `LayoutGap` untuk jarak antar-child, bukan posisi manual.
- Gunakan padding lebih kecil pada mobile jika ruang terbatas.
- Perhitungan child width harus memperhitungkan padding dan gap.
- Hindari penggunaan `X` dan `Y` manual di dalam auto-layout container.

Contoh card:

```yaml
- ContentCard:
    Control: GroupContainer@1.5.0
    Variant: AutoLayout
    Properties:
      BorderColor: =RGBA(225, 223, 221, 1)
      BorderStyle: =BorderStyle.Solid
      BorderThickness: =1
      LayoutDirection: =LayoutDirection.Vertical
      LayoutGap: =16
      PaddingBottom: =If(App.Width < 640, 16, 24)
      PaddingLeft: =If(App.Width < 640, 16, 24)
      PaddingRight: =If(App.Width < 640, 16, 24)
      PaddingTop: =If(App.Width < 640, 16, 24)
      RadiusBottomLeft: =8
      RadiusBottomRight: =8
      RadiusTopLeft: =8
      RadiusTopRight: =8
      Width: =Parent.Width
```

Untuk child dalam horizontal container:

```powerfx
(Parent.Width - Parent.LayoutGap) / 2
```

Jika parent tidak otomatis mengurangi padding dari area layout, gunakan:

```powerfx
(
    Parent.Width -
    Parent.PaddingLeft -
    Parent.PaddingRight -
    Parent.LayoutGap
) / 2
```

## Checklist sebelum perubahan dianggap selesai

- Semua text dinamis memiliki `AutoHeight` atau tinggi yang cukup.
- Text yang harus memenuhi card memiliki `Width: =Parent.Width`.
- Parent cukup tinggi untuk seluruh child, gap, dan padding.
- Scroll hanya berada pada container halaman/list yang memang membutuhkannya.
- Tidak ada referensi `field_2` atau alias generated lain yang sudah usang.
- Semua formula read, sort, filter, default, dan patch memakai field yang sama.
- Nilai `Patch()` sesuai tipe schema SharePoint terbaru.
- Card memiliki padding, gap, border, dan radius yang konsisten.
- Layout medium/small diperiksa terpisah dari desktop.
- Empty state tetap terlihat dan tidak menyisakan row palsu.
- YAML dapat diparse dan `git diff --check` tidak menghasilkan error.

