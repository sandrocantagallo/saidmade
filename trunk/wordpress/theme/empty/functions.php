<?php

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
 * Inserire questo codice nel file functions.php
 * Esclude dalla ricerca le pagine/post con id 58
 */
function search_filter($query) {
	if ($query->is_search) {
		$query->set('post__not_in', array(58));
	}
	return $query;
}
add_filter('pre_get_posts','search_filter');


    
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
 * Recupera le immagini collegate ad un post, ordinandole
 * in base all'ordinamento della galleria
 * 
 * @param	$post_id	ID del post dal quale recuperae le immagini
 * @return				array()
 * 
 */
function get_post_images($post_id, $only_url = false, $thumbnail = false) {
	$ret = array();
	$ai =& get_children('post_type=attachment&post_mime_type=image&post_parent=' . $post_id );
	usort( $ai, "sortImage");
	if($only_url) {
		foreach($ai as $image) {
			if($thumbnail) array_push( $ret,  wp_get_attachment_thumb_url( $image->ID )  );
			else array_push( $ret,  wp_get_attachment_url( $image->ID )  );
		}
	} else {	
		foreach($ai as $image) {
		   array_push( $ret, '<img alt="' . $image->post_title . '" src="' . wp_get_attachment_url( $image->ID ) . '" />' );
		}
	}
	return $ret;
}
function sortImage( $a, $b ) {
	if($a->menu_order == $b->menu_order) return 0;
	return ($a->menu_order> $b->menu_order) ? 1 : -1;
	//return ($a->menu_order> $b->menu_order) ? -1 : 1; // decrescente
}

/**
 * Recupera, se presente, una o piu' immagini da un post
 *
 * @param    $n             (uint) Numero dell'immagine da estrarre: trovata nell'ordine di impaginazione
 * @retrun                  Immagine
 */
function ul_get_image_post($n=0) {
    global $post;
    preg_match( '~<img [^\>]*\ />~', $post->post_content, $res );
    return $res[ $n ];
}   
 
?>