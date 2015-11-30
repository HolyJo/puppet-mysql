class mysql::install($db_username, $db_password) {
    package { 'mysql-server':
        ensure => installed
    }

    service { 'mysqld':
        ensure => 'running',
        enable => true,
        hasrestart => true,
        hasstatus => true,
        subscribe => Package['mysql-server'],
    }

    exec { 'create-db':
        unless => "/usr/bin/mysql -u${db_username} -p${db_password}",
        command => "/usr/bin/mysql -uroot -e \"GRANT ALL PRIVILEGES ON *.* TO ${db_username}@localhost IDENTIFIED BY '${db_password}';\"",
        require => Service["mysqld"],
    }
}

class mysql::install-wordpress-db($wordpress_db_username, $wordpress_db_password) {

    exec { 'create-db':
        unless => "/usr/bin/mysql -u${wordpress_db_username} -p${wordpress_db_password}",
        command => "/usr/bin/mysql -uroot -e \"GRANT ALL PRIVILEGES ON *.* TO ${db_username}@localhost IDENTIFIED BY '${wordpress_db_password}';\"",
        require => Service["mysqld"],
    }

}


class mysql($db_username, $db_password) {
    class { 'mysql::install':
        db_username => $db_username,
        db_password => $db_password
    }
}
