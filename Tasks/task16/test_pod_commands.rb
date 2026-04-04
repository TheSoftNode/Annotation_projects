#!/usr/bin/env ruby

# Explicitly require logger before activesupport loads
require 'logger'

# Now load CocoaPods
require 'cocoapods'

# Test the exact commands from Response 2
commands = [
  "pod ipc FirebaseAuth",
  "pod lib lint FirebaseAuth --verbose",
  "pod dependency tree --plain"
]

commands.each do |cmd|
  puts "\n" + "="*80
  puts "EXECUTING: #{cmd}"
  puts "="*80
  system(cmd)
  puts "\nEXIT CODE: #{$?.exitstatus}"
end
