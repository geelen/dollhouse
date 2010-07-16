PROJECT_ROOT = File.dirname(__FILE__) + "/../.."

Dir.glob(PROJECT_ROOT + '/app/*.rb').each { |f| require f }

module Spec
  module Matchers
    alias :contain :include
  end
end
