require 'open_library_support'
require 'token_support'

class EditionSupport < OpenLibrarySupport
  attr_reader :editions_path, :year_to_category_to_token

  def initialize path
    super(path)

    entries = Dir.glob(File.join(base_path, "*.txt"))
    @editions_path = entries.select {|s| s =~ /editions/ }.first
    raise "Edition file path not found" unless @editions_path

    @year_to_category_to_token = TokenSupport.token_aggregator
  end

  def save_tokens
    ts = TokenSupport.new
    ts.save_hash(Edition, year_to_category_to_token)
  end

  def build_tokens
    cnt = 0
    File.open(editions_path) do |f|
      while line = f.gets
        cnt += 1
        pp "reading line #{ cnt }" if cnt % 10_000 == 0
        pp "years=#{ year_to_category_to_token.keys.count }" if cnt % 10_000 == 0
        build_token(line)
      end
    end
  end

  def build_token line
    ident, revision, created_at, hash = parse_line(line)

    year = safe_year(hash, 'publish_date') || safe_year(hash, 'copyright_date')
    title = hash['title'] || ''
    subtitle = hash['subtitle'] || ''
    series = hash['series'] || ''
    descr = safe_sub(hash, 'description') || safe_sub(hash, 'notes') || ''
    format = hash['physical_format'] || ''
    statement = str_or_value(hash, 'by_statement')
    genre = hash['genres'] || ''
    subject = hash['subjects'] || ''
    subject_time = hash['subject_time'] || ''
    subject_person = hash['subject_people'] || ''
    subject_place = hash['subject_places'] || ''
   
#pp "year=#{ year }"
#pp hash


    if year
      (Token.tokenize(title) + 
          Token.tokenize(subtitle) + 
          Token.tokenize(series)).sort.uniq.each do |t|
        year_to_category_to_token[year][Token::IDENTIFIER][t] += 1
      end

      (Token.tokenize(descr) + 
          Token.tokenize(format) + 
          Token.tokenize(statement) + 
          Token.tokenize(genre) + 
          Token.tokenize(subject) + 
          Token.tokenize(subject_time) + 
          Token.tokenize(subject_person) + 
          Token.tokenize(subject_place)).sort.uniq.each do |t|
        year_to_category_to_token[year][Token::DESCRIPTION][t] += 1
      end
    end
  end
end
