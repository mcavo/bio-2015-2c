require 'bio'

if ARGV.length != 2
  raise 'Invalid amount of arguments!'
end

file_name = ARGV[0].to_s
file_len = file_name.length

prune_parameter = ARGV[1].to_s

if file_len < 4 || (!file_name[file_len-3,3]==".fa" && !(file_len>7 && !file_name[file_len-6,6]==".fasta"))
  raise "Invalid file extension! Must be .fasta or .fa"
end

if prune_parameter != "prune" && (prune_parameter != "noprune")
	raise "Invalid prune parameter. It should be 'prune' or 'noprune'"
end

#get orfs from sequence
orfs_string = Bio::EMBOSS.run('getorf', '-sequence', file_name)

#set prosite location for emboss
Bio::EMBOSS.run('prosextract', '-prositedir', 'database/')

#compare each orf with database domains.
orfs_lines = orfs_string.split(/\n+/)
not_first = false;
mid_string = ''
pat_string = ''
(orfs_lines.length).times do |i|
	if (orfs_lines[i].start_with?('>') && not_first)
		File.open("momentaneo", "w") do |m|
			m.write(mid_string)
		end
		mid_string = orfs_lines[i]
		mid_string << "\n"
		result_patmatmotifs = Bio::EMBOSS.run('patmatmotifs', '-full', '-sequence', 'momentaneo', '-' + prune_parameter)		

		#only save mathces
		unless result_patmatmotifs.include? "# HitCount: 0" 
			pat_string << result_patmatmotifs
			pat_string << "\n\n"
		end
	else
		not_first = true;
		mid_string << orfs_lines[i];
		mid_string << "\n"
	end

end


File.delete("momentaneo") if File.exists?("momentaneo")
File.delete("output/Ex4") if File.exists?("output/Ex4")

#write answer file with the concat of al the 
File.open("output/Ex4", 'w') do |f|
		f.write(pat_string)
end
