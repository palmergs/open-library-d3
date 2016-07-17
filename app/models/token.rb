class Token < ActiveRecord::Base

  IDENTIFIER = 1
  DESCRIPTION = 2
  CONTENT = 3
  ALL_CATEGORIES = [ IDENTIFIER, DESCRIPTION, CONTENT ]

  TOKEN_TYPES = Set.new([ 'Work', 'Author', 'Edition' ])

  STOP_WORDS = Set.new([ 'the', 'and', 'in', 'be', 'to', 'of', 'it', 'from',
                         'that', 'have', 'on', 'at', 'or', 'el', 'la', 
                         'en', 'un', 'de', 'und', 'with', 'for', 'der', 'das' ])

  scope :by_year, ->(y) {
    if y && y.to_i > 0
      where(year: y.to_i)
    end
  }

  scope :by_category, ->(c) {
    if c 
      arr = Array(c).map(&:to_i).select {|i| ALL_CATEGORIES.include?(i) }
      if arr.size > 0
        where(category: arr)
      else
        none
      end
    end
  }

  scope :by_token, ->(q) {
    if q
      arr = Array(q).
          map {|s| s.to_s.downcase.strip }.
          reject {|s| STOP_WORDS.include?(s) }
      if arr.size > 0
        where(token: arr)
      else
        none
      end
    end
  }

  scope :by_type, ->(t) {
    if t
      arr = Array(t).select {|s| TOKEN_TYPE.include?(s.to_s) }
      if arr.size > 0
        where(token_type: arr)
      else
        none
      end
    end
  }

  def self.tokenize str
    return [] unless str && str.to_s.present?
    normalize(str).scan(/[\w][\w'-]+/)
  end

  def self.normalize str
    return nil unless str && str.to_s.present?
    str.to_s.to_ascii.downcase
  end
end
