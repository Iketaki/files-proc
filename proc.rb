require 'yajl'

md5_dbfile = "count.csv"
result_file = "md5_txt"
out_file = "structure.json"

md5_db = {}

puts "Make hashtable from md5_dbfile: #{md5_dbfile}"

open(md5_dbfile) { |file|
  while l = file.gets
    md5, count = l.strip.split(',')
    md5_db[md5] = count
  end
}

md5_hash = {}

# Write file structure to file
puts "Make file structure from #{result_file}"
structure = {
  n: "root",
  children: []
}

open(result_file) { |file|
  while l = file.gets
    md5, path = l.strip.split("\t")
    size = FileTest.size?(path) || 0

    # limit files to visualize
    next if size < 100000

    elems = path.split('/')

    cur = structure
    elems[1..-2].each do |elem|
      c = cur[:children].find{|e|e[:n]==elem}
      if c
        cur = c
      else
        cur[:children] << {n: elem, children: []}
        cur = cur[:children][-1]
      end
    end
    cur[:children] << {n: elems[-1], l: md5_db[md5], s: size}
  end
}

puts "Convert to JSON"
json = Yajl::Encoder.encode(structure)

puts "Write JSON to file"
File.write(out_file, json)
