#!/usr/bin/env ruby
require 'csv'

puts "=" * 80
puts "Testing Response 1 Code Snippets"
puts "=" * 80

# Test 1: Basic CSV.foreach with headers: true
puts "\n[Test 1] Basic CSV.foreach with headers: true"
puts "-" * 80
begin
  CSV.foreach('test_csv_data.csv', headers: true) do |row|
    puts "Row class: #{row.class}"
    puts "Row: #{row.inspect}"
    puts "Access by key: row['name'] = #{row['name']}"
    break  # Just show first row
  end
  puts "✅ PASS: Basic CSV.foreach works"
rescue => e
  puts "❌ FAIL: #{e.class} - #{e.message}"
end

# Test 2: Duplicate headers parameter (from Response 1's parse_csv)
puts "\n[Test 2] Duplicate headers: parameter"
puts "-" * 80
begin
  CSV.foreach('test_csv_data.csv', headers: true, headers: %w[name code continent]) do |row|
    puts "Row: #{row.inspect}"
    break
  end
  puts "⚠️  WARNING: Code runs but Ruby shows warning about duplicate parameter"
rescue => e
  puts "❌ FAIL: #{e.class} - #{e.message}"
end

# Test 3: CSV::Row#to_hash.symbolize_keys WITHOUT ActiveSupport
puts "\n[Test 3] CSV::Row#to_hash.symbolize_keys (without ActiveSupport)"
puts "-" * 80
begin
  CSV.foreach('test_csv_data.csv', headers: true) do |row|
    hash = row.to_hash
    puts "Hash: #{hash.inspect}"
    puts "Has symbolize_keys method?: #{hash.respond_to?(:symbolize_keys)}"
    symbolized = hash.symbolize_keys  # This should fail
    puts "Symbolized: #{symbolized.inspect}"
    break
  end
  puts "✅ PASS: symbolize_keys works"
rescue NoMethodError => e
  puts "❌ FAIL: #{e.class} - #{e.message}"
  puts "   This is expected in plain Ruby without Rails/ActiveSupport"
end

# Test 4: CSV.foreach return value (for parse_csv method issue)
puts "\n[Test 4] CSV.foreach return value"
puts "-" * 80
result = CSV.foreach('test_csv_data.csv', headers: true) do |row|
  # Processing rows
end
puts "CSV.foreach returns: #{result.inspect}"
puts "Return type: #{result.class}"
puts "Can call .each on it?: #{result.respond_to?(:each)}"
if result.respond_to?(:each)
  puts "✅ PASS: Can iterate over result"
else
  puts "❌ FAIL: Cannot iterate over result (parse_csv.each will fail)"
end

# Test 5: Response 1's CsvImporterService (with bugs)
puts "\n[Test 5] Response 1's CsvImporterService implementation"
puts "-" * 80

class CsvImporterServiceR1
  def initialize(csv_path:, model:, headers: %w[name code])
    @csv_path   = csv_path
    @model      = model
    @headers    = headers
  end

  def call
    parse_csv.each do |row_hash|
      puts "Would create: #{row_hash}"
    end
  end

  private

  def parse_csv
    # This is the exact code from Response 1
    CSV.foreach(csv_path, headers: true, headers: @headers) do |row|
      # Convert CSV::Row → Hash with indifferent access
      row.to_hash.symbolize_keys
    end
  end
end

begin
  service = CsvImporterServiceR1.new(
    csv_path: 'test_csv_data.csv',
    model: nil
  )
  service.call
  puts "✅ PASS: Service works"
rescue => e
  puts "❌ FAIL: #{e.class} - #{e.message}"
  puts "   Error location: #{e.backtrace.first}"
end

# Test 6: Variable name issue (csv_path vs @csv_path)
puts "\n[Test 6] Variable name issue in parse_csv"
puts "-" * 80
puts "Issue: parse_csv uses 'csv_path' but should use '@csv_path'"
puts "This causes NameError: undefined local variable or method"
puts "❌ CONFIRMED BUG"

puts "\n" + "=" * 80
puts "Summary: Response 1 has multiple code bugs"
puts "=" * 80
