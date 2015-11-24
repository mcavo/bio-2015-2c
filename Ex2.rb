require 'bio'

# ruby Ex2.rb remote sequences/cftr-hs-t.fasta

if ARGV.length != 2
  raise "Error: Invalid amount of arguments!"
end

if ARGV[0]!='local' && ARGV[0]!='remote'
  raise "Error: Firt argument must be remote or local!"
end

aux = ARGV[1].split(".")
if aux.length!=2
  raise "Error: Invalid file name! Must have a .fa, .fsa, .fna, .mpfa or .fasta extension"
end

auxaux = aux[0].split("/")
file_name = auxaux.last
file_extension = aux[1]

if file_extension!="fa" && file_extension!="fasta" && file_extension!="mpfa" && file_extension!="fna" && file_extension!="fsa"
  raise "Error: Invalid file extension! Must have a .fa, .fsa, .fna, .mpfa or .fasta extension"
end



fasta_content = Bio::FlatFile.open(Bio::FastaFormat, ARGV[1])
if ARGV[0]=='remote'
  blast = Bio::Blast.remote("blastn", "dbsts", "-e 0.0001", "genomenet")
  Dir.mkdir("output") unless File.exists?("output")
  File.open("output/#{file_name}_remote.blast", "w") do |f|
    fasta_content.each_entry do |fc|
      $stderr.puts "Searching ... "+fc.definition
      f.puts '*************************************************************************************'
      f.puts fc.definition
      f.puts '*************************************************************************************'
      report = blast.query(fc.seq)
      report.hits.each_entry do |hit|
        f.puts "Hit num: #{hit.num}"
        f.puts hit.accession  
        f.puts hit.definition
        f.puts "Query length: #{hit.len} - Identities number: #{hit.identity}"
        f.puts "Overlapping: #{hit.overlap} - Overlapping: #{hit.percent_identity}"
        f.puts '_____________________________________________________________________________________'
        hit.hsps.each_with_index do |hsps, hsps_index|
          f.puts "Score: #{hsps.score} - Bit score: #{hsps.bit_score} - Evalue: #{hsps.evalue} - Length: #{hsps.align_len}/#{hit.len} - Gaps: #{hsps.gaps}"
          f.puts "Query: #{hsps.qseq}"
          aux = "       "
          hsps.qseq.length.times do |n|
            if hsps.qseq[n]==hsps.hseq[n]
              aux << "|"
            else
              aux << " "
            end
          end
          f.puts aux
          f.puts "Sject: #{hsps.hseq}"
        end
        f.puts '_____________________________________________________________________________________'
        f.puts '_____________________________________________________________________________________'
      end
    end
  end
else
end