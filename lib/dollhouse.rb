module Dollhouse
end

Dir.glob(File.dirname(__FILE__) + '/dollhouse/*.rb') { |f| require f }
