#!/usr/bin/env ruby

ROOT = File.expand_path("..", __dir__)
OUTPUT = File.join(ROOT, "MyCareerApp", "fixed")

FORMS = [
  {
    key: "SertifikasiTier1",
    screen: "S2B_Profil_SertifikasiTier1_Form",
    source: "Profil_SertifikasiTier1",
    title: "Sertifikasi Tier 1",
    fields: [
      ["NamaSertifikat", "Nama Sertifikat", :text],
      ["Penerbit", "Penerbit", :text],
      ["TanggalTerbit", "Tanggal Terbit", :date],
      ["TanggalBerakhir", "Tanggal Berakhir", :date],
      ["NomorSertifikat", "Nomor Sertifikat", :text]
    ]
  },
  {
    key: "SertifikasiTier2",
    screen: "S2C_Profil_SertifikasiTier2_Form",
    source: "Profil_SertifikasiTier2",
    title: "Sertifikasi Tier 2",
    fields: [
      ["NamaSertifikat", "Nama Sertifikat", :text],
      ["Penerbit", "Penerbit", :text],
      ["TanggalTerbit", "Tanggal Terbit", :date],
      ["TanggalBerakhir", "Tanggal Berakhir", :date],
      ["NomorSertifikat", "Nomor Sertifikat", :text]
    ]
  },
  {
    key: "PMK",
    screen: "S2D_Profil_PMK_Form",
    source: "Profil_PMK",
    title: "PMK",
    fields: [
      ["TrainingName", "Nama Pelatihan", :text],
      ["Penyelenggara", "Penyelenggara", :text],
      ["StartDate", "Tanggal Mulai", :date],
      ["CompletionDate", "Tanggal Selesai", :date],
      ["JenisPMK", "Jenis PMK", :text],
      ["Tipe", "Tipe", :text],
      ["Negara", "Negara", :text]
    ]
  },
  {
    key: "KumMengajar",
    screen: "S2E_Profil_KumMengajar_Form",
    source: "Profil_KumMengajar",
    title: "Kum Mengajar",
    fields: [
      ["NamaIHT", "Nama IHT", :text],
      ["TanggalPelaksanaan", "Tanggal Pelaksanaan", :date]
    ]
  },
  {
    key: "Penugasan",
    screen: "S2F_Profil_Penugasan_Form",
    source: "Profil_Penugasan",
    title: "Penugasan",
    fields: [
      ["TglMulai", "Tanggal Mulai", :date],
      ["TglAkhir", "Tanggal Akhir", :date],
      ["PIC", "PIC", :text],
      ["NamaPenugasan", "Nama Penugasan", :text],
      ["Deskripsi", "Deskripsi", :multiline]
    ]
  },
  {
    key: "Prestasi",
    screen: "S2G_Profil_Prestasi_Form",
    source: "Profil_Prestasi",
    title: "Prestasi",
    fields: [
      ["Jenis", "Jenis", :text],
      ["Level", "Level", :text],
      ["NamaPrestasi", "Nama Prestasi", :text],
      ["DetailPrestasi", "Detail Prestasi", :multiline],
      ["Tanggal", "Tanggal", :date]
    ]
  },
  {
    key: "Kepanitiaan",
    screen: "S2H_Profil_Kepanitiaan_Form",
    source: "Profil_Kepanitiaan",
    title: "Kepanitiaan",
    fields: [
      ["NamaKepanitiaan", "Nama Kepanitiaan", :text],
      ["Posisi", "Posisi", :text],
      ["Institusi", "Institusi", :text],
      ["UraianTugas", "Uraian Tugas", :multiline],
      ["Produk", "Produk", :text],
      ["StartDate", "Tanggal Mulai", :date],
      ["EndDate", "Tanggal Selesai", :date]
    ]
  },
  {
    key: "Plt",
    screen: "S2I_Profil_Plt_Form",
    source: "Profil_Plt",
    title: "PLT",
    fields: [
      ["JabatanPlt", "Jabatan PLT", :text],
      ["UnitKerja", "Unit Kerja", :text],
      ["PeriodeMulai", "Periode Mulai", :date],
      ["PeriodeSelesai", "Periode Selesai", :date],
      ["NoSK", "Nomor SK", :text],
      ["Skor", "Skor", :number],
      ["Catatan", "Catatan", :multiline]
    ]
  }
].freeze

def control_name(type, field, key)
  prefix = case type
           when :date then "Date"
           when :number then "Num"
           else "Txt"
           end
  "#{prefix}#{field}#{key}"
end

def default_value(form, field, type)
  key = form[:key]
  selected = "gblSelected#{key}"
  edit = "gbl#{key}EditMode"
  case type
  when :date
    "=If(Coalesce(#{edit}, false), Date(1899, 12, 30) + Value(#{selected}.#{field}), Today())"
  when :number
    "=If(Coalesce(#{edit}, false), Value(#{selected}.#{field}), 0)"
  else
    "=If(Coalesce(#{edit}, false), Coalesce(#{selected}.#{field}, \"\"), \"\")"
  end
end

def patch_value(form, field, type)
  control = control_name(type, field, form[:key])
  case type
  when :date
    "DateDiff(Date(1899, 12, 30), #{control}.SelectedDate, TimeUnit.Days)"
  when :number
    "Value(#{control}.Value)"
  else
    "Trim(#{control}.Value)"
  end
end

def blank_check(form, field, type)
  control = control_name(type, field, form[:key])
  case type
  when :date then "IsBlank(#{control}.SelectedDate)"
  when :number then "IsBlank(#{control}.Value)"
  else "IsBlank(Trim(#{control}.Value))"
  end
end

def field_yaml(form, field, label, type)
  key = form[:key]
  control = control_name(type, field, key)
  height = type == :multiline ? 118 : 76
  input = case type
          when :date
            <<~YAML
              - #{control}:
                  Control: ModernDatePicker@1.0.0
                  Properties:
                    AccessibleLabel: ="#{label}"
                    DefaultDate: #{default_value(form, field, type)}
                    Format: ="dd/mm/yyyy"
                    Placeholder: ="Pilih tanggal"
                    Width: =Parent.Width
            YAML
          when :number
            <<~YAML
              - #{control}:
                  Control: NumberInput@2.9.12
                  Properties:
                    AccessibleLabel: ="#{label}"
                    Value: #{default_value(form, field, type)}
                    Width: =Parent.Width
            YAML
          else
            mode = type == :multiline ? "TextInputModeMultiline" : "TextInputModeSingleLine"
            input_height = type == :multiline ? "\n      Height: =76" : ""
            <<~YAML
              - #{control}:
                  Control: TextInput@0.0.54
                  Properties:
                    AccessibleLabel: ="#{label}"#{input_height}
                    Mode: ="'TextInputCanvas.Mode'.#{mode}"
                    Value: #{default_value(form, field, type)}
                    Width: =Parent.Width
            YAML
          end
  input = input.lines.map { |line| "                              #{line}" }.join

  <<~YAML
                        - Field#{field}#{key}:
                            Control: GroupContainer@1.5.0
                            Variant: AutoLayout
                            Properties:
                              DropShadow: =DropShadow.None
                              FillPortions: =0
                              Height: =#{height}
                              LayoutDirection: =LayoutDirection.Vertical
                              LayoutGap: =6
                              LayoutMinHeight: =#{height}
                              Width: =Parent.Width
                            Children:
                              - Lbl#{field}#{key}:
                                  Control: ModernText@1.0.0
                                  Properties:
                                    AutoHeight: =true
                                    Color: =RGBA(50, 49, 48, 1)
                                    Font: =Font.'Open Sans'
                                    FontWeight: =FontWeight.Semibold
                                    Size: =12
                                    Text: ="#{label} *"
                                    Width: =Parent.Width
#{input}
  YAML
end

def form_yaml(form)
  key = form[:key]
  screen = form[:screen]
  source = form[:source]
  title = form[:title]
  selected = "gblSelected#{key}"
  edit = "gbl#{key}EditMode"
  submitting = "gbl#{key}Submitting"
  content_height = 300 + form[:fields].sum { |(_, _, type)| type == :multiline ? 136 : 94 }
  fields = form[:fields].map { |field, label, type| field_yaml(form, field, label, type) }.join
  checks = form[:fields].map { |field, _, type| "                                              #{blank_check(form, field, type)}" }.join(",\n")
  patch_fields = form[:fields].map { |field, _, type| "                                                          #{field}: #{patch_value(form, field, type)}" }.join(",\n")
  create_fields = form[:fields].map { |field, _, type| "                                                                      #{field}: #{patch_value(form, field, type)}" }.join(",\n")

  <<~YAML
    Screens:
      #{screen}:
        Properties:
          Fill: =RGBA(245, 245, 245, 1)
          LoadingSpinnerColor: =RGBA(31, 56, 100, 1)
        Children:
          - ScreenContainer#{key}Form:
              Control: GroupContainer@1.5.0
              Variant: AutoLayout
              Properties:
                Fill: =RGBA(245, 245, 245, 1)
                Height: =Parent.Height
                LayoutAlignItems: =LayoutAlignItems.Stretch
                LayoutDirection: =LayoutDirection.Vertical
                LayoutGap: =0
                Width: =Parent.Width
              Children:
                - Header#{key}Form:
                    Control: GroupContainer@1.5.0
                    Variant: AutoLayout
                    Properties:
                      DropShadow: =DropShadow.None
                      Fill: =RGBA(18, 38, 82, 1)
                      FillPortions: =0
                      Height: =64
                      LayoutAlignItems: =LayoutAlignItems.Center
                      LayoutDirection: =LayoutDirection.Horizontal
                      LayoutMinHeight: =64
                      PaddingLeft: =8
                      PaddingRight: =8
                      Width: =Parent.Width
                    Children:
                      - BtnBack#{key}Form:
                          Control: ModernText@1.0.0
                          Properties:
                            Align: =Align.Center
                            Color: =RGBA(255, 255, 255, 1)
                            Font: =Font.'Open Sans'
                            FontWeight: =FontWeight.Bold
                            Height: =64
                            OnSelect: |-
                              =Set(#{edit}, false);
                              Set(#{selected}, Defaults(#{source}));
                              Back()
                            Size: =24
                            Text: ="‹"
                            Width: =44
                      - LblAppName#{key}Form:
                          Control: ModernText@1.0.0
                          Properties:
                            Align: =Align.Center
                            Color: =RGBA(255, 255, 255, 1)
                            FillPortions: =1
                            Font: =Font.'Open Sans'
                            FontWeight: =FontWeight.Bold
                            Height: =64
                            Size: =16
                            Text: ="MyCareerApp"
                      - HeaderSpacer#{key}Form:
                          Control: Rectangle@2.3.0
                          Properties:
                            Fill: =RGBA(0, 0, 0, 0)
                            Height: =64
                            Width: =44
                - TopBarShadow#{key}Form:
                    Control: Rectangle@2.3.0
                    Properties:
                      BorderThickness: =0
                      Fill: =RGBA(0, 0, 0, 0.08)
                      Height: =5
                      Width: =Parent.Width
                - Main#{key}Form:
                    Control: GroupContainer@1.5.0
                    Variant: AutoLayout
                    Properties:
                      DropShadow: =DropShadow.None
                      LayoutAlignItems: =LayoutAlignItems.Stretch
                      LayoutDirection: =LayoutDirection.Vertical
                      LayoutMinHeight: =16
                      LayoutOverflowY: =LayoutOverflow.Scroll
                      PaddingBottom: =16
                      PaddingLeft: =16
                      PaddingRight: =16
                      PaddingTop: =16
                      Width: =Parent.Width
                    Children:
                      - Card#{key}Form:
                          Control: GroupContainer@1.5.0
                          Variant: AutoLayout
                          Properties:
                            BorderColor: =RGBA(225, 223, 221, 1)
                            BorderStyle: =BorderStyle.Solid
                            BorderThickness: =1
                            DropShadow: =DropShadow.None
                            Fill: =RGBA(255, 255, 255, 1)
                            FillPortions: =0
                            Height: =#{content_height}
                            LayoutDirection: =LayoutDirection.Vertical
                            LayoutGap: =18
                            LayoutMinHeight: =#{content_height}
                            PaddingBottom: =28
                            PaddingLeft: =28
                            PaddingRight: =28
                            PaddingTop: =24
                            RadiusBottomLeft: =8
                            RadiusBottomRight: =8
                            RadiusTopLeft: =8
                            RadiusTopRight: =8
                            Width: =Parent.Width
                          Children:
                            - Title#{key}Form:
                                Control: ModernText@1.0.0
                                Properties:
                                  AutoHeight: =true
                                  Color: =RGBA(31, 56, 100, 1)
                                  Font: =Font.'Open Sans'
                                  FontWeight: =FontWeight.Bold
                                  Size: =20
                                  Text: =If(Coalesce(#{edit}, false), "Edit #{title}", "Tambah #{title}")
                                  Width: =Parent.Width
                            - Subtitle#{key}Form:
                                Control: ModernText@1.0.0
                                Properties:
                                  AutoHeight: =true
                                  Color: =RGBA(96, 94, 92, 1)
                                  Font: =Font.'Open Sans'
                                  Size: =12
                                  Text: |-
                                    ="Pegawai: " &
                                    Coalesce(
                                        LookUp(
                                            Pegawai,
                                            Title = Text(If(Coalesce(gblPimpinanView, false), gblSubjectNIP, gblCurrentNIP)),
                                            Nama
                                        ),
                                        Text(If(Coalesce(gblPimpinanView, false), gblSubjectNIP, gblCurrentNIP))
                                    )
                                  Width: =Parent.Width
                            - Divider#{key}Form:
                                Control: Rectangle@2.3.0
                                Properties:
                                  Fill: =RGBA(225, 223, 221, 1)
                                  Height: =1
                                  Width: =Parent.Width
    #{fields}
                            - FormActions#{key}:
                                Control: GroupContainer@1.5.0
                                Variant: AutoLayout
                                Properties:
                                  DropShadow: =DropShadow.None
                                  FillPortions: =0
                                  Height: =48
                                  LayoutDirection: =LayoutDirection.Horizontal
                                  LayoutGap: =12
                                  LayoutJustifyContent: =LayoutJustifyContent.End
                                  LayoutMinHeight: =48
                                  Width: =Parent.Width
                                Children:
                                  - BtnBatal#{key}:
                                      Control: ModernText@1.0.0
                                      Properties:
                                        Align: =Align.Center
                                        BorderColor: =RGBA(200, 198, 196, 1)
                                        BorderStyle: =BorderStyle.Solid
                                        BorderThickness: =1
                                        Color: =RGBA(50, 49, 48, 1)
                                        Font: =Font.'Open Sans'
                                        FontWeight: =FontWeight.Semibold
                                        Height: =44
                                        OnSelect: |-
                                          =Set(#{edit}, false);
                                          Set(#{selected}, Defaults(#{source}));
                                          Back()
                                        RadiusBottomLeft: =6
                                        RadiusBottomRight: =6
                                        RadiusTopLeft: =6
                                        RadiusTopRight: =6
                                        Size: =12
                                        Text: ="Batal"
                                        Width: =110
                                  - BtnSimpan#{key}:
                                      Control: ModernText@1.0.0
                                      Properties:
                                        Align: =Align.Center
                                        Color: =RGBA(255, 255, 255, 1)
                                        DisplayMode: =If(Coalesce(#{submitting}, false), DisplayMode.Disabled, DisplayMode.Edit)
                                        Fill: =RGBA(18, 38, 82, 1)
                                        Font: =Font.'Open Sans'
                                        FontWeight: =FontWeight.Semibold
                                        Height: =44
                                        OnSelect: |-
                                          =If(
                                              Or(
    #{checks}
                                              ),
                                              Notify(
                                                  "Lengkapi seluruh field #{title}.",
                                                  NotificationType.Warning
                                              ),
                                              !Coalesce(#{submitting}, false),
                                              Set(#{submitting}, true);
                                              IfError(
                                                  If(
                                                      Coalesce(#{edit}, false),
                                                      Patch(
                                                          #{source},
                                                          #{selected},
                                                          {
                                                              NIP: #{selected}.NIP,
    #{patch_fields}
                                                          }
                                                      ),
                                                      With(
                                                          {
                                                              newRecord:
                                                                  Patch(
                                                                      #{source},
                                                                      Defaults(#{source}),
                                                                      {
                                                                          Title: "TEMP_" & Text(GUID()),
                                                                          NIP: Text(If(Coalesce(gblPimpinanView, false), gblSubjectNIP, gblCurrentNIP)),
    #{create_fields}
                                                                      }
                                                                  )
                                                          },
                                                          Patch(
                                                              #{source},
                                                              newRecord,
                                                              {Title: Text(newRecord.ID)}
                                                          )
                                                      )
                                                  );
                                                  Refresh(#{source});
                                                  Notify(
                                                      If(Coalesce(#{edit}, false), "Data #{title} berhasil diperbarui.", "Data #{title} berhasil ditambahkan."),
                                                      NotificationType.Success
                                                  );
                                                  Set(#{submitting}, false);
                                                  Set(#{edit}, false);
                                                  Set(#{selected}, Defaults(#{source}));
                                                  Navigate(S2_ProfilPegawai, ScreenTransition.Fade),
                                                  Notify(
                                                      "Gagal menyimpan data #{title}: " & FirstError.Message,
                                                      NotificationType.Error
                                                  );
                                                  Set(#{submitting}, false)
                                              )
                                          )
                                        RadiusBottomLeft: =6
                                        RadiusBottomRight: =6
                                        RadiusTopLeft: =6
                                        RadiusTopRight: =6
                                        Size: =12
                                        Text: =If(Coalesce(#{submitting}, false), "Menyimpan...", "Simpan")
                                        Width: =130
  YAML
end

FORMS.each do |form|
  path = File.join(OUTPUT, "#{form[:screen]}.yaml")
  File.write(path, form_yaml(form))
  puts "generated #{path}"
end
