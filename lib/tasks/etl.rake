require 'author_support'
require 'work_support'
require 'edition_support'
require 'token_support'


namespace :etl do

  desc "load all open library data files (WARNING: not idempotent)"
  task :load_all, [ :path ] => :environment do |t, args|

    raise "path to folder is requires" unless args.path.present?
    raise "expected #{ args.path } to be a folder" unless File.directory?(args.path)
    raise "#{ args.path } is not readable" unless File.readable?(args.path)

    p "reading data from #{ args.path }..."
    read_authors(args.path)
    read_works(args.path)
    read_editions(args.path)

  end

  desc "load author data file (WARNING: not idempotent)"
  task :load_authors, [ :path ] => :environment do |t, args|

    raise "path to folder is requires" unless args.path.present?
    raise "expected #{ args.path } to be a folder" unless File.directory?(args.path)
    raise "#{ args.path } is not readable" unless File.readable?(args.path)

    p "reading work data from #{ args.path }..."
    read_authors(args.path)
    p ".done"
  end

  desc "load work data file (WARNING: not idempotent)"
  task :load_works, [ :path ] => :environment do |t, args|

    raise "path to folder is requires" unless args.path.present?
    raise "expected #{ args.path } to be a folder" unless File.directory?(args.path)
    raise "#{ args.path } is not readable" unless File.readable?(args.path)

    p "reading work data from #{ args.path }..."
    read_works(args.path)
    p ".done"
  end

  desc "load edition data file (WARNING: not idempotent)"
  task :load_editions, [ :path ] => :environment do |t, args|

    raise "path to folder is requires" unless args.path.present?
    raise "expected #{ args.path } to be a folder" unless File.directory?(args.path)
    raise "#{ args.path } is not readable" unless File.readable?(args.path)

    p "reading edition data from #{ args.path }..."
    read_editions(args.path)
    p ".done"
  end

  desc "aggressively cleanup tables"
  task aggressive_cleanup: :environment do
    p "cleaning up tables using VACUUM FULL ANALYZE..."
    res = Author.connection.execute("VACUUM FULL ANALYZE")
    p ".done"
  end

  desc "cleanup tables"
  task cleanup: :environment do
    p "cleaning up tables using VACUUM ANALYZE..."
    res = Author.connection.execute("VACUUM ANALYZE")
    p ".done"
  end

  def read_authors path
    p ". deleting author data"
    SubjectTag.where(taggable_type: 'Author').delete_all
    ExternalLink.where(linkable_type: 'Author').delete_all
    WorkAuthor.delete_all
    EditionAuthor.delete_all
    Author.delete_all
    Token.where(token_type: 'Author').delete_all

    p ". done deleting author data"

    p ". reading author data"
    as = AuthorSupport.new(path)
    as.build_tokens
    as.save_tokens
    p ". done reading authors"
  end

  def read_works path
    p ". deleting work data"
    SubjectTag.where(taggable_type: 'Work').delete_all
    ExternalLink.where(linkable_type: 'Work').delete_all
    WorkAuthor.delete_all
    WorkEdition.delete_all
    Work.delete_all
    Token.where(token_type: 'Work').delete_all
    p ". done deleting work data"

    p ". reading work data"
    ws = WorkSupport.new(path)
    ws.build_tokens
    ws.save_tokens
    p ". done reading works"
  end


  def read_editions path
    p ". deleting edition data"
    SubjectTag.where(taggable_type: 'Edition').delete_all
    ExternalLink.where(linkable_type: 'Edition').delete_all
    EditionAuthor.delete_all
    WorkEdition.delete_all
    Edition.delete_all
    Token.where(token_type: 'Edition').delete_all
    p ". done deleting edition data"

    p ". reading edition data"
    es = EditionSupport.new(path)
    es.build_tokens
    es.save_tokens
    p ". done reading editions"
  end
end
