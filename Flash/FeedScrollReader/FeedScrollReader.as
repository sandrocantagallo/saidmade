package {
	/**
	 * Feed Scroll Reader
	 *
	 * Feed Scroll Reader is a Flash Feed Reader with horizontal scrolling. You
	 * can set some options from object data value or from MIME GET in the swf
	 * file. For example:
	 *
	 * <object data="feedscrollreader.swf?scrollspeed=5" type="application/x-shockwave-flash" 
	 * height="200" width="200"></object>
	 *
	 * <object data="feedscrollreader.swf" type="application/x-shockwave-flash" height="200" width="200">
	 * 		<param value="5" name="scrollspeed" />
	 * </object>
	 *
	 * @param	(boolean)	description	True for showing description feed too. [default=false]
	 * @param	(string)	feedurl		Feed URL address. [default='http://www.undolog.com']
	 * @param	(uint)		scrollspeed	Scroll speed ms. [default=15]
	 * @param	(string)	separator	HTML string between feed item. [default=' * ']
	 * @param	(uint)		stringcut	Char number for cut description. [default=50]
	 * @param	(string)	stylesheet	StyleSheet URL address. [default='style.css']
	 * @param	(number)	bgcolor		Background color
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
	 * CHANGELOG
	 *
	 * + 0.7.3			Minor bug fix on scrollspeed
	 * + 0.7.2			Add Saidmade banner to end of scroll
	 * + 0.7.1			Minor bugs fix on sync refresh
	 * + 0.7.0			Improve Scrolling text with Undolibrary Scroll class and Add bgcolor param
	 * + 0.6.4			Improve scrolling engine
	 * + 0.6.1			Rev comment code
	 * + 0.6			Rewrite _params settings	
	 * + 0.5			Add removeEventListener() and change loading sequence
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
	
	import undolibrary.sfx.*;
	 
	public class FeedScrollReader extends MovieClip {
		// _________________________________________________________________________________________________________ STATIC

		static public const NAME				:String			= "Feed Scroll Reader";
		static public const VERSION				:String 		= "0.7.3";
		static public const AUTHOR				:String 		= "Giovambattista Fazioli <g.fazioli@saidmade.com>";

		// _________________________________________________________________________________________________________ INTERNAL

		private var _params						:Object;
		private var _rssXML						:XML;
		private var _strings					:Array;
		private var _scroll						:Scroll;
		private var _loader						:URLLoader;
		private var _style						:StyleSheet;


		/**
		 * Feed Scroll Reader constructor
		 *
		 * @internal
		 */
		function FeedScrollReader() {
			addEventListener( Event.ADDED_TO_STAGE, main );
		}
		
		/**
		 * Feed Scroll Reader main
		 *
		 * @private
		 */
		private function main(e:Event = null):void {
			removeEventListener( Event.ADDED_TO_STAGE, main );
			stage.addEventListener( Event.RESIZE, function() {
				loader_anim.x = ( stage.stageWidth - loader_anim.width ) / 2;
				loader_anim.y = ( stage.stageHeight - loader_anim.height ) / 2;
				//															
				try {
					_scroll.width = stage.stageWidth;
					_scroll.height = stage.stageHeight; 
				} catch(e) {}
			});
			//
			stage.scaleMode 	= StageScaleMode.NO_SCALE;		// no-size
			stage.align			= StageAlign.TOP_LEFT;			// align to top left
			
			/**
			 * Set context menu
			 */
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems ();
			//
			var refre:ContextMenuItem = new ContextMenuItem("Refresh Feed", false, true);
			var devby:ContextMenuItem = new ContextMenuItem("Developed by Saidmade Srl - Ver. " + VERSION, true, true);
			var ginfo:ContextMenuItem = new ContextMenuItem("More Plugins...", false, true);
			// init context menu events
			refre.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
				function(e:ContextMenuEvent):void {
					try {
						var child = getChildByName('scroll_object');
						removeChild( child );
					} catch(e) {}
					loadFeed();
				}
			);
			devby.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
				function(e:ContextMenuEvent):void {
					navigateToURL ( new URLRequest("http://www.undolog.com"), "_blank");
					navigateToURL ( new URLRequest("http://www.saidmade.com"), "_blank");
				}
			);
			
			ginfo.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
				function(e:ContextMenuEvent):void {
					navigateToURL ( new URLRequest("http://labs.saidmade.com/"), "_blank");
				}
			);
			//
			cm.customItems = [refre, devby,  ginfo];
			this.contextMenu = cm;
			
			/**
			 * Default options for Feed Scroll Reader
			 */
			_params				= loaderInfo.parameters;
			
			_params.scrollspeed	= Number( ( _params.scrollspeed == undefined ) ? 25 : _params.scrollspeed );
			_params.stylesheet	= ( _params.stylesheet == undefined ) ? 'style.css' : _params.stylesheet;
			_params.separator	= ( _params.separator == undefined ) ? ' * ' : _params.separator;
			_params.description	= ( _params.description == undefined ) ? '0' : _params.description;
			_params.stringcut	= ( _params.stringcut == undefined ) ? '50' : _params.stringcut;
			_params.feedurl		= ( _params.feedurl == undefined ) ? 'http://labs.saidmade.com/feed' : _params.feedurl;
			_params.usegateway	= ( _params.usegateway == undefined ) ? '' : _params.usegateway;
			_params.bgcolor		= ( _params.bgcolor == undefined ) ? 0xffffff : parseInt(_params.bgcolor);
			
			loadFeed();				// load feed

		}
		
		/**
		 * Read Feed RSS from URL
		 *
		 * @private
		 */
		private function loadFeed():void {
			loader_anim.x = ( stage.stageWidth - loader_anim.width ) / 2;
			loader_anim.y = ( stage.stageHeight - loader_anim.height ) / 2;
			loader_anim.visible = true;
			_loader = new URLLoader( new URLRequest( ( (_params.usegateway == '') ? _params.feedurl : _params.usegateway ) ) );
			_loader.addEventListener(Event.COMPLETE, 
				function ( e:Event ):void {
					_rssXML 	= XML( _loader.data );
					_strings	= [];
					for each (var item:XML in _rssXML..item) {
						if( _strings.length > 0 ) _strings.push( _params.separator );
						var itemTitle		:String 	= item.title.toString();
						var itemDescription	:String 	= item.description.toString().substr(0, uint(_params.stringcut) )+'[...]';
						var itemLink		:String 	= item.link.toString();
						var buf				:String 	= '<a target="_blank" href="'+itemLink+'">'+itemTitle+'</a>'+
						                                  ( (_params.description == '1') ? ' - <p>'+itemDescription+'</p>' : '' );
						_strings.push( buf );
					}
					_strings.push( ' <p>- Developed by</p> ' );
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
			_scroll						= new Scroll( stage.stageWidth, stage.stageHeight );
			_scroll.name				= 'scroll_object';
			
			_scroll.speed				= _params.scrollspeed;
			_scroll.borderInWidth 		= 32;	
			_scroll.borderOutWidth 		= 32;
			_scroll.borderInColor 		= _params.bgcolor;
			_scroll.borderOutColor 		= _params.bgcolor;	

			for each( var s in _strings ) {
				var st:TextField	= new TextField();
				//
				st.htmlText 		= '';						// empty string
				st.cacheAsBitmap	= true;						// cache like bitmap
				st.styleSheet		= _style					// set the style sheet
				st.autoSize			= TextFieldAutoSize.LEFT;	// autosize width
				st.wordWrap			= false;					// no word wrap
				st.htmlText 		= s;						// feed
				
				_scroll.addItem( 's', st );
			}
			// 0.7.2 - add saidmade logo to the end of scroll
			var clip:MovieClip = _scroll.addItem( 'saidmade', new LogoSaidmade() );
			clip.useHandCursor = clip.buttonMode = true;
			clip.addEventListener( MouseEvent.CLICK, function() { navigateToURL ( new URLRequest("http://www.saidmade.com"), "_blank"); } );
					
			/**
			 * Set Event for Mouse roll over and roll out stop scrolling
			 */
			addEventListener( MouseEvent.ROLL_OVER, function(e:MouseEvent) { _scroll.pause(); } );
			addEventListener( MouseEvent.ROLL_OUT, function(e:MouseEvent) {  _scroll.resume(); } );
			
			addChild( _scroll );
			_scroll.start();									// start scroll
			loader_anim.visible = false;
		}
			
		/* _____________________________________________________________________________________________________ DEBUG
		private function log( s ):void {
			debug.appendText( '>'+s+'\n' );
		}
		*/
	}
}