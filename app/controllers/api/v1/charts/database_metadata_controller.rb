class Api::V1::Charts::DatabaseMetadataController < ApplicationController

  def main_tables

    data = [
      { label: 'Work', value: Work.count },
      { label: 'Author', value: Author.count },
      { label: 'Edition', value: Edition.count }
    ]
    render json: data
  end

  def all_tables
    
    data = [
      { label: 'Work', value: Work.count },
      { label: 'Author', value: Author.count },
      { label: 'Edition', value: Edition.count },
      { label: 'Edition Publisher', value: EditionPublisher.count },
      { label: 'Work Author', value: WorkAuthor.count },
      { label: 'Tag', value: SubjectTag.count },
      { label: 'Link', value: ExternalLink.count }
    ]
    render json: data
  end
end
