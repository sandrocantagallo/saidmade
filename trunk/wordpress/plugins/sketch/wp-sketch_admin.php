<?php
/**
 * This class is instance in the Admin evirorment. All admin
 * functionality are include here. The parent object is _CLASS.
 */
class WPSKETCH_ADMIN extends WPSKETCE_CLASS {
	
	function WPSKETC_ADMIN() {
		$this->WPSKETC_CLASS();							// super
		
		$this->initDefaultOption();
	}
	
	/**
	 * Init the default plugin options and re-load from WP
	 * 
	 * @return 
	 */
	function initDefaultOption() {
		$this->options 						= array();
		add_option( $this->options_key, $this->options, $this->options_title );
		
		parent::getOptions();
		
		add_action('admin_menu', 	array( $this, 'hook_options_page') );
	}
	
	/**
	 * ADD OPTION PAGE TO WORDPRESS ENVIRORMENT
	 *
	 * Add callback for adding options panel
	 *
	 */
	function hook_options_page() {
		if ( function_exists('add_options_page') ) {
	 		$plugin_page = add_options_page( $this->options_title, $this->options_title, 8, basename(__FILE__), array( $this, 'hook_options_subpanel') );
			add_action( 'admin_head-'. $plugin_page, array( $this, 'hook_admin_head' ) );
		}
	}
	
	/**
	 * Draw Options Panel
	 */
	function hook_options_subpanel() {
		global $wpp_options, $wpdb, $_POST;
	
		$any_error = "";										// any error flag
	
		if( isset( $_POST['command_action'] ) ) {				// have to save options	
			$any_error = 'Your settings have been saved.';
	
			switch( $_POST['command_action'] ) {
				case "mysql_insert":
					$any_error = $this->mysql_insert();
					break;
				case "mysql_delete":
					$any_error = $this->mysql_delete();
					break;		
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
		?>
		
		<div class="wrap">
	    <h2><?=$this->options_title?> ver. <?=$this->version?></h2>
	
	
			<p style="text-align:center;font-family:Tahoma;font-size:10px">Developed by <a target="_blank" href="http://www.saidmade.com"><img align="absmiddle" src="http://labs.saidmade.com/images/sm-a-80x15.png" border="0" /></a>
				<br/>
				more Wordpress plugins on <a target="_blank" href="http://labs.saidmade.com">labs.saidmade.com</a> and <a target="_blank" href="http://www.undolog.com">Undolog.com</a>
				<br/>
				<form style="text-align:center;width:300px;margin:0 auto" action="https://www.paypal.com/cgi-bin/webscr" method="post">
					<input type="hidden" name="cmd" value="_s-xclick">
					<input type="hidden" name="hosted_button_id" value="3499468">
					<input type="image" src="https://www.paypal.com/it_IT/IT/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - Il sistema di pagamento online pi� facile e sicuro!">
					<img alt="" border="0" src="https://www.paypal.com/it_IT/i/scr/pixel.gif" width="1" height="1">
				</form>
			</p>	
	
		</div>
		
		<?php
		
	}
	
	/**
	 * Hook the admin/plugin head
	 * 
	 * @return 
	 */
	function hook_admin_head() {
	?>
	<style type="text/css">
	</style>
	<script type="text/javascript">
	</script>
	<?php
	}
	
} // end of class

?>