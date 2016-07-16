class Api::V1::Charts::DatabaseMetadataController < ApplicationController

  def main_tables

    data = Rails.cache.fetch("database-metadata/main-tables", expires_in: 1.hour) do
      [
        { label: 'Work', value: Work.count },
        { label: 'Author', value: Author.count },
        { label: 'Edition', value: Edition.count }
      ]
    end
    render json: data
  end

  def all_tables
    
    data = Rails.cache.fetch("database-metadata/all-tables", expires_in: 1.hour) do
      [
        { label: 'Work', value: Work.count },
        { label: 'Author', value: Author.count },
        { label: 'Edition', value: Edition.count },
        { label: 'Work Author', value: WorkAuthor.count },
        { label: 'Tag', value: SubjectTag.count },
        { label: 'Token', value: Token.count }
      ]
    end
    render json: data
  end

  def tag_tables

    data = Rails.cache.fetch("database-metadata/tag-tables", expires_in: 1.hour) do
      [
        { label: 'Work Tags', value: SubjectTag.where(taggable_type: 'Work').count },
        { label: 'Author Tags', value: SubjectTag.where(taggable_type: 'Author').count },
        { label: 'Edition Tags', value: SubjectTag.where(taggable_type: 'Edition').count }
      ]
    end
    render json: data
  end

  def token_tables

    data = Rails.cache.fetch("database-metadata/token-tables", expires_in: 1.hour) do
      [
        { label: 'Work Tokens', value: Token.where(token_type: 'Work').count },
        { label: 'Author Tokens', value: Token.where(token_type: 'Author').count },
        { label: 'Edition Tokens', value: Token.where(token_type: 'Edition').count }
      ]
    end
    render json: data
  end
end
