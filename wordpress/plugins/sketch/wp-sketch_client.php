<?php
/**
 * This class contains all methods and properties for front-end.
 * This object is a extends of _CLASS object. It's instance only
 * when the front-end is active.
 *  
 */
class WPSKETCH_CLIENT extends WPSKETCH_CLASS {
	
	function WPSKETCH_CLIENT() {
		$this->WPSKETCH_CLASS();							// super
		
		parent::getOptions();								// retrive options from database
	}
	
	/**
	 * Skecth
	 * 
	 * @return 
	 * @param object $args
	 * 
	 */
	function sketch( $args = '' ) {
		// todo
	}	
} // end of class

?>