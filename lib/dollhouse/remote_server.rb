# Let it be known, dgoodlad is a profase.

require 'net/ssh'
require 'net/sftp'
require 'tempfile'

module Dollhouse
  class RemoteServer
    class FailedRemoteCommand < Exception;
    end

    include Net::SSH::Prompt

    attr_reader :ssh, :host, :user, :init_opts

    def initialize(host, user, opts = {})
      begin
        @ssh = Net::SSH.start(host, user, opts)
      rescue Net::SSH::HostKeyMismatch => exception
        exception.remember_host!
        sleep 0.2
        retry
      end

      @host = host
      @user = user
      @init_opts = opts
    end

    # Write to a remote file at _path_.
    def write_file(path)
      exec "mkdir -p #{File.dirname(path).gsub(/ /, "\\ ")}"
      Tempfile.open(File.basename(path)) do |f|
        yield f
        f.flush
        remote_path = %Q{"#{@user}@#{host}:#{path.gsub(/ /, "\\ ")}"}
        puts "Writing to #{remote_path}"
        `scp '#{f.path}' #{remote_path}`
      end
    end

    def exec(command, opts = {})
      STDOUT.sync = true
      channel = @ssh.open_channel do |ch|
        ch.request_pty(:term => 'xterm-color') do |ch, success|
          raise "Failed to get a PTY!" unless success

          output = ''
          status_code = nil

          puts "Executing:\n#{command}"

          ch.exec(command) do |ch, success|
            raise "Failed to start execution!" unless success

            ch.on_data do |ch, data|
                         # could loop badly
              if opts[:sudo_password] && data =~ /\[sudo\] password for/
                print data
                puts "*SUDO PASSWORD AUTOMATICALLY SENT*"
                ch.send_data("#{opts[:sudo_password]}\n")
              elsif data =~ /[Pp]assword.+:/
                ch.send_data("#{prompt(data, false)}\n")
              elsif data =~ /continue connecting \(yes\/no\)\?/
                ch.send_data("#{prompt(data, true)}\n")
              else
                print data
              end

              output << data
            end

            ch.on_extended_data do |ch, data|
              print data
            end

            ch.on_request('exit-status') do |ch, data|
              status_code = data.read_long
            end
          end
          ch.wait

          unless status_code.zero?
            raise FailedRemoteCommand, "Status code: #{status_code}"
          end

          result = [status_code.zero?, output, status_code]
          block_given? ? yield(result) : result
        end
      end
      channel.wait
    end

    def get_environment(var)
      @ssh.exec!("echo $#{var}").strip
    end

    def connected_as_root?
      @ssh.exec!("id") =~ /^uid=0\(root\)/
    end
  end
end
