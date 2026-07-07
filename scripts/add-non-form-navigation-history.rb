require "yaml"

ROOT = File.expand_path("../MyCareerApp/fixed", __dir__)
TRACKING_MARKER = "colNonFormNavigationHistory"

def formula_property(name, value, indent)
  body = value.lines.map { |line| "#{indent}  #{line.rstrip}\n" }.join
  "#{indent}#{name}: |-\n#{body}"
end

def upsert_screen_property(text, property, value)
  properties_start = text.index("    Properties:\n")
  raise "Screen Properties block not found" unless properties_start

  children_start = text.index("    Children:\n", properties_start)
  raise "Screen Children block not found" unless children_start

  prefix = text[properties_start...children_start]
  property_pattern = /^      #{Regexp.escape(property)}:.*(?:\n(?=      \S|    Children:)|\z)/m
  replacement = formula_property(property, value, "      ")

  if prefix.match?(property_pattern)
    prefix.sub!(property_pattern, replacement)
  else
    prefix << replacement
  end

  text[properties_start...children_start] = prefix
  text
end

Dir[File.join(ROOT, "*.yaml")].sort.each do |path|
  parsed = YAML.load_file(path)
  screen_name, screen = parsed.fetch("Screens").first
  next if screen_name.downcase.include?("form")

  existing = screen.fetch("Properties", {})["OnVisible"].to_s
  next if existing.include?(TRACKING_MARKER)

  tracking = <<~POWERFX.chomp
    =If(
        IsEmpty(colNonFormNavigationHistory) ||
        Last(colNonFormNavigationHistory).ScreenName <> App.ActiveScreen.Name,
        Collect(
            colNonFormNavigationHistory,
            {
                ScreenName: App.ActiveScreen.Name,
                ScreenRef: App.ActiveScreen
            }
        )
    );
  POWERFX

  existing_body = existing.sub(/\A=/, "").strip
  tracking = "#{tracking}\n#{existing_body}" unless existing_body.empty?
  File.write(path, upsert_screen_property(File.read(path), "OnVisible", tracking))
end
