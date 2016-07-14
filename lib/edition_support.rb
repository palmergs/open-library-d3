require 'open_library_support'

class EditionSupport < OpenLibrarySupport
  attr_reader :editions_path, :unsaved_editions, :unsaved_edition_links, :unsaved_edition_tags

  def initialize path
    super(path)

    entries = Dir.glob(File.join(base_path, "*.txt"))
    @editions_path = entries.select {|s| s =~ /editions/ }.first
    raise "Edition file path not found" unless @editions_path
    
    @unsaved_editions = {}
    @unsaved_edition_links = Hash.new {|h,k| h[k] = [] }
    @unsaved_edition_tags = Hash.new {|h,k| h[k] = [] }
  end

  def read
    read_file(editions_path) do |line|
      build_edition(line)
    end
  end

  def save_all
    save_editions and save_edition_authors_and_works and unsaved_editions.clear
    save_links(Edition, unsaved_edition_links) and unsaved_edition_links.clear
    save_tags(Edition, unsaved_edition_tags) and unsaved_edition_tags.clear
  end

  def build_edition line
    ident, revision, created_at, hash = parse_line(line)
    return if unsaved_editions[ident]

    works = extract_works(hash)
    authors = extract_authors(hash)
    unsaved_editions[ident] = {
      ident: ident,
      title: hash['title'] || 'unknown',
      subtitle: hash['subtitle'],
      statement: str_or_value(hash, 'by_statement'),
      pages: nil_or_int(hash['number_of_pages']),
      format: hash['physical_format'],
      publish_date: safe_year(hash, 'publish_date') || safe_year(hash, 'copyright_date'),
      lcc: safe_lcc(hash['lc_classifications']),
      series: str_or_value(hash, 'series'),
      description: safe_sub(hash, 'description') || safe_sub(hash, 'notes') || '',
      works: works,
      work_editions_count: works.length,
      authors: authors,
      edition_authors_count: authors.length }

    build_tags(ident, hash)
    build_links(ident, hash)
  end

  def extract_works hash
    arr = hash.fetch('works', [])
    arr.map {|entry| open_library_id(entry['key']) }.compact
  end

  def extract_authors hash
    arr = hash.fetch('authors', [])
    arr.map {|entry| open_library_id(entry['key']) }.compact
  end

  def build_tags ident, hash
    add_tags(unsaved_edition_tags[ident], hash, 'genres', 'genre')
    add_tags(unsaved_edition_tags[ident], hash, 'subjects', 'subject')
    add_tags(unsaved_edition_tags[ident], hash, 'subject_time', 'period')
    add_tags(unsaved_edition_tags[ident], hash, 'subject_people', 'person')
    add_tags(unsaved_edition_tags[ident], hash, 'subject_places', 'place')
    add_tags(unsaved_edition_tags[ident], hash, 'series', 'series')
    add_tags(unsaved_edition_tags[ident], hash, 'source_records', 'source')
    add_tags(unsaved_edition_tags[ident], hash, 'oclc_numbers', 'oclc')
    add_tags(unsaved_edition_tags[ident], hash, 'isbn_13', 'isbn')
    add_tags(unsaved_edition_tags[ident], hash, 'isbn_10', 'isbn10')
    add_tags(unsaved_edition_tags[ident], hash, 'dewey_decimal_class', 'dewey')

    add_tag(unsaved_edition_tags[ident], hash['identifiers'], 'goodreads')
    add_tag(unsaved_edition_tags[ident], hash['identifiers'], 'librarything')

    arr = hash['table_of_contents']
    if arr
      arr.each do |entry|
        str = str_or_value(entry, 'title')
        unsaved_edition_tags[ident] << { name: 'toc', value: str } if str.present?
      end
    end

    arr = hash['publishers']
    if arr
      arr.each do |entry|
        str = str_or_value(entry)
        unsaved_edition_tags[ident] << { name: 'publisher', value: str } if str.present?
      end
    end
  end

  def build_links ident, hash
    hash.fetch('links', []).each do |link|
      if link.is_a?(Hash)
        name = link['title']
        url = link['url']
        unsaved_edition_links[ident] << { name: name.downcase, value: url }
      end
    end

    if hash['wikipedia']
      value = str_or_value(hash['wikipedia'])
      unsaved_edition_links[ident] << { name: 'wikipedia', value: value } if value.present?
    end

    if hash['website']
      value = str_or_value(hash['website'])
      unsaved_edition_links[ident] << { name: 'website', value: value } if value.present?
    end

    hash.fetch('covers', []).each do |photo|
      id = photo.to_s.to_i
      unsaved_edition_links[ident] << { name: 'photo', value: "https://covers.openlibrary.org/b/id/#{ id }.jpg" } if id > 0
    end

  end

  def save_editions
    inserts = []
    unsaved_editions.each_pair do |ident, hash|
      arr = [ str_val(ident),
              str_val(hash[:title]),
              str_val(hash[:subtitle]),
              str_val(hash[:statement]),
              str_val(hash[:lcc]),
              num_val(hash[:publish_date]),
              str_val(hash[:excerpt]),
              str_val(hash[:description]),
              num_val(hash[:edition_authors_count]),
              num_val(hash[:work_editions_count]),
              str_val(DateTime.now.to_s),
              str_val(DateTime.now.to_s)]
      inserts << "(#{ arr.join(', ') })"
    end

    if inserts.length > 0
      sql = "INSERT INTO editions (ident, title, subtitle, statement, lcc, publish_date, excerpt, description, edition_authors_count, work_editions_count, created_at, updated_at) VALUES #{ inserts.join(', ') }"
      Edition.connection.execute( sql )
      pp ". inserted #{ inserts.length } editions"
    end

    inserts.length
  end

  def save_edition_authors_and_works
    i2i = idents_to_ids(Edition, unsaved_editions)

    edition_authors = []
    work_editions = []
    unsaved_editions.each_pair do |ident, hash|
      edition_id = i2i[ident]
      if edition_id
        hash.fetch(:authors, []).each do |author_ident|
          if author_ident
            author = Author.find_by(ident: author_ident)
            edition_authors << "(#{ edition_id }, #{ author.id })" if author
          end
        end

        hash.fetch(:works, []).each do |work_ident|
          if work_ident
            work = Work.find_by(ident: work_ident)
            work_editions << "(#{ edition_id }, #{ work.id })" if work
          end
        end
      end
    end

    if edition_authors.length > 0
      sql = "INSERT INTO edition_authors (edition_id, author_id) VALUES #{ edition_authors.join(', ') }"
      EditionAuthor.connection.execute( sql )
    end

    if work_editions.length > 0
      sql = "INSERT INTO work_editions (edition_id, work_id) VALUES #{ work_editions.join(', ') }"
      WorkEdition.connection.execute( sql )
    end

    edition_authors.length + work_editions.length
  end
end
