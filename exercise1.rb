require 'bio'

gbEntries = Bio::FlatFile.open(Bio::GenBank,'sequences/mouse-cftr-cd-complete.gb')
gbEntries.each do |entry|
  # gbEntry Bio::GenBank
  id = entry.entry_id
  #puts seq.first_name
  #puts 'definition '+seq.definition
  #puts 'comment '+seq.comment
  #puts 'accession '+seq.accession
  #puts 'accessions '+seq.accessions
  seq = entry.seq
  #puts seq.data
  #puts 'length '+seq.length.to_s
  naseq = entry.naseq
  puts 'naseq: '+naseq.to_fasta(id)
  aaseq = entry.naseq.translate
  puts 'aaseq: '+aaseq.to_fasta(id)
end