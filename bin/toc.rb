#!/usr/bin/env ruby
# frozen_string_literal: true


file_name = 'docs/index.md'

File.open(file_name, 'r') do |f|
  inside_code_snippet = false
  f.each_line do |line|
    forbidden_words = ['Table of contents', 'define', 'pragma']
    inside_code_snippet = !inside_code_snippet if line.start_with?('```')
    next if !line.start_with?('#') || forbidden_words.any? { |w| line =~ /#{w}/ } || inside_code_snippet

    title = line.gsub('#', '').strip
    href = title.gsub(' ', '-').downcase
    puts '  ' * (line.count('#') - 1) + "* [#{title}](\##{href})"
  end
end
