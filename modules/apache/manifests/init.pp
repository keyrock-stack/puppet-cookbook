class apache {
    File {
      owner => 'lkwan',
      group => 'lkwan',
      mode => 0644,
    }

file {'/var/www/html/index.html':
    content => "<html><body><h1><a      href='cookbook.html'>Cookbook3!      </a></h1></body></html>\n",  
}

file {'/var/www/html/cookbook.html':    content =>      "<html><body><h2>PacktPub 3</h2></body></html>\n",  
}

}
