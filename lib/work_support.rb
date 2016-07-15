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

    authors = Set.new(extract_authors(hash))
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
    arr.map do |entry| 
      if entry['author']
        open_library_id(safe_sub(entry['author'], 'key')) 
      else
        open_library_id(entry['key'])
      end
    end.compact
  end

  def extract_excerpt hash

    excerpts = hash.fetch('excerpts', [])
    excerpts = excerpts.select {|entry| entry['excerpt'].present? }
    excerpts = excerpts.map {|entry| str_or_value(entry['excerpt']) }

    sentence = str_or_value(hash['first_sentence'])

    if sentence && excerpts.count > 0
      excerpts << sentence unless sentence == excerpts.first
      excerpts.join("\n\n")
    elsif sentence
      sentence
    else
      excerpts.join("\n\n")
    end
  end

  def build_tags ident, hash
    add_tags(unsaved_work_tags[ident], hash, 'genres', 'genre')
    add_tags(unsaved_work_tags[ident], hash, 'subjects', 'subject')
    add_tags(unsaved_work_tags[ident], hash, 'subject_times', 'period')
    add_tags(unsaved_work_tags[ident], hash, 'subject_people', 'person')
    add_tags(unsaved_work_tags[ident], hash, 'subject_places', 'place')

    add_tags(unsaved_work_tags[ident], hash, 'dewey_number', 'dewey')
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
    i2i = idents_to_ids(Work, unsaved_works)
    ai2i = author_idents_to_ids(unsaved_works)

    work_authors = []
    unsaved_works.each_pair do |ident, hash|
      work_id = i2i[ident]
      if work_id
        hash.fetch(:authors, []).each do |author_ident|
          author_id = ai2i[author_ident]
          work_authors << "(#{ work_id }, #{ author_id })" if author_id
        end
      end
    end

    if work_authors.length > 0
      sql = "INSERT INTO work_authors (work_id, author_id) VALUES #{ work_authors.join(', ') }"
      WorkAuthor.connection.execute( sql )
    end

    work_authors.length
  end

  def author_idents_to_ids hash

    author_idents = Set.new
    hash.each_pair {|k,h| author_idents += h[:authors]}
    return {} if author_idents.empty?

    Author.where(ident: author_idents.to_a).select(:id, :ident).each_with_object({}) do |a,h|
      h[a.ident] = a.id
    end
  end
end
