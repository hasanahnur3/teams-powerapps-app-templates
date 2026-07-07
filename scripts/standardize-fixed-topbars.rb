require "yaml"

ROOT = File.expand_path("../MyCareerApp/fixed", __dir__)

def formula_yaml(value, indent)
  return "#{indent}OnSelect: =Back()\n" if value.nil? || value.empty?
  if value.include?("\n")
    lines = value.lines.map { |line| "#{indent}  #{line.rstrip}\n" }.join
    "#{indent}OnSelect: |-\n#{lines}"
  else
    "#{indent}OnSelect: #{value}\n"
  end
end

def smart_back_formula(value)
  if value&.include?("colNonFormNavigationHistory")
    normalized = value.sub(/\A=\s*\n=If\(/, "=If(")
    normalized.sub!(/\n=If\(/, "\nIf(") unless normalized.start_with?("=If(")
    return normalized
  end

  cleanup = value.to_s.sub(/Back\(\)\s*\z/, "").rstrip.sub(/=\s*\z/, "").rstrip
  has_cleanup = !cleanup.empty?
  cleanup = "#{cleanup}\n" if has_cleanup
  smart_formula = <<~POWERFX.chomp
    =If(
        IsMatch(App.ActiveScreen.Name, "form", MatchOptions.IgnoreCase),
        If(
            !IsEmpty(colNonFormNavigationHistory),
            Navigate(Last(colNonFormNavigationHistory).ScreenRef, ScreenTransition.Fade),
            Back()
        ),
        If(
            CountRows(colNonFormNavigationHistory) > 1,
            Remove(colNonFormNavigationHistory, Last(colNonFormNavigationHistory));
            Navigate(Last(colNonFormNavigationHistory).ScreenRef, ScreenTransition.Fade),
            Back()
        )
    )
  POWERFX
  smart_formula.sub!(/\A=/, "") if has_cleanup
  smart_formula.prepend(cleanup)
end

def canonical_topbar(header_name, back_name, title_name, spacer_name, shadow_name, on_select)
  template = <<~YAML
    - #{header_name}:
        Control: GroupContainer@1.5.0
        Variant: AutoLayout
        Properties:
          Fill: =RGBA(31, 48, 112, 1)
          FillPortions: =0
          Height: =75
          LayoutAlignItems: =LayoutAlignItems.Center
          LayoutDirection: =LayoutDirection.Horizontal
          LayoutMinHeight: =75
          PaddingBottom: =8
          PaddingLeft: =8
          PaddingRight: =8
          PaddingTop: =8
          RadiusBottomLeft: =8
          RadiusBottomRight: =8
          RadiusTopLeft: =8
          RadiusTopRight: =8
          Width: =Parent.Width
        Children:
          - #{back_name}:
              Control: ModernText@1.0.0
              Properties:
                Align: =Align.Center
                Color: =RGBA(255, 255, 255, 1)
                Font: =Font.'Open Sans'
                FontWeight: =FontWeight.Bold
                Height: =40
                __ONSELECT__
                Size: =22
                Text: ="‹"
                Width: =40
          - #{title_name}:
              Control: ModernText@1.0.0
              Properties:
                Align: =Align.Center
                Color: =RGBA(255, 255, 255, 1)
                FillPortions: =1
                Font: =Font.'Open Sans'
                FontWeight: =FontWeight.Bold
                Height: =40
                Size: =18
                Text: ="MyCareerApp"
          - #{spacer_name}:
              Control: ModernText@1.0.0
              Properties:
                AccessibleLabel: ="Kembali ke Homepage"
                Align: =Align.Center
                Color: =RGBA(255, 255, 255, 1)
                Font: =Font.'Open Sans'
                FontWeight: =FontWeight.Bold
                Height: =40
                OnSelect: |-
                  =Set(gblPimpinanView, false);
                  Set(gblSubjectNIP, Blank());
                  Set(gblChecklistAdminView, false);
                  Clear(colNonFormNavigationHistory);
                  Navigate(S1_Homepage, ScreenTransition.Fade)
                Size: =20
                Text: ="⌂"
                Width: =40
    - #{shadow_name}:
        Control: Rectangle@2.3.0
        Properties:
          Fill: =RGBA(0, 0, 0, 0)
          FillPortions: =0
          Height: =0
          LayoutMinHeight: =0
          Width: =Parent.Width
  YAML
  on_select_yaml = formula_yaml(on_select, "").strip.gsub("\n", "\n                ")
  template.sub!("__ONSELECT__", on_select_yaml)
  template.gsub(/^/, "            ")
end

Dir[File.join(ROOT, "*.yaml")].sort.each do |path|
  next if File.basename(path) == "S1_Homepage.yaml"

  parsed = YAML.load_file(path)
  screen = parsed.fetch("Screens").values.first
  screen_children = screen.fetch("Children")
  container_name, container = screen_children.first.first
  children = container.fetch("Children")
  header_name, header = children.first.first
  header_children = header.fetch("Children")

  unless header_children.length >= 3
    raise "Unexpected header structure in #{path}: #{header_name}"
  end

  back_name, back = header_children[0].first
  title_name = header_children[1].keys.first
  spacer_name = header_children[2].keys.first
  on_select = smart_back_formula(back.fetch("Properties", {})["OnSelect"])

  second_name = children[1]&.keys&.first
  has_shadow = second_name&.downcase&.include?("shadow")
  shadow_name = has_shadow ? second_name : "#{header_name}Shadow"
  main_index = has_shadow ? 2 : 1
  main_name = children[main_index]&.keys&.first
  raise "Main content not found in #{path}" unless main_name

  text = File.read(path)
  lines = text.lines
  start_index = lines.index { |line| line == "            - #{header_name}:\n" }
  raise "Header text not found in #{path}: #{header_name}" unless start_index

  next_sibling = (start_index + 1...lines.length).find do |index|
    lines[index].match?(/^            - /)
  end
  raise "Header end not found in #{path}: #{header_name}" unless next_sibling

  end_index = next_sibling
  if has_shadow && lines[next_sibling] == "            - #{shadow_name}:\n"
    following_sibling = (next_sibling + 1...lines.length).find do |index|
      lines[index].match?(/^            - /)
    end
    raise "Shadow end not found in #{path}: #{shadow_name}" unless following_sibling
    end_index = following_sibling
  end

  replacement = canonical_topbar(
    header_name,
    back_name,
    title_name,
    spacer_name,
    shadow_name,
    on_select
  ).lines
  lines[start_index...end_index] = replacement
  text = lines.join

  container_start = text.index("      - #{container_name}:\n")
  header_start = text.index("            - #{header_name}:\n", container_start)
  container_prefix = text[container_start...header_start]
  layout_gap_pattern = /^(            LayoutGap:) =?.*$/
  if container_prefix.match?(layout_gap_pattern)
    container_prefix.gsub!(layout_gap_pattern, "\\1 =16")
  else
    children_marker = container_prefix.index("          Children:\n")
    container_prefix.insert(children_marker, "            LayoutGap: =16\n")
  end
  %w[PaddingBottom PaddingLeft PaddingRight PaddingTop].each do |property|
    pattern = /^(            #{property}:) =?.*$/
    if container_prefix.match?(pattern)
      container_prefix.gsub!(pattern, "\\1 =16")
    else
      children_marker = container_prefix.index("          Children:\n")
      container_prefix.insert(children_marker, "            #{property}: =16\n")
    end
  end
  text[container_start...header_start] = container_prefix

  main_start = text.index("            - #{main_name}:\n", header_start)
  raise "Main content text not found in #{path}: #{main_name}" unless main_start
  main_children = text.index("                Children:\n", main_start)
  raise "Main content children not found in #{path}: #{main_name}" unless main_children
  main_prefix = text[main_start...main_children]
  %w[PaddingBottom PaddingLeft PaddingRight PaddingTop].each do |property|
    pattern = /^(                  #{property}:) =?.*$/
    if main_prefix.match?(pattern)
      main_prefix.gsub!(pattern, "\\1 =8")
    else
      properties_end = main_prefix.index("                Children:\n")
      main_prefix << "                  #{property}: =8\n"
    end
  end
  text[main_start...main_children] = main_prefix

  File.write(path, text)
end
