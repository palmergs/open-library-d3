class Api::V1::Charts::DatabaseMetadataController < ApplicationController

  def main_tables

    data = Rails.cache.fetch("database-metadata/main-tables", expires_in: 7.days) do
      [
        { label: 'Work', value: Work.count(:id) },
        { label: 'Author', value: Author.count(:id) },
        { label: 'Edition', value: Edition.count(:id) }
      ]
    end
    render json: data
  end

  def all_tables
    
    data = Rails.cache.fetch("database-metadata/all-tables", expires_in: 7.days) do
      [
        { label: 'Work', value: Work.count(:id) },
        { label: 'Author', value: Author.count(:id) },
        { label: 'Edition', value: Edition.count(:id) },
        { label: 'Work Author', value: WorkAuthor.count(:id) },
        { label: 'Tag', value: SubjectTag.count(:id) },
        { label: 'Token', value: Token.count(:id) }
      ]
    end
    render json: data
  end

  def tag_tables

    data = Rails.cache.fetch("database-metadata/tag-tables", expires_in: 7.days) do
      [
        { label: 'Work Tags', value: SubjectTag.where(taggable_type: 'Work').count(:id) },
        { label: 'Author Tags', value: SubjectTag.where(taggable_type: 'Author').count(:id) },
        { label: 'Edition Tags', value: SubjectTag.where(taggable_type: 'Edition').count(:id) }
      ]
    end
    render json: data
  end

  def token_tables

    data = Rails.cache.fetch("database-metadata/token-tables", expires_in: 7.days) do
      [
        { label: 'Work Tokens', value: Token.where(token_type: 'Work').count(:id) },
        { label: 'Author Tokens', value: Token.where(token_type: 'Author').count(:id) },
        { label: 'Edition Tokens', value: Token.where(token_type: 'Edition').count(:id) }
      ]
    end
    render json: data
  end
end
