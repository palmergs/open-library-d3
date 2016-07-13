require 'counter'

class OpenLibrarySupport 

  attr_reader :base_path
  
  BATCH_SIZE = 1000

  def initialize path
    @base_path = path
  end

  def read_file path
    sum, cnt = 0, 0
    File.open(path) do |f|
      while line = f.gets
        cnt += 1
        sum += 1
        yield(line)
        if cnt > BATCH_SIZE
          save_all
          cnt = 0
        end
      end

      if cnt > 0
        save_all
        cnt = 0
      end
    end
    sum
  end

  def save_all
    raise "This must be defined in a subclass"
  end

  def save_links clazz, links
    cnt = 0
    links.each_pair do |ident, new_links|
      parent = clazz.find_by(ident: ident)
      if parent
        inserts = []
        new_links.each do |link|
          arr = [ parent.id, 
                  str_val(clazz.name), 
                  str_val(link[:name][0..23]), 
                  str_val(link[:value]),
                  str_val(DateTime.now.to_s),
                  str_val(DateTime.now.to_s) ]
          inserts << "(#{ arr.join(', ') })"
        end
        
        if inserts.count > 0
          cnt += inserts.count
          sql = "INSERT INTO external_links (linkable_id, linkable_type, name, value, created_at, updated_at) VALUES #{ inserts.join(', ') }"
          SubjectTag.connection.execute( sql )
        end
      end
    end
    pp ". inserted #{ cnt } #{ clazz.name.downcase } links"
    cnt
  end

  def save_tags clazz, tags
    cnt = 0
    tags.each_pair do |ident, new_tags|
      parent = clazz.find_by(ident: ident)
      if parent
        inserts = []
        new_tags.each do |tag|
          arr = [ parent.id, 
                  str_val(clazz.name), 
                  str_val(tag[:name][0..23]), 
                  str_val(tag[:value]),
                  str_val(DateTime.now.to_s),
                  str_val(DateTime.now.to_s) ]
          inserts << "(#{ arr.join(', ') })"
        end

        if inserts.count > 0
          cnt += inserts.count
          sql = "INSERT INTO subject_tags (taggable_id, taggable_type, name, value, created_at, updated_at) VALUES #{ inserts.join(', ') }"
          SubjectTag.connection.execute( sql )
        end
      end
    end
    pp ". inserted #{ cnt } #{ clazz.name.downcase } links"
    cnt
  end

  def str_val str
    return 'NULL' unless str
    "'#{ str.gsub("'", "''") }'"
  end

  def num_val num
    return 'NULL' unless num
    num.to_s
  end

  def add_tag array, hash, key, category = nil
    return unless hash && hash[key]

    category ||= key
    value = str_or_value(hash[key])
    array << { name: category, value: value } if value.present?
  end

  def add_tags array, hash, key, category = nil
    return unless hash && hash[key] 

    category ||= key
    arr = hash[key]
    if arr.is_a?(Array)
      arr.each do |entry|
        value = str_or_value(entry)
        array << { name: category, value: value } if value.present?
      end
    end
  end

  def str_or_value entry, key = 'value'
    return nil unless entry

    str = entry.is_a?(Hash) ? entry[key] : entry
    (str && str.to_s.strip.present?) ? str.to_s.strip : nil
  end

  def parse_line line
    row = line.split("\t")
    [ open_library_id(row[1]), Integer(row[2]), DateTime.parse(row[3]), JSON.parse(row[4]) ]
  end

  def open_library_id str
    return nil unless str
    str.split('/').last
  end

  YEAR_SPLIT_REGEX = /[\s\\\/,._-]+/
  YEAR_MATCH_REGEX = /[\d]{4}/
  CURRENT_YEAR = Time.now.year

  # note: currently can not handle BCE year values
  def safe_year hash, key
    str = str_or_value(hash[key])
    return nil unless str && str.strip.present?

    # allow a single integer to go through
    str = str.strip
    return str.to_i if str =~ /^[\d]{1,4}$/

    # otherwise assume that a 4 digit integer from 1000 to 2016 is the year
    years = str.split(YEAR_SPLIT_REGEX).select {|s| s =~ YEAR_MATCH_REGEX }
    if years && years.length > 0 
      year = years[0].to_i
      year > CURRENT_YEAR ? nil : year
    else
      nil
    end
  end

  def safe_lcc str
    return nil unless str

    str = str.first if str.is_a?(Array)
    return nil unless str.present?

    tmp = str.split(/\s+/)[0]
    tmp.present? ? tmp.strip[0..13] : nil
  end

  def nil_or_int str, zero_valid = false
    return nil unless str
    str = str.first if str.is_a?(Array)
    i = str.to_i
    return zero_valid || i > 0 ? i : nil 
  end

  def safe_sub hash, key, subkey = 'value'
    tmp = hash[key]
    return nil unless tmp
    return tmp[subkey] if tmp.is_a?(Hash)
    return tmp.to_s
  end
end

