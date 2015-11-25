require 'bio'

if ARGV.length != 1
  raise 'ERROR: Invalid amount of arguments!'
end

file_name = ARGV[0].to_s
file_len = file_name.length

if file_len < 4 || (!file_name[file_len-3,3]==".gb" && !(file_len>4 && file_name[file_len-4,4]==".gbk")) 
  raise "ERROR: Invalid file extension! Must be .gb or .gbk"
end

genbank_content = Bio::GenBank.open(file_name)

file_split = file_name.split("/")
file_name = file_split.last

string_sequence = ''

genbank_content.each_entry do |gc|
  string_sequence << gc.to_biosequence
end

6.times do |frame|
  Dir.mkdir("output") unless File.exists?("output")
  File.open("output/#{file_name}-frame#{frame + 1}.fasta", 'w') do |f|
    f.write(Bio::Sequence::NA.new(string_sequence).translate(frame + 1,1,'_').to_fasta)
  end
end