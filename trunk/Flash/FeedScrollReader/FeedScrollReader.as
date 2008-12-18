package {
	/**
	 * Lettore di Feed RSS con scrolling dei titoli
	 *
	 * @author		Giovambattista Fazioli
	 * @email		g.fazioli@saidmade.com
	 * @web			http://www.saidmade.com
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
		static public const VERSION				:String 		= "0.1";
		static public const AUTHOR				:String 		= "Giovambattista Fazioli <g.fazioli@saidmade.com>";

		// _______________________________________________________________ INTERNAL
		private var _feed						:Array;
		private var _scrollText					:TextField;
		private var _style						:StyleSheet;
		private var _loader						:URLLoader;
		private var _pause						:Boolean		= false;
		private var _timer						:Timer;
		
		
		function FeedScrollReader() {
			trace( 'FeedScrollReader::constructor' );
			main();
		}
		
		private function main():void {
			stage.scaleMode 	= StageScaleMode.NO_SCALE;
			stage.align			= StageAlign.TOP_LEFT;
			//
			_timer = new Timer(10);
			_timer.addEventListener( TimerEvent.TIMER, scrolling );
			//			
			loadFeed();
			loadCSS();
		}
		
		/**
		 * Carica il foglio di stile per il rendering dello scrolling
		 */
		private function loadCSS():void {
			
			var req:URLRequest = new URLRequest("style.css");
			//
            _loader = new URLLoader();
            _loader.addEventListener(Event.COMPLETE, 
				function ( e:Event ):void {
					_style	= new StyleSheet();
					_style.parseCSS( _loader.data );
					initScroll();
				}
			);
            _loader.load(req);
		}
		
		/**
		 * Carica i feed
		 */
		private function loadFeed():void {
			_feed = new Array();
			//
			_feed.push( { title: 'Rilasciato senza ombra di dubbio il nuovo sistema 3', url: 'http://www.undolog.com' } );
			_feed.push( { title: 'jQuery ancient comment', url: 'http://www.saidmade.com' } );
			_feed.push( { title: 'Internet Explorer 6: una sola', url: 'http://labs.saidmade.com' } );
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
			for each( var item in _feed ) {
				_scrollText.htmlText += (_scrollText.htmlText == '')?('<a href="'+item.url+'">'+item.title+'</a>'):(' - <a href="'+item.url+'">'+item.title+'</a>');
			}
			//
			addEventListener( MouseEvent.ROLL_OVER, function(e:MouseEvent) { _pause = true; } );
			addEventListener( MouseEvent.ROLL_OUT, function(e:MouseEvent) { _pause = false; } );
			//
			addChild( _scrollText );
			//
			_timer.start();
		}
		
		/**
		 * Esegue lo scrolling
		 */
		private function scrolling(e:TimerEvent):void {
			if( !_pause) {
				_scrollText.x--;
				if( _scrollText.x < -_scrollText.width ) _scrollText.x = stage.stageWidth;
			}
		}
	}
}