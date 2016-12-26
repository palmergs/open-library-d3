require 'open_library_support'
require 'token_support'

class WorkSupport < OpenLibrarySupport
  attr_reader :works_path, :year_to_category_to_token

  def initialize path
    super(path)

    entries = Dir.glob(File.join(base_path, "*.txt"))
    @works_path = entries.select {|s| s =~ /works/ }.first
    raise "Work file path not found" unless @works_path

    @year_to_category_to_token = TokenSupport.token_aggregator
  end

  def save_tokens
    ts = TokenSupport.new
    ts.save_hash(Work, year_to_category_to_token)
  end

  def build_tokens
    cnt = 0
    File.open(works_path) do |f|
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

    year = safe_year(hash, 'first_publish_date') 
    title = hash['title']
    subtitle = hash['subtitle']
    excerpt = extract_excerpt(hash) || ''
    descr = safe_sub(hash, 'description') || ''

    if year
      (Token.tokenize(title) + Token.tokenize(subtitle)).sort.uniq.each do |t|
        year_to_category_to_token[year][Token::IDENTIFIER][t] += 1
      end

      Token.tokenize(excerpt).each do |t|
        year_to_category_to_token[year][Token::CONTENT][t] += 1
      end

      Token.tokenize(descr).each do |t|
        year_to_category_to_token[year][Token::DESCRIPTION][t] += 1
      end
    end
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
end
