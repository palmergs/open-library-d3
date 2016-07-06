class OpenLibrarySupport 

  attr_reader :authors_path, :works_path, :editions_path

  def initialize path
    entries = Dir.glob(File.join(path, "*.txt"))
    @authors_path = entries.select {|s| s =~ /authors/ }.first
    @works_path = entries.select {|s| s =~ /works/ }.first
    @editions_path = entries.select {|s| s =~ /editions/ }.first
  end


  def read_authors
    with_count do |cnt|
      File.open(authors_path) do |f|
        while line = f.gets
          cnt += (create_author(line) ? 1 : 0)
        end
      end
    end
  end

  def read_works
    with_count do |cnt|
      File.open(works_path) do |f|
        while line = f.gets
          cnt += (create_work(line) ? 1 : 0)
        end
      end
    end
  end

  def read_editions
    with_count do |cnt|
      File.open(editions_path) do |f|
        while line = f.gets
          cnt += (create_edition(line) ? 1 : 0)
        end
      end
    end
  end

  def with_count &block
    yield(0)
  end

  def create_work line
    ident, revision, created_at, hash = parse_line(line)[3].keys.each {|k| hash[k] += 1 } 
    if ident.present? && hash
      work = Work.find_or_create_by(ident: ident) do |obj|
        obj.title =       hash['title']
        obj.subtitle =    hash['subtitle']
        obj.description = hash.fetch('description', {}).fetch('value', '')
        obj.sentence =    hash.fetch('first_sentence', {}).fetch('value', nil)
        obj.lcc =         hash['lc_classifications']
        obj.publish_date = nil_or_int(hash['first_publish_date'])
      end

      hash.fetch('authors', []).each do |entry|
        aid = open_library_id(entry['author']['key'])
        role = 'author'
        author = Author.find_by(ident: aid)
        work.work_authors.create(author: author, role: role) if author
      end

      hash.fetch('subjects', []).each do |entry|
        work.subject_tags.create(name: 'subject', value: entry)
      end

      hash.fetch('subject_places', []).each do |entry|
        work.subject_tags.create(name: 'place', value: entry)
      end

      hash.fetch('subject_people', []).each do |entry|
        work.subject_tags.create(name: 'person', value: entry)
      end

      hash.fetch('subject_times', []).each do |entry|
        work.subject_tags.create(name: 'period', value: entry)
      end
    end
  end

  def create_author line
    ident, revision, created_at, hash = parse_line(line)[3].keys.each {|k| hash[k] += 1 } 
    if ident && hash
      author = Author.find_or_create_by(ident: ident) do |obj|
        obj.name = hash['name']
        obj.personal_name = hash['personal_name']
        obj.birth_date =  nil_or_int(hash['birth_date'])
        obj.death_date =  nil_or_int(hash['death_date'])
        obj.description = hash.fetch('bio', {}).fetch('value', '')
      end

      if hash['website'].present?
        author.external_links.create(name: hash['website', value: hash['website']
      end

      if hash['location'].present?
        author.subject_tags.create(name: 'location', value: hash['location'])
      end

      hash.fetch('links', []).each do |link|
        author.external_links.create(name: link['title'], value: link['url'])
      end
    end
  end

  def create_edition line
    ident, revision, created_at, hash = parse_line(line)[3].keys.each {|k| hash[k] += 1 } 
    if ident && hash

    end
  end

  def parse_line line
    row = line.split("\t")
    [ open_library_id(row[1]), Integer(row[2]), DateTime.parse(row[3]), JSON.parse(row[4]) ]
  end

  def open_library_id str
    str.split('/').last
  end

  def nil_or_int str, zero_valid = false
    return nil unless str
    i = str.to_i
    return zero_valid || i > 0 ? i : nil 
  end


end

