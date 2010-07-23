module Dollhouse
  class Server < Struct.new(:name, :instance_type, :os, :snapshot, :callbacks)
  end
end
