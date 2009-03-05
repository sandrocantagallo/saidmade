<?php
/*
Plugin Name: WP-SKETCH
Plugin URI: http://wordpress.org/extend/plugins/wp-sketch/
Description: WP_BANNERIZE is a image banner manager. See <a href="options-general.php?page=wp-bannerize.php">configuration panel</a> for more settings. For more info and plugins visit <a href="http://labs.saidmade.com">Labs Saidmade</a>.
Version: 1.0.0
Author: Giovambattista Fazioli
Author URI: http://labs.saidmade.com
Disclaimer: Use at your own risk. No warranty expressed or implied is provided.
 
	Copyright 2009 Saidmade Srl (email : g.fazioli@undolog.com)

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
	
	* 1.0		First release

*/

require_once( 'wp-sketch_class.php');				// load the core class

if( is_admin() ) {									// check admin
	require_once( 'wp-sketch_admin.php' );			// load admin class
	//
	$wp_sketch_admin = new WPSKETCH_ADMIN();		// create object
} else {
	require_once( 'wp-sketch_client.php');			// load client front-end class
	require_once( 'wp-sketch_functions.php');		// the wrapper utility
	//
	$wp_sketch_client = new WPSKETCH_CLIENT();		// create object
}

?>