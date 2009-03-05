<?php
/**
 * Wrap standard functions. This is a utility file. For comodity
 * you can use a standard wordpress linear function instead
 * $object->method() syntax.
 */


/** 
 * Function description
 * 
 * @return 
 * @param object $args[optional]
 *
 */
function wp_sketch( $args = '' ) {
	global $wp_sketch_client;
	$wp_sketch_client->sketch( $args );
}

?>