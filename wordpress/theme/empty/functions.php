<?php
	/**
	 * Functions.php - some usefull functions
	 *
	 * LIST OF FUNCTIONS
	 *
	 * ul_get_custom_field()
	 * ul_get_image_post()
	 *
	 * @author		Giovambattista Fazioli
	 * @email		g.fazioli@saidmade.com
	 * @web			http://www.saidmade.com
	 * @rel			http://www.undolog.com
	 *
	 * CHANGELOG
	 *	0.1			First release
	 *
	 */	

/**
 * Standard Wordpress sidebar register
 *
 * @internal
 */
if ( function_exists('register_sidebar') )
    register_sidebar(array(
        'before_widget' => '<li id="%1$s" class="widget %2$s">',
        'after_widget' => '</li>',
        'before_title' => '<h2 class="widgettitle">',
        'after_title' => '</h2>',
    ));
    
    
/**
 * Recupera un custom field
 * 
 * @param    $k    (String) Chiave/ID del custom field
 *
 * @return                  Valore del Custom Field
 */
function ul_get_custom_field( $k ) {
    global $post;
    return( get_post_meta( $post->ID, $k, true ) );
}

/**
 * Recupera, se presente, una o più immagini da un post
 *
 * @param    $n             (uint) Numero dell'immagine da estrarre: trovata nell'ordine di impaginazione
 * @retrun                  Immagine
 */
function ul_get_image_post( $n=0 ) {
    global $post;
    preg_match( '~<img [^\>]*\ />~', $post->post_content, $res );
    return $res[ $n ];
}    
?>