package {
	/**
	 * Feed Scroll Reader
	 *
	 * Feed Scroll Reader is a Flash Feed Reader with horizontal scrolling. You
	 * can set some options from object data value or from MIME GET in the swf
	 * file. For example:
	 *
	 * <object data="flash/filmato.swf?scrollspeed=5" type="application/x-shockwave-flash" 
	 * height="200" width="200"></object>
	 *
	 * <object data="flash/filmato.swf" type="application/x-shockwave-flash" height="200" width="200">
	 * 		<param value="scrollspeed=5" name="flashvars" />
	 * </object>
	 *
	 * @param	(boolean)	description	True for showing description feed too. [default=false]
	 * @param	(string)	feedurl		Feed URL address. [default='http://www.undolog.com']
	 * @param	(uint)		scrollspeed	Scroll speed ms. [default=15]
	 * @param	(string)	separator	HTML string between feed item. [default=' * ']
	 * @param	(uint)		stringcut	Char number for cut description. [default=50]
	 * @param	(string)	stylesheet	StyleSheet URL address. [default='style.css']
	 *
	 * Feed Scroll Reader is released under version 3.0 of the Creative Commons 
	 * Attribution-Noncommercial-Share Alike license. This means that it is 
	 * absolutely free for personal, noncommercial use provided that you 1)
	 * make attribution to the author and 2) release any derivative work under
	 * the same or a similar license.
	 *
	 * This program is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	 *
	 * If you wish to use Feed Scroll Reader for commercial purposes, licensing information
	 * can be found at http://www.saidmade.com
	 *
	 * @author		Giovambattista Fazioli
	 * @email		g.fazioli@saidmade.com
	 * @web			http://www.saidmade.com
	 * @rel			http://www.undolog.com
	 *
	 */
	 
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.system.System;
	import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.ui.ContextMenuBuiltInItems;
	import flash.utils.Timer;
	import flash.net.*;	
	 
	public class FeedScrollReader extends MovieClip {
		// _______________________________________________________________ STATIC

		static public const NAME				:String			= "Feed Scroll Reader";
		static public const VERSION				:String 		= "0.2";
		static public const AUTHOR				:String 		= "Giovambattista Fazioli <g.fazioli@saidmade.com>";

		// _______________________________________________________________ INTERNAL
		private var _scrollText					:TextField;
		private var _style						:StyleSheet;
		private var _loader						:URLLoader;
		private var _pause						:Boolean		= false;
		private var _timer						:Timer;
		private var _params						:Object;
		private var _rssXML						:XML;
		private var _output						:String			= '';
		
		/**
		 * Feed Scroll Reader constructor
		 *
		 * @internal
		 */
		function FeedScrollReader() {
			trace( 'FeedScrollReader::constructor' );
			main();
		}
		
		/**
		 * Feed Scroll Reader main
		 *
		 * @private
		 */
		private function main():void {
			stage.scaleMode 	= StageScaleMode.NO_SCALE;		// no-size
			stage.align			= StageAlign.TOP_LEFT;			// align to top left

			/**
			 * Default options for Feed Scroll Reader
			 */
			_params				= loaderInfo.parameters;
			if( _params.length == undefined) _params = { scrollspeed	: 15,
														 stylesheet		: 'style.css',
														 separator		: ' * ',
														 description	: false,
														 stringcut		: 50,
														 feedurl		: 'http://www.undolog.com/feed'
														};
			/**
			 * Set the Timer for scroll
			 */
			_timer = new Timer( _params.scrollspeed );
			_timer.addEventListener( TimerEvent.TIMER, scrolling );
			
			loadFeed();				// load feed
		}
		
		/**
		 * Read Feed RSS from URL
		 *
		 * @private
		 */
		private function loadFeed():void {
			_loader = new URLLoader( new URLRequest( _params.feedurl ) );
			_loader.addEventListener(Event.COMPLETE, 
				function ( e:Event ):void {
					_rssXML 	= XML( _loader.data );
					for each (var item:XML in _rssXML..item) {
						var itemTitle		:String 	= item.title.toString();
						var itemDescription	:String 	= item.description.toString().substr(0, _params.stringcut)+'[...]';
						var itemLink		:String 	= item.link.toString();
						var buf				:String 	= '<a href="'+itemLink+'">'+itemTitle+'</a>'+
						                                  ( _params.description ? ' - <p>'+itemDescription+'</p>' : '' );
						_output += (_output == '')?buf:(' '+_params.separator+' '+buf);
					}
					loadCSS();
				}
			);
		}

		/**
		 * Load StyleSheet
		 *
		 * @param
		 */
		private function loadCSS():void {
            _loader = new URLLoader( new URLRequest( _params.stylesheet ) );
            _loader.addEventListener(Event.COMPLETE, 
				function ( e:Event ):void {
					_style	= new StyleSheet();
					_style.parseCSS( _loader.data );
					initScroll();
				}
			);
		}
		
		/**
		 * Init the HTML TextField
		 *
		 * @private
		 */
		private function initScroll():void {
			_scrollText			= new TextField();
			_scrollText.x		= stage.stageWidth;
			//
			_scrollText.htmlText 		= '';						// empty string
			_scrollText.cacheAsBitmap	= true;						// cache like bitmap
			_scrollText.styleSheet		= _style					// set the style sheet
			_scrollText.autoSize		= TextFieldAutoSize.LEFT;	// autosize width
			_scrollText.wordWrap		= false;					// no word wrap
			_scrollText.htmlText 		= _output;					// feed
			
			/**
			 * Set Event for Mouse roll over and roll out stop scrolling
			 */
			addEventListener( MouseEvent.ROLL_OVER, function(e:MouseEvent) { _pause = true; } );
			addEventListener( MouseEvent.ROLL_OUT, function(e:MouseEvent) { _pause = false; } );
			
			addChild( _scrollText );								// add text
			_timer.start();											// start scroll
		}
		
		/**
		 * This funzion is trigged by Timer every _param.scrollspeed milliseconds
		 * 
		 * @private
		 */
		private function scrolling(e:TimerEvent):void {
			if( !_pause) {
				_scrollText.x--;
				if( _scrollText.x < -_scrollText.width ) _scrollText.x = stage.stageWidth;
			}
		}
	}
}