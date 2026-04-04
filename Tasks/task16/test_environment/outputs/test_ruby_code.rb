#!/usr/bin/env ruby

puts "=== TEST 4: Pod::MaterialPodfileDefaults (AOI #4) ==="
puts "Code: require 'cocoapods'; Pod::MaterialPodfileDefaults.new([:android, :ios]).apply"
begin
  require 'cocoapods'
  Pod::MaterialPodfileDefaults.new([:android, :ios]).apply
  puts "SUCCESS: Code executed without errors"
rescue => e
  puts "ERROR: #{e.class}"
  puts "#{e.message}"
  puts ""
  puts "Full error:"
  puts e.backtrace.first(3).join("\n")
end

puts ""
puts "=== TEST 5: UIHostedViewController.isSimulator (AOI #7) ==="
puts "Code: UIHostedViewController.isSimulator"
begin
  result = UIHostedViewController.isSimulator
  puts "SUCCESS: #{result}"
rescue => e
  puts "ERROR: #{e.class}"
  puts "#{e.message}"
  puts ""
  puts "Full error:"
  puts e.backtrace.first(3).join("\n")
end
