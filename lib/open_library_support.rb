class OpenLibrarySupport 

  attr_reader :authors_path, :works_path, :editions_path

  def initialize path
    entries = Dir.glob(File.join(path, "*.txt"))
    @authors_path = entries.select {|s| s =~ /authors/ }.first
    @works_path = entries.select {|s| s =~ /works/ }.first
    @editions_path = entries.select {|s| s =~ /editions/ }.first
    pp [ authors_path, works_path, editions_path ].inspect
  end


  def read_authors
    cnt = 0
    hash = Hash.new {|hash, key| hash[key] = 0 }
    File.open(authors_path) do |f|
      while line = f.gets
        cnt += 1
        parse_line(line)[3].keys.each {|k| hash[k] += 1 }
        if cnt % 100_000 == 0
          pp cnt
          pp hash.inspect
        end
      end
    end
    pp hash.inspect
  end

  def read_works
    cnt = 0
    hash = Hash.new {|hash, key| hash[key] = 0 }
    File.open(works_path) do |f|
      while line = f.gets
        cnt += 1
        parse_line(line)[3].keys.each {|k| hash[k] += 1 }
        if cnt % 100_000 == 0
          pp cnt
          pp hash.inspect
        end
      end
    end
    pp hash
  end

  def read_editions
    cnt = 0
    hash = Hash.new {|hash, key| hash[key] = 0 }
    File.open(editions_path) do |f|
      while line = f.gets
        cnt += 1
        parse_line(line)[3].keys.each {|k| hash[k] += 1 }
        if cnt % 100_000 == 0
          pp cnt
          pp hash.inspect
        end
      end
    end
    pp hash
  end

  def parse_line line
    row = line.split("\t")
    [ open_library_id(row[1]), Integer(row[2]), DateTime.parse(row[3]), JSON.parse(row[4]) ]
  end

  def open_library_id str
    str.split('/').last
  end

end

