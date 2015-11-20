require 'bio'
require 'bio/db'
require 'bio/db/genbank/common'
require 'bio/sequence'
require 'bio/sequence/dblink'

pattern = ARGV[1].upcase

Bio::NCBI.default_email = '@'

# f - File
# r - Report
# h - hit

File.open('Exercise3.out', 'w') do |f|
  f.puts "Pattern: #{pattern}"
  Bio::Blast.reports_xml(File.new(ARGV[0])) do |r|
    r.each do |h|
      if h.definition.upcase.index(pattern)
        f.puts '=============================================='
        f.puts " * Definition: #{h.definition}"
        f.puts " * Accession: #{h.accession}"
        f.write ' * Fasta sequence: '
        # f.puts Bio::NCBI::REST::EFetch.protein(h.accession, 'fasta')
        gb = Bio::GenBank.new(h.accession)
        f.puts "**************************"
        f.puts gb
      end
    end
  end
end