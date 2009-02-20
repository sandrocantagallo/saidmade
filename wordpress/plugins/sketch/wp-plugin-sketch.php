<?php
/*
Plugin Name: [[NAME OF PLUGIN]]
Plugin URI: [[ADDRESS OF PLUGIN]]
Description: [[DESCRIPTION]]
Version: [[VERSION]]
Author: [[AUTHOR'S NAME]]
Author URI: [[AUTHOR'S URL]]
Disclaimer: Use at your own risk. No warranty expressed or implied is provided.
 
	Copyright [[YEAR]] [[AUTHOR'S NAME]] (email : [[AUTHOR'S EMAIL]])

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
	
	
	CHANGE LOG
	
	* [[VERSION]]		[[NOTE]]

*/

// ________________________________________________________________________________________ MAIN

/**
 * DEFINE CONSTANT
 *
 * All constant are defined here
 */
define( 'PLUGINNAME',	'[[PLUGIN NAME]]' );
define( 'OPTIONSKEY',	'[[KEY OPTIONS]]' );
define( 'OPTIONSTITLE',	'[[OPTIONS TITLE]]' );
define( 'VERSION',		'[[VERSION]]' );


/**
 * INIT OPTIONS
 *
 * The default options are stored in this array ( key => default value )
 * The global plugin variables have a $wpp_ prefix (wordpress plugin)
 */
$wpp_options = array(
				  'opt1' => 'opt1',
				  'opt2' => 'opt2'
				);

/**
 * Add to Wordpress options database
 */
add_option( OPTIONSKEY, $wpp_options, OPTIONSTITLE );

/**
 * re-Load options
 */
$wpp_options = get_option( OPTIONSKEY );


// ________________________________________________________________________________________ OPTIONS

/**
 * ADD OPTION PAGE TO WORDPRESS ENVIRORMENT
 *
 * Add callback for adding options panel
 *
 */
function wpp_options_page() {
	if ( function_exists('add_options_page') ) {
 		add_options_page( OPTIONSTITLE, OPTIONSTITLE, 8, basename(__FILE__), 'wpp_options_subpanel');
	}
}

/**
 * Draw Options Panel
 */
function wpp_options_subpanel() {
	global $wpp_options, $_POST;

	$any_error = "";										// any error flag

	if( isset($_POST['flag_save'] ) ) {						// have to save options
		$any_error = 'Your settings have been saved.';
		
		/**
		 * Check for any missing or wrong POST value
		 */
		if( $_POST['test'] == '' ) {		
			$any_error = 'Some field is empty! Check and try again!';
		} else {
			$wpp_options['opt1'] 	= $_POST['test'];
			
			update_option( OPTIONSKEY, $wpp_options);
		}
	}
	
	/**
	 * Show error or OK
	 */
	if( $any_error != '') echo '<div id="message" class="updated fade"><p>' . $any_error . '</p></div>';
	
	/**
	 * INSERT OPTION
	 *
	 * You can include a separate file: include ('options.php');
	 *
	 */
	
}

/**
 * Link my custom option to admin menu
 *
 */ 
add_action('admin_menu', 	'wpp_options_page');

/**
 * Some add_action(), add_filter() for example
 *
 * add_action("wp_head", 		'wpp_header');
 */

?>