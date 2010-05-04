module MethodsToShellCommands
  def babushka task, args
    vars = {:vars => args.map_keys(&:to_s).map_values { |v| {'values' => v} }}.to_yaml
    File.open('~/.babushka/vars/' + task, 'w') { |f| f.puts vars }
    shell "babushka '#{taks}'"
  end
end