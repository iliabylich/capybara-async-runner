require 'pathname'
ROOT = Pathname.new(File.expand_path('../../..', __FILE__))
$: << ROOT.join('lib')
$: << EXAMPLE_ROOT = ROOT.join('examples/indexeddb')

require 'capybara'
require 'capybara/async_runner'
require 'capybara/poltergeist'
require 'pry'

Capybara.run_server = false
Capybara.default_driver = :poltergeist

Capybara::AsyncRunner.setup do |config|
  config.commands_directory = EXAMPLE_ROOT.join('templates')
end

module IndexDB
  URL = "https://raw.githubusercontent.com/dfahlander/Dexie.js/master/src/Dexie.js"

  require 'commands/wrapper_loader'
  require 'commands/wrapper_initializer'

  module Commands
    require 'commands/insert'
    require 'commands/query'
  end
end

# We can't run indexeddb-related code in about:blank
Capybara.current_session.visit('http://google.com')

# Inject the script
Capybara::AsyncRunner.run('indexeddb:wrapper:inject', url: IndexDB::URL)

# Run some initialization
Capybara::AsyncRunner.run('indexeddb:wrapper:initialize')

# And do some stuff
user_data = { name: 'Some Name' }

user_id = Capybara::AsyncRunner.run('indexeddb:insert', store: 'users', data: user_data)
p "User ID: #{user_id}"

methods = [
  { method: 'where', arguments: ['id']},
  { method: 'equals', arguments: [user_id] },
  { method: 'toArray', arguments: [] }
]

p Capybara::AsyncRunner.run('indexeddb:query', store: 'users', methods: methods)

# And even write some small wrapper
#
#
module IndexDB::DSL
  def current_scope
    @current_scope ||= []
  end

  IDB_METHODS = {
    above: :above,
    aboveOrEqual: :above_or_equal,
    anyOf: :any_of,
    below: :below,
    belowOrEqual: :below_or_equal,
    between: :between,
    equals: :equals,
    equalsIgnoreCase: :equals_ignore_case,
    startsWith: :starts_with,
    startsWithAnyOf: :starts_with_any_of,
    startsWithIgnoreCase: :starts_with_ignore_case,
    toArray: :to_a,
    where: :where
  }

  IDB_METHODS.each do |js_method_name, ruby_method_name|
    define_method ruby_method_name do |*arguments|
      current_scope << { method: js_method_name, arguments: arguments }
      self
    end
  end

  module ModelSupport
    IndexDB::DSL::IDB_METHODS.each do |_, method_name|
      define_method method_name do |*arguments|
        IndexDB::ChainedScope.new(self).send(method_name, *arguments)
      end
    end
  end
end

class IndexDB::ChainedScope
  include IndexDB::DSL

  def initialize(model)
    @model = model
  end

  def get
    collection = Capybara::AsyncRunner.run('indexeddb:query', store: @model.store, methods: current_scope)
    collection.map do |record|
      @model.new(record)
    end
  end
end

class IndexDB::Model
  extend IndexDB::DSL::ModelSupport
  attr_accessor :data

  def initialize(data)
    @data = data
  end

  class << self
    attr_accessor :store

    def all
      where('id').above(0).to_a.get
    end

    def find(record_id)
      where('id').equals(record_id).to_a.get.first
    end

    def count
      all.count
    end
  end
end

class User < IndexDB::Model
  self.store = :users
end

p User.all
p User.find(8)
p User.count