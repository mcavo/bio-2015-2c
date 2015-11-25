#!/usr/bin/env ruby

require 'bio'

if ARGV.length != 2
  puts 'FATAL ERROR: Invalid amount of arguments!'
  puts 'Example: ruby Ex3.rb sequences/59S2KXK501R-Alignment.xml homo'
  exit
end

pattern = ARGV[1].upcase

Bio::NCBI.default_email = '@'

Dir.mkdir("output") unless File.exists?("output")
File.open('output/Ex3.txt', 'w') do |f|
  f.puts "Pattern: #{pattern}"
  Bio::Blast.reports_xml(File.new(ARGV[0])) do |report|
    report.each do |hit|
      if hit.definition.upcase.index(pattern)
        f.puts '________________________________________________'
        f.puts " * Definition: #{hit.definition}"
        f.puts " * Accession: #{hit.accession}"
        f.write ' * Fasta sequence: '
        f.puts Bio::NCBI::REST::EFetch.protein(hit.accession, 'fasta')
      end
    end
  end
end