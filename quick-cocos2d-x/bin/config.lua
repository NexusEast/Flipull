   return array(
        'src'      => '/Users/omicron_nega/Projects/scripts',
        'output'   => '/Users/omicron_nega/Projects/summoner/res/game.dat', 
        'prefix'   => '',
        'excludes' => '',
        'compile'  => '',
        'encrypt'  => '',
        'key'      => 'ewd',  
        'sign'     => '',
        'extname'  => ,
    );
 
    
compile_scripts -i /Users/omicron_nega/Projects/scripts -o /Users/omicron_nega/Projects/summoner/res/game.dat -e xxtea_zip -ek MYKEY

 