require 'counter'

class OpenLibrarySupport 

  attr_reader :authors_path, :works_path, :editions_path

  def initialize path
    entries = Dir.glob(File.join(path, "*.txt"))
    @authors_path = entries.select {|s| s =~ /authors/ }.first
    @works_path = entries.select {|s| s =~ /works/ }.first
    @editions_path = entries.select {|s| s =~ /editions/ }.first

    raise "All file paths not found" unless @authors_path && @works_path && @editions_path
  end


  def read_authors
    Counter.with_count do |cnt|
      File.open(authors_path) do |f|
        while line = f.gets
          cnt + (create_author(line) ? 1 : 0)
        end
      end
    end
  end

  def read_works
    Counter.with_count do |cnt|
      File.open(works_path) do |f|
        while line = f.gets
          cnt + (create_work(line) ? 1 : 0)
        end
      end
    end
  end

  def read_editions
    Counter.with_count do |cnt|
      File.open(editions_path) do |f|
        while line = f.gets
          cnt + (create_edition(line) ? 1 : 0)
        end
      end
    end
  end

  def create_work line
    ident, revision, created_at, hash = parse_line(line)
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

      add_tags(hash, work, 'genres', 'genre')
      add_tags(hash, work, 'subjects', 'subject')
      add_tags(hash, work, 'subject_time', 'period')
      add_tags(hash, work, 'subject_people', 'person')
      add_tags(hash, work, 'subject_places', 'place')
      add_tags(hash, work, 'series', 'series')

      work
    else
      nil
    end
  end

  def create_author line
    ident, revision, created_at, hash = parse_line(line)
    if ident.present? && hash
      author = Author.find_or_create_by(ident: ident) do |obj|
        obj.name = hash['name']
        obj.personal_name = hash['personal_name']
        obj.birth_date =  nil_or_int(hash['birth_date'])
        obj.death_date =  nil_or_int(hash['death_date'])
        obj.description = hash.fetch('bio', {}).fetch('value', '')
      end

      if hash['website'].present?
        author.external_links.create(name: hash['website'], value: hash['website'])
      end

      hash.fetch('links', []).each do |link|
        author.external_links.create(name: link['title'], value: link['url'])
      end

      add_tag(hash, author, 'location', 'location')

      author
    else
      nil
    end
  end

  def create_edition line
    ident, revision, created_at, hash = parse_line(line)
    if ident && hash
      edition = Edition.find_or_create_by(ident: ident) do |obj|
        obj.work = Work.find_by(ident: open_library_id(hash['works'].first['key']))
        obj.title = hash['title']
        obj.subtitle = hash['subtitle']
        obj.pages = nil_or_int(hash['number_of_pages'])
        obj.format = hash['physical_format']
        obj.publish_date = nil_or_int(hash.fetch('publish_date', '').split(/[\s,]+/).last)
        obj.lcc = hash['lc_classifications']

        description = hash['description'] || hash['notes']
        obj.description = description['value'] if description && description['value']
      end

      hash.fetch('publishers', []).each do |str|
        edition.edition_publishers.create(name: str)
      end

      hash.fetch('goodreads', []).each do |str|
        goodreads_id = str.to_i
        if goodreads_id > 0
          edition.external_links.create(name: 'Goodreads', value: "https://www.goodreads.com/book/show/#{ goodreads_id }") 
        end
      end

      add_tags(hash, edition, 'genres', 'genre')
      add_tags(hash, edition, 'subjects', 'subject')
      add_tags(hash, edition, 'subject_time', 'period')
      add_tags(hash, edition, 'subject_people', 'person')
      add_tags(hash, edition, 'subject_places', 'place')
      add_tags(hash, edition, 'series', 'series')
      add_tags(hash, edition, 'source_records', 'source')
      add_tags(hash, edition, 'oclc_numbers', 'oclc')
      add_tags(hash, edition, 'isbn_13', 'isbn')
      add_tags(hash, edition, 'isbn_10', 'isbn10')

      edition
    else
      nil
    end
  end

  def add_tag hash, obj, hash_key, name
    val = hash[hash_key]
    if val.is_a?(String) && val.strip.present?
      obj.subject_tags.create(name: name, value: val.strip)
    end
  end

  def add_tags hash, obj, hash_key, name
    hash.fetch(hash_key, []).each do |str|
      obj.subject_tags.create(name: name, value: str.strip) if str.strip.present?
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

