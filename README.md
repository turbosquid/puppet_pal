## Puppet Pal!

The puppet-pal is a lightweight replacement for librarian-puppet. For
our use cases here at turbosquid, it performs far faster than librarian
puppet, and is less buggy. Most of our puppet modules come from a single
repository at github, or from a private repo, with the occassional
module coming from puppet forge. 

Because puppet-pal only pulls down a given repo once in a session, it is
very fast for this use case. It also does not attempt to resolve
dependencies, so it does not depend on the puppet gem (or even puppet)
being present on the host, unless you are pulling something from
puppet forge, in which case you will need puppet installed (although not
in gem form, unless you choose to do so).

There is no lockfile, since we don't worry about dependencies

## Installation

`gem install puppet_pal` 

## Usage

In the directory that contains your Puppetfile, simply run `puppet-pal`.
puppet-pal will install the requested modules into the `modules/`
directory. Puppet Pal understands a subset of the Puppetfile commands
understood by librarian-puppet:

### mod

The `mod` command installs a module. The single required parameter
'name' indentifies the module to be installed. If no other options are
specified, then the module is pulled from puppetforge (via a `puppet
module install` call). 

Otherwise, you may pass the `:git` option to specify a git repo, as well as a `:path`
and/or `:branch` option to specify a particular path within that repo.

### forge
For backward compatibility -- does nothing

### Example Puppetfile

    forge "http://forge.puppetlabs.com"

    mod 'puppetlabs/stdlib'

    puppet_common_git = "git@foo.bar.com:myrepo/puppet-common.git"

    mod 'base_packages',
      :git => puppet_common_git,
      :path=> "modules/base_packages"
    mod 'solr',
      :git => puppet_common_git,
      :path=> "modules/solr",
      :branch => "develop"
    mod 'mysql',
      :git => puppet_common_git,
      :path=> "modules/mysql"
    mod 'digglr',
      :git => puppet_common_git,
      :path=> "modules/digglr"
    mod 'rvm',
      :git => puppet_common_git,
      :path=> "modules/rvm"
    mod 'deployment_utils',
      :git => puppet_common_git,
      :path=> "modules/deployment_utils"
    mod 'python_web',
      :git => puppet_common_git,
      :path=> "modules/python_web"
    mod 'apache',
      :git => puppet_common_git,
      :path=> "modules/apache"
    mod 'collectd',
      :git => puppet_common_git,
      :path=> "modules/collectd"

### Additional command line options

* `--puppet_file -f ` Specify a puppetfile path other than the default





