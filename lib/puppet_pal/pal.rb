require 'fileutils'

module PuppetPal
 class Pal
    PAL_WORKING_DIR = ".puppet_pal"
    DEFAULT_GIT_MODE = :reclone
    MODULE_DIR = "modules"

    def initialize(puppet_file_name)
      @repositories={git: {}}
      @puppet_file_name = File.expand_path(puppet_file_name)
      @base_dir = File.dirname(@puppet_file_name)
      @work_dir = File.join(@base_dir, PAL_WORKING_DIR)
      @module_dir = File.join(@base_dir, MODULE_DIR)
      @git_mode = DEFAULT_GIT_MODE
    end

    def run
      FileUtils.mkdir_p(@work_dir)
      FileUtils.mkdir_p(@module_dir)
      self.instance_eval(File.read(@puppet_file_name))
    end

    def repo_dirname(name, type)
      File.join(@work_dir, type.to_s, name.gsub("/","-"))
    end

    def pull_repo(name, type = :git)
      # git is only supprted type right now
      working_dir = repo_dirname(name, type)
      unless  @repositories[type][name]
        @repositories[type][name] = working_dir
        if @git_mode == :reclone
          FileUtils.rm_rf(working_dir) # Clear it out
          success = system("git clone #{name} #{working_dir}")
          raise "git clone failed" unless success
        end
      end
      working_dir
    end

    def copy_module(name, source_path, branch='master')
      current_branch = `cd #{source_path} && env -u GIT_DIR git symbolic-ref --short HEAD`.strip
      if current_branch != branch
        success = system("cd #{source_path} && env -u GIT_DIR git checkout #{branch}")
        raise "git checkout failed" unless success
      end
      target = File.join(@module_dir,name)
      FileUtils.rm_rf(target)
      FileUtils.cp_r(source_path, target, preserve: true)
    end

    def pull_from_puppetforge(name)
      target = File.join(@module_dir,name.split("/").last)
      FileUtils.rm_rf(target)
      success = system("puppet module install --target-dir #{@module_dir} #{name}")
      raise "Unable to pull from puppet forge. Verify that puppet is installed and that module name is correct" unless success
    end

    def forge(name)
      @forge = name # This is unused right now, until I figure out what it does in librarian-puppet
    end

    def mod(name, options={})
      puts "Processing module: #{name}"
      if options[:git]
        working_dir = pull_repo(options[:git], :git )
        path = options[:path] || ""
        copy_module(name, File.join(working_dir, path), options[:branch] || 'master')
      else # Assume we are pulling from puppet forge
        pull_from_puppetforge(name)
      end
    end
 end
end
