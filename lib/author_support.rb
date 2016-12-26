require 'open_library_support'
require 'token_support'

class AuthorSupport < OpenLibrarySupport
  attr_reader :authors_path, :year_to_category_to_token

  def initialize path
    super(path)

    entries = Dir.glob(File.join(base_path, "*.txt"))
    @authors_path = entries.select {|s| s =~ /authors/ }.first
    raise "Author file path not found" unless @authors_path

    @year_to_category_to_token = TokenSupport.token_aggregator
  end

  def save_tokens
    ts = TokenSupport.new
    ts.save_hash(Author, year_to_category_to_token)
  end

  def build_tokens
    cnt = 0
    File.open(authors_path) do |f|
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
    
    name = hash['name'] || hash['personal_name'] || 'unknown'
    descr = (safe_sub(hash, 'bio') || '')
    year = safe_year(hash, 'birth_date') || safe_year(hash, 'death_date')
    if year
      Token.tokenize(name).each do |t|
        year_to_category_to_token[year][Token::IDENTIFIER][t] += 1
      end

      Token.tokenize(descr).each do |t|
        year_to_category_to_token[year][Token::DESCRIPTION][t] += 1
      end
    end
  end
end
