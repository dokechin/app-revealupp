Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

exec { 'add-nodesource-repo':
    command => "curl -sL https://deb.nodesource.com/setup | sudo bash -",
}
exec { 'add-ubuntu-git-maintainers-repo':
    command => "add-apt-repository ppa:git-core/ppa",
}

class system-update {
    exec { 'apt-get update':
        command => 'apt-get update',
        require => [Exec['add-nodesource-repo'], Exec['add-ubuntu-git-maintainers-repo']],
  }
}

class system-upgrade {
    exec { 'apt-get upgrade':
            command => 'apt-get upgrade -y',
            require => [Exec['apt-get update'], Exec['add-nodesource-repo'], Exec['add-ubuntu-git-maintainers-repo']],
    }
}

class js_packages {
    package { "nodejs":
            ensure => "latest",
            require => Exec['apt-get upgrade'],
    }
}
class tools_packages {
    package { "git":
        ensure => "latest",
        require => Exec['apt-get upgrade'],
    }
}
class bower_install {
    exec { 'install-bower':
        command => 'npm install -g bower',
        require => Package['nodejs'],
    }
}

class grunt_install {
        exec { 'install-grunt':
                command => 'npm install -g grunt-cli',
                require => Package['nodejs'],
        }
}

class uglify_install {
        exec { 'install-uglify':
                command => 'npm install uglify-js -g',
                require => Package['nodejs'],
        }
}

include system-update
include system-upgrade
include js_packages
include tools_packages
include bower_install
include grunt_install
include uglify_install
