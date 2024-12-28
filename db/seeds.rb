require_relative("../test/_factories/factory_helper")

class Seeder
  include FactoryHelper
end

Work.destroy_all
Producer.destroy_all
Publisher.destroy_all

unless ENV["CLEAR"]
  seeder = Seeder.new
  fixtures = seeder.private_methods.grep(/fixture/)
  fixtures.each do |fixture|
    seeder.send(fixture) # save each memoized object
  end
end