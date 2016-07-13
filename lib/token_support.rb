require 'unidecoder'

class TokenSupport

  IDENTIFIER = 1
  DESCRIPTION = 2
  CONTENT = 3

  def process_authors

    process(Author, :birth_date, :name, IDENTIFIER)
    process(Author, :birth_date, :description, DESCRIPTION)

  end

  def process_works

    process(Work, :publish_date, [:title, :subtitle], IDENTIFIER)
    process(Work, :publish_date, :description, DESCRIPTION)
    process(Work, :publish_date, :sentence, CONTENT)

  end


  def process_editions

    process(Edition, :publish_date, [ :title, :subtitle, :series ], IDENTIFIER)
    process(Edition, :publish_date, [ :description, :publish_country ], DESCRIPTION)
    process(Edition, :publish_date, :first_sentence, CONTENT)

  end

  def process clazz, date_field, text_fields, category

    range = date_range(clazz, date_field)
    if range
      range.each do |year|
        if year > 0 && year <= Date.today.year
          count = clazz.where(date_field.to_sym => year).count
          if count > 0
            page = 0
            page_size = 1000
            begin
              hash = build_hash(clazz, page, page_size, date_field, text_fields, year)
              inserted = insert_all(clazz, category, year, hash)
pp "#{ year }. inserted #{ inserted } tokens for #{ clazz.name } (#{ category })"
            end while ((page += 1) * page_size) < count
          end
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

  def build_hash clazz, page, page_size, date_field, text_fields, year
    text_fields = Array.wrap(text_fields)
    hash = Hash.new(0)
    query = clazz.where(date_field.to_sym => year).page(page).per(page_size)
    query.each do |record|
      text_fields.each do |field|
        string = record.read_attribute(field)
        normalized_tokens(string).each do |token|
          hash[token] += 1  
        end
      end
    end
    hash
  end

  STOP_WORDS = Set.new([ 'the', 'and', 'in', 'be', 'to', 'of', 'it', 'that', 'have', 'on', 'at', 'or' ])

  def insert_all clazz, category, year, hash
    arr = []
    hash.each_pair do |token, count|
      unless STOP_WORDS.include?(token)
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
