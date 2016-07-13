require 'open_library_support'

namespace :etl do

  desc "Load OpenLibrary data files (WARNING: not idempotent)"
  task :load_data, [ :path ] => :environment do |t, args|

    raise "path to folder is requires" unless args.path.present?
    raise "expected #{ args.path } to be a folder" unless File.directory?(args.path)
    raise "#{ args.path } is not readable" unless File.readable?(args.path)

    p "reading data from #{ args.path }"
    ols = OpenLibrarySupport.new(args.path)
    authors = ols.read_authors
    p "... found #{ authors } author entries"

    works = ols.read_works
    p "...found #{ works } work entries"

    editions = ols.read_editions
    p "... found #{ editions } edition entries"

    p ".done"

  end

  task :load_works, [ :path ] => :environment do |t, args|
    raise "path to folder is requires" unless args.path.present?
    raise "expected #{ args.path } to be a folder" unless File.directory?(args.path)
    raise "#{ args.path } is not readable" unless File.readable?(args.path)

    p "reading data from #{ args.path }"
    ols = OpenLibrarySupport.new(args.path, only: [ :works ])
    authors = ols.read_authors
    p "... found #{ authors } author entries"

    works = ols.read_works
    p "...found #{ works } work entries"

    editions = ols.read_editions
    p "... found #{ editions } edition entries"

    p ".done"
  end

  task :load_editions, [ :path ] => :environment do |t, args|
    raise "path to folder is requires" unless args.path.present?
    raise "expected #{ args.path } to be a folder" unless File.directory?(args.path)
    raise "#{ args.path } is not readable" unless File.readable?(args.path)

    p "reading data from #{ args.path }"
    ols = OpenLibrarySupport.new(args.path, only: [ :editions ])
    authors = ols.read_authors
    p "... found #{ authors } author entries"

    works = ols.read_works
    p "...found #{ works } work entries"

    editions = ols.read_editions
    p "... found #{ editions } edition entries"

    p ".done"
  end

  desc "build author tokens" 
  task build_author_tokens: :environment do 
  
    require 'token_support'

    ts = TokenSupport.new
    p "token support instantiated..."
    p "... building authors"
    ts.process_authors
    p ".done"

  end
end
