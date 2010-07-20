module Dollhouse
end

Dir.glob(File.dirname(__FILE__) + '/core_ext/*.rb') { |f| require f }
Dir.glob(File.dirname(__FILE__) + '/dollhouse/*.rb') { |f| require f }
