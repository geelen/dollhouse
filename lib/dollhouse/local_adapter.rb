module Dollhouse
  class LocalAdapter
    def babushka taskname, vars = {}
      if !vars.empty?
        write_file("~/.babushka/vars/#{taskname}", {
          :vars => vars.map_keys(&:to_s).map_values {|v| {:value => v} }
        }.to_yaml)
      end
      shell "babushka '#{taskname}' --defaults"
    end

    def shell cmd, opts = {}
      puts "Running #{cmd}"
      output = `#{cmd}`
      puts output
      $? == 0
    end

    def write_file path, content
      puts "Writing to #{path}"
      File.open(File.expand_path(path), "w") {|f|
        f << content
      }
    end
  end
end
