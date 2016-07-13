require 'open_library_support'

class AuthorSupport < OpenLibrarySupport
  attr_reader :authors_path, :unsaved_authors, :unsaved_author_links, :unsaved_author_tags

  def initialize path
    super(path)

    entries = Dir.glob(File.join(base_path, "*.txt"))
    @authors_path = entries.select {|s| s =~ /authors/ }.first
    raise "Author file path not found" unless @authors_path

    @unsaved_authors = {}
    @unsaved_author_links = Hash.new {|h,k| h[k] = [] }
    @unsaved_author_tags = Hash.new {|h,k| h[k] = [] }
  end

  def read
    read_file(authors_path) do |line|
      build_author(line)
    end
  end

  def save_all
    save_authors and unsaved_authors.clear
    save_links(Author, unsaved_author_links) and unsaved_author_links.clear
    save_tags(Author, unsaved_author_tags) and unsaved_author_tags.clear
  end

  def build_author line
    ident, revision, created_at, hash = parse_line(line)
    return if unsaved_authors[ident]

    unsaved_authors[ident] = {
      ident: ident,
      name: hash['name'] || 'unknown',
      personal_name: hash['personal_name'],
      birth_date: safe_year(hash, 'birth_date'),
      death_date: safe_year(hash, 'death_date'),
      description: (safe_sub(hash, 'bio') || '')
    }

    build_tags(ident, hash)
    build_links(ident, hash)

  end

  def build_tags ident, hash
    alternate_names = Set.new(hash.fetch('alternate_names', []) + [ hash['fuller_name'] ] + [ hash['personal_name'] ])
    alternate_names.each do |entry|
      value = str_or_value(entry)
      unsaved_author_tags[ident] << { name: 'alternate name', value: value } if value.present?
    end

    add_tag(unsaved_author_tags[ident], hash, 'location')
  end

  def build_links ident, hash
    hash.fetch('links', []).each do |link|
      if link.is_a?(Hash)
        name = link['title']
        url = link['url']
        unsaved_author_links[ident] << { name: name.downcase, value: url }
      end
    end

    if hash['wikipedia']
      value = str_or_value(hash['wikipedia'])
      unsaved_author_links[ident] << { name: 'wikipedia', value: value } if value.present?
    end

    if hash['website']
      value = str_or_value(hash['website'])
      unsaved_author_links[ident] << { name: 'website', value: value } if value.present?
    end

    hash.fetch('photos', []).each do |photo|
      id = photo.to_s.to_i
      unsaved_author_links[ident] << { name: 'photo', value: "https://covers.openlibrary.org/b/id/#{ id }.jpg" } if id > 0
    end
  end

  def save_authors
    inserts = []
    unsaved_authors.each_pair do |ident, hash|
      arr = [ str_val(ident), 
              str_val(hash[:name]), 
              num_val(hash[:birth_date]), 
              num_val(hash[:death_date]), 
              str_val(hash[:description]),
              str_val(DateTime.now.to_s),
              str_val(DateTime.now.to_s)]
      inserts << "(#{ arr.join(', ') })"  
    end

    if inserts.count > 0
      sql = "INSERT INTO authors (ident, name, birth_date, death_date, description, created_at, updated_at) VALUES #{ inserts.join(', ') }"
      Author.connection.execute( sql )
      pp ". inserted #{ inserts.count } authors"
    end

    inserts.count
  end
end
