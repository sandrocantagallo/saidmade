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
 * Recupera, se presente, una o pi� immagini da un post
 *
 * @param    $n             (uint) Numero dell'immagine da estrarre: trovata nell'ordine di impaginazione
 * @retrun                  Immagine
 */
function ul_get_image_post( $n=0 ) {
    global $post;
    preg_match( '~<img [^\>]*\ />~', $post->post_content, $res );
    return $res[ $n ];
}   

/**
 * This functions (plugin) generates links for the previous and next posts; 
 * the difference between these functions (<code>mw_next_post</code> and <code>mw_previous_post</code>) 
 * and the default WordPress functions <code>next_post</code> and <code>previous_post</code> is that the 
 * new functions accept prefix and postfix strings as the third and fourth parameters of the function.
 * 
 * @version 	1.0
 * @ddate		11 May 2004
 * @author 		Eric A. Meyer
 * @url 		http://meyerweb.com/
 * @see	http://meyerweb.com/eric/tools/wordpress/mw_next_prev.html
 * 
 * mw_next_post('format', 'next', 'prefix', 'postfix', 'title', 'in_same_cat', limitnext, 'excluded_categories'
 * 
 * 
 */ 

function mw_next_post($format='%', $next='next post: ', $prefix='', $postfix='', $title='yes', $in_same_cat='no', $limitnext=1, $excluded_categories='') {
	global $tableposts, $p, $posts, $id, $post, $siteurl, $blogfilename, $wpdb;
	global $time_difference, $single;
	global $querystring_start, $querystring_equal, $querystring_separator;
	if(($p) || ($posts==1) || 1 == $single) {

		$current_post_date = $post->post_date;
		$current_category = $post->post_category;

		$sqlcat = '';
		if ($in_same_cat != 'no') {
			$sqlcat = " AND post_category='$current_category' ";
		}

		$sql_exclude_cats = '';
		if (!empty($excluded_categories)) {
			$blah = explode('and', $excluded_categories);
			foreach($blah as $category) {
				$category = intval($category);
				$sql_exclude_cats .= " AND post_category != $category";
			}
		}

		$now = date('Y-m-d H:i:s',(time() + ($time_difference * 3600)));

		$limitnext--;

		$nextpost = @$wpdb->get_row("SELECT ID,post_title FROM $tableposts WHERE post_date > '$current_post_date' AND post_date < '$now' AND post_status = 'publish' $sqlcat $sql_exclude_cats ORDER BY post_date ASC LIMIT $limitnext,1");
		if ($nextpost) {
			$string = $prefix.'<a href="'.get_permalink($nextpost->ID).'">'.$next;
			if ($title=='yes') {
				$string .= wptexturize(stripslashes($nextpost->post_title));
			}
			$string .= '</a>'.$postfix;
			$format = str_replace('%', $string, $format);
			echo $format;
		}
	}
}

function mw_previous_post($format='%', $previous='previous post: ', $prefix='', $postfix='', $title='yes', $in_same_cat='no', $limitprev=1, $excluded_categories='') {
	global $tableposts, $id, $post, $siteurl, $blogfilename, $wpdb;
	global $p, $posts, $posts_per_page, $s, $single;
	global $querystring_start, $querystring_equal, $querystring_separator;

	if(($p) || ($posts_per_page == 1) || 1 == $single) {

		$current_post_date = $post->post_date;
		$current_category = $post->post_category;

		$sqlcat = '';
		if ($in_same_cat != 'no') {
			$sqlcat = " AND post_category = '$current_category' ";
		}

		$sql_exclude_cats = '';
		if (!empty($excluded_categories)) {
			$blah = explode('and', $excluded_categories);
			foreach($blah as $category) {
				$category = intval($category);
				$sql_exclude_cats .= " AND post_category != $category";
			}
		}

		$limitprev--;
		$lastpost = @$wpdb->get_row("SELECT ID, post_title FROM $tableposts WHERE post_date < '$current_post_date' AND post_status = 'publish' $sqlcat $sql_exclude_cats ORDER BY post_date DESC LIMIT $limitprev, 1");
		if ($lastpost) {
			$string = $prefix.'<a href="'.get_permalink($lastpost->ID).'">'.$previous;
			if ($title == 'yes') {
                $string .= wptexturize(stripslashes($lastpost->post_title));
            }
			$string .= '</a>'.$postfix;
			$format = str_replace('%', $string, $format);
			echo $format;
		}
	}
}

 
?>