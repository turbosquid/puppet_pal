require 'getoptlong'
require 'puppet_pal/pal'

module PuppetPal
 class Cli
  def initialize

  end

  def run
    opts = GetoptLong.new(
      [ '--puppet_file', '-f', GetoptLong::REQUIRED_ARGUMENT ],
    )
    # Shove our options into a hash
    @options = {puppet_file: "Puppetfile"}
    opts.each do |opt, arg|
      key=opt.split("--").last
      if arg && !arg.empty?
        @options[key.to_sym]=arg
      else
        @options[key.to_sym]=true
      end
    end
    raise "Cannot find Puppetfile: #{@options[:puppet_file]}." unless File.exists?(@options[:puppet_file])
    pal = PuppetPal::Pal.new(@options[:puppet_file])
    pal.run
  end
 end
end
