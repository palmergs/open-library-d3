require 'open_library_support'

class WorkSupport < OpenLibrarySupport
  attr_reader :works_path, :unsaved_works, :unsaved_work_links, :unsaved_work_tags

  def initialize path
    super(path)

    entries = Dir.glob(File.join(base_path, "*.txt"))
    @works_path = entries.select {|s| s =~ /works/ }.first
    raise "Work file path not found" unless @works_path

    @unsaved_works = {}
    @unsaved_work_links = Hash.new {|h,k| h[k] = [] }
    @unsaved_work_tags = Hash.new {|h,k| h[k] = [] }
  end

  def read
    read_file(works_path) do |line|
      build_work(line)
    end
  end

  def save_all
    save_works and save_work_authors and unsaved_works.clear
    save_links(Work, unsaved_work_links) and unsaved_work_links.clear
    save_tags(Work, unsaved_work_tags) and unsaved_work_tags.clear
  end

  def build_work line
    ident, revision, created_at, hash = parse_line(line)
    return if unsaved_works[ident]

    authors = extract_authors(hash)
    unsaved_works[ident] = {
      ident: ident,
      title: hash['title'] || 'unknown',
      subtitle: hash['subtitle'],
      lcc: safe_lcc(hash['lc_classification']),
      publish_date: safe_year(hash, 'first_publish_date'),
      excerpt: extract_excerpt(hash),
      description: safe_sub(hash, 'description') || '',
      authors: authors,
      work_authors_count: authors.length }

    build_tags(ident, hash)
    build_links(ident, hash)
  end

  def extract_authors hash
    arr = hash.fetch('authors', [])
    return [ open_library_id(arr) ] if arr.is_a?(String)

    arr.map {|entry| str_or_value(entry, 'author') }
  end

  def extract_excerpt hash

    excerpts = hash.fetch('excerpts', [])
    excerpts = excerpts.select do |entry|
      entry['excerpt']
    end.map do |entry|
      comment = entry['comment']
      text = entry['excerpt']
      comment.present? ? "#{ text }\n[#{ comment }]" : text.strip
    end

    sentence = str_or_value(hash['first_sentence'])
    ([ sentence ] + excerpts).compact.join("\n\n")
  end

  def build_tags ident, hash
    add_tags(unsaved_work_tags[ident], hash, 'genres', 'genre')
    add_tags(unsaved_work_tags[ident], hash, 'subjects', 'subject')
    add_tags(unsaved_work_tags[ident], hash, 'subject_times', 'period')
    add_tags(unsaved_work_tags[ident], hash, 'subject_people', 'person')
    add_tags(unsaved_work_tags[ident], hash, 'subject_places', 'place')

    add_tag(unsaved_work_tags[ident], hash, 'dewey_number', 'dewey')
  end

  def build_links ident, hash
    hash.fetch('links', []).each do |link|
      if link.is_a?(Hash)
        name = link['title']
        url = link['url']
        unsaved_work_links[ident] << { name: name.downcase, value: url }
      end
    end

    if hash['wikipedia']
      value = str_or_value(hash['wikipedia'])
      unsaved_work_links[ident] << { name: 'wikipedia', value: value } if value.present?
    end

    if hash['website']
      value = str_or_value(hash['website'])
      unsaved_work_links[ident] << { name: 'website', value: value } if value.present?
    end

    hash.fetch('covers', []).each do |photo|
      id = photo.to_s.to_i
      unsaved_work_links[ident] << { name: 'photo', value: "https://covers.openlibrary.org/b/id/#{ id }.jpg" } if id > 0
    end
  end

  def save_works
    inserts = []
    unsaved_works.each_pair do |ident, hash|
      arr = [ str_val(ident), 
              str_val(hash[:title]), 
              str_val(hash[:subtitle]), 
              str_val(hash[:lcc]), 
              num_val(hash[:publish_date]), 
              str_val(hash[:excerpt]), 
              str_val(hash[:description]),
              num_val(hash[:work_authors_count]),
              str_val(DateTime.now.to_s),
              str_val(DateTime.now.to_s) ]
      inserts << "(#{ arr.join(', ') })"
    end

    if inserts.length > 0
      sql = "INSERT INTO works (ident, title, subtitle, lcc, publish_date, excerpt, description, work_authors_count, created_at, updated_at) VALUES #{ inserts.join(', ') }"
      Work.connection.execute( sql )
      pp ". inserted #{ inserts.length } works"
    end

    inserts.length
  end

  def save_work_authors
    work_authors = []
    unsaved_works.each_pair do |ident, hash|
      work = Work.find_by(ident: ident)
      if work
        hash.fetch(:authors, []).each do |author_ident|
          if author_ident
            author = Author.find_by(ident: author_ident)
            work_authors << "(#{ work.id }, #{ author.id })" if author
          end
        end
      end
    end

    if work_authors.length > 0
      sql = "INSERT INTO work_authors (work_id, author_id) VALUES #{ work_authors.join(', ') }"
      WorkAuthor.connection.execute( sql )
    end

    work_authors.length
  end
end