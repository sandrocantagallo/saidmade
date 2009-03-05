<?php
/**
 * This Class is the "parent" main class. All common methods and propertis
 * are setting in this object. For specify methods in client side or in
 * admin side, see _CLIENT and _ADMIN classes.
 *  
 */

class WPSKETCH_CLASS {
		
	/**
	 * @internal
	 * @staticvar
	 */
	var $version 							= "1.0.0";				// plugin version
	var $plugin_name 						= "WP Sketch";			// plugin name
	var $options_key 						= "wp-sketch";			// options key to store in database
	var $options_title						= "WP Sketch";			// label for "setting" in WP
	
	var $table_bannerize					= 'sketch';
	
	/**
	 * Usefull vars
	 * @internal 
	 */
	var $content_url						= "";
	var $plugin_url							= "";
	
	var $uploads_url						= "";
	var $uploads_path 						= "";

	/**
	 * This properties variable are @public
	 * 
	 * @property
	 *  
	 */
	var $options							= array();

	/**
	 * @constructor 
	 */
	function WPSKETCH_CLASS() {
		$this->content_url 					= get_option('siteurl') . '/wp-content';
		$this->plugin_url 					= $this->content_url . '/plugins/' . plugin_basename(dirname(__FILE__)) . '/';
		
		$this->uploads_url					= get_option('siteurl') . '/wp-content/uploads/';
		$this->uploads_path					= realpath( dirname(__FILE__) . '/../../uploads/' ) . '/';
	}
	
	/**
	 * Get option from database
	 * 
	 * @return 
	 */
	function getOptions() {
		$this->options 						= get_option( $this->options_key );
	}	
	
	/**
	 * Check the Wordpress relase for more setting
	 * 
	 * @return 
	 */
	function checkWordpressRelease() {
		global $wp_version;
		if ( strpos($wp_version, '2.7') !== false || strpos($wp_version, '2.8') !== false  ) {}
	}	
} // end of class

?>