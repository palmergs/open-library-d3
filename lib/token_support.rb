require 'unidecoder'

class TokenSupport

  def process_all
    process_authors
    process_works
    process_editions
  end

  def process_authors

    process(Author, :birth_date, :name, Token::IDENTIFIER)
    process(Author, :birth_date, :description, Token::DESCRIPTION)

  end

  def process_works

    process(Work, :publish_date, [:title, :subtitle], Token::IDENTIFIER)
    process(Work, :publish_date, :description, Token::DESCRIPTION)
    process(Work, :publish_date, :excerpt, Token::CONTENT)

  end


  def process_editions

    process(Edition, :publish_date, [ :title, :subtitle, :statement, :series ], Token::IDENTIFIER)
    process(Edition, :publish_date, :description, Token::DESCRIPTION)
    process(Edition, :publish_date, :excerpt, Token::CONTENT)

  end

  def process clazz, date_field, text_fields, category

    range = date_range(clazz, date_field)
    if range
      range.each do |year|
        if year > 0 && year <= Date.today.year
          hash = build_hash(clazz, date_field, text_fields, year)
          inserted = insert_all(clazz, category, year, hash)
          pp ". #{ year }: inserted #{ inserted } tokens for #{ clazz.name } (#{ category })"
        end
      end
    end
  end

  def date_range clazz, date_field
    min = clazz.minimum(date_field.to_sym)
    max = clazz.maximum(date_field.to_sym)
    if min && max
      (min..max)
    else
      nil
    end
  end

  PAGE_SIZE = 2000

  def build_hash clazz, date_field, text_fields, year
    text_fields = Array(text_fields)
    hash = Hash.new(0)

    total = clazz.where(date_field.to_sym => year).count
    pages = total / PAGE_SIZE + 1
    pages.times do |pg|
      query = clazz.where(date_field.to_sym => year).page(pg + 1).per(PAGE_SIZE)
      query.each do |record|
        text_fields.each do |field|
          string = record.read_attribute(field)
          normalized_tokens(string).each do |token|
            hash[token] += 1
          end
        end
      end
    end
    hash
  end


  def insert_all clazz, category, year, hash
    arr = []
    hash.each_pair do |token, count|
      unless Token::STOP_WORDS.include?(token)
        escaped_quote = token[0...59].gsub("'", "''")
        arr << "('#{ clazz.name }', #{ category }, #{ year }, '#{ escaped_quote }', #{ count } )"
      end
    end

    if arr.length > 0
      sql = "INSERT INTO tokens (token_type, category, year, token, count) VALUES #{ arr.join(', ') }"
      Token.connection.execute( sql )
    end

    arr.length
  end

  def normalized_tokens str
    self.class.tokenize(str)
  end

  def self.tokenize str
    return [] unless str && str.to_s.present?
    str.to_s.to_ascii.scan(/[\w][\w'-]+/).map(&:downcase)
  end
end
