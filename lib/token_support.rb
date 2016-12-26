require 'unidecoder'

class TokenSupport

  def save_hash type, hash
    year_to_count = {}
    hash.each do |year, h2|
      arr = []
      h2.each do |category, h3|
        h3.each do |token, count|
          escaped_quote = token[0...59].gsub("'", "''")
          arr << "('#{ type }',#{ category },#{ year },'#{ escaped_quote }',#{ count })"
        end
      end
      if arr.length > 0
        headers = "token_type, category, year, token, count"
        rows = arr.join(', ')
        sql = "INSERT INTO tokens (#{ headers }) VALUES #{ rows }"
        Token.connection.execute( sql )
        pp "#{ year }: #{ arr.length }"
        year_to_count[year] = arr.length
      end
    end
    year_to_count
  end


  def normalized_tokens str
    Token.tokenize(str)
  end

  def self.token_aggregator
    Hash.new do |h1, k1|
      h1[k1.to_i] = Hash.new do |h2, k2|
        h2[k2.to_i] = Hash.new do |h3, k3|
          h3[k3] = 0
        end
      end
    end
  end

end
