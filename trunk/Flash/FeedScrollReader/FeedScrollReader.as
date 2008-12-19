package {
	/**
	 * Feed Scroll Reader
	 *
	 * Lettore di Feed RSS con scrolling dei titoli
	 *
	 * Feed Scroll Reader is released under version 3.0 of the Creative Commons Attribution-
	 * Noncommercial-Share Alike license. This means that it is absolutely free
	 * for personal, noncommercial use provided that you 1) make attribution to the
	 * author and 2) release any derivative work under the same or a similar
	 * license.
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
		
		
		function FeedScrollReader() {
			trace( 'FeedScrollReader::constructor' );
			main();
		}
		
		/**
		 * Avvio
		 */
		private function main():void {
			stage.scaleMode 	= StageScaleMode.NO_SCALE;
			stage.align			= StageAlign.TOP_LEFT;
			//
			// prelevo le informazioni passate runtime al filmato sulla pagina
			// se queste sono null ne imposto alcune di default
			_params				= loaderInfo.parameters;
			if( _params.length == undefined) _params = { speed			: 15,
														 style			: 'style.css',
														 separator		: ' * ',
														 description	: false,
														 wordcut		: 50,
														 feedurl		: 'http://www.undolog.com/feed'
														};
			// imposto il timer
			_timer = new Timer( _params.speed );
			_timer.addEventListener( TimerEvent.TIMER, scrolling );
			
			// carico i feed			
			loadFeed();
		}
		
		/**
		 * Carica i feed
		 */
		private function loadFeed():void {
			_loader = new URLLoader( new URLRequest( _params.feedurl ) );
			_loader.addEventListener(Event.COMPLETE, 
				function ( e:Event ):void {
					_rssXML 	= XML( _loader.data );
					for each (var item:XML in _rssXML..item) {
						var itemTitle		:String 	= item.title.toString();
						var itemDescription	:String 	= item.description.toString().substr(0, _params.wordcut)+'[...]';
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
		 * Carica il foglio di stile per il rendering dello scrolling
		 */
		private function loadCSS():void {
            _loader = new URLLoader( new URLRequest( _params.style ) );
            _loader.addEventListener(Event.COMPLETE, 
				function ( e:Event ):void {
					_style	= new StyleSheet();
					_style.parseCSS( _loader.data );
					initScroll();
				}
			);
		}
		
		/**
		 * Crea un testo 'lungo' in formato HTML con la lista dei feed
		 */
		private function initScroll():void {
			_scrollText			= new TextField();
			_scrollText.x		= stage.stageWidth;
			//
			_scrollText.htmlText 		= '';
			_scrollText.cacheAsBitmap	= true;
			_scrollText.styleSheet		= _style
			_scrollText.autoSize		= TextFieldAutoSize.LEFT;
			_scrollText.wordWrap		= false;
			_scrollText.htmlText 		= _output;
			//
			addEventListener( MouseEvent.ROLL_OVER, function(e:MouseEvent) { _pause = true; } );
			addEventListener( MouseEvent.ROLL_OUT, function(e:MouseEvent) { _pause = false; } );
			//
			addChild( _scrollText );
			//
			_timer.start();
		}
		
		/**
		 * Esegue lo scrolling vero e proprio. Questa funzione viene richiamata
		 * ogni n millisecondi in base alle impostazioni ricevuti in loaderInfo.
		 */
		private function scrolling(e:TimerEvent):void {
			if( !_pause) {
				_scrollText.x--;
				if( _scrollText.x < -_scrollText.width ) _scrollText.x = stage.stageWidth;
			}
		}
	}
}