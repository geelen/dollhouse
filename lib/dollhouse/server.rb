module Dollhouse
  class Server < Struct.new(:name, :instance_type, :os, :callbacks)
  end
end