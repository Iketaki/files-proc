md5_files = "./md5s/*.txt"
out_file = "count.csv"

md5_hash = {}

Dir.glob(md5_files) do |filename|
  puts "processing " + filename

  open(filename) { |file|
    while l = file.gets
      md5 = l.strip.split("\t")[0]
      if md5_hash.has_key? md5
        md5_hash[md5] += 1
      else
        md5_hash[md5] = 1
      end
    end
  }
end

puts "write result to #{out_file}"

out = md5_hash.map{|k,v| "#{k},#{v}"}.join("\n") + "\n"
open(out_file, "w") {|f| f.write out}
