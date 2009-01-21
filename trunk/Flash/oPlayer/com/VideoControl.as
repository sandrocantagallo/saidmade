package com {
	/**
	 * VideoControl Class manage the bottom bar for streaming control
	 * volume control and play/pause function. This class shows the
	 * playlist too
	 *
	 * ---------------------------------------------------------------------------------------
	 * PROPERTIES
	 * ---------------------------------------------------------------------------------------
	 * listVideos		(get)	  MovieClip Item's Array 
	 * toolbar			(get/set) Toolbar show
	 * playlist			(get/set) Playlist show
	 * progress			(get/set) Value of seek knob
	 * progressMax		(get/set) Max value of seek knob
	 * state			(get/set) Play/Pause state
	 * videoIndex		(get)	  Index selected Item video
	 *
	 * ---------------------------------------------------------------------------------------
	 * METHODS
	 * ---------------------------------------------------------------------------------------
	 * clearSelectedPlaylist()	  Clear all item selected in Playlist: avoid ">" on item title
	 * setItemPlaying()			  Set an item
	 *
	 * ---------------------------------------------------------------------------------------
	 * EVENTS
	 * ---------------------------------------------------------------------------------------
	 * none
	 *
	 * @author		Giovambattista Fazioli
	 * @email		g.fazioli@saidmade.com
	 * @web			http://www.saidmade.com
	 * @rel			http://www.undolog.com
	 *
	 */	
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.net.*;
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import undolibrary.ui.*;
	
	public class VideoControl extends MovieClip {
		// _______________________________________________________________ STATIC

		static public const NAME				:String			= "VideoControl";
		static public const VERSION				:String 		= "0.1";
		static public const AUTHOR				:String 		= "Giovambattista Fazioli <g.fazioli@saidmade.com>";
		
		static const PLAYLIST_WIDTH				:uint			= 240;		// width playlist
		static const PLAYLIST_BORDER			:uint			= 10;		// border width playlist
		static const PLAYLIST_BORDER_RADIUS		:uint			= 16;		// border radius playlist
		static const PLAYLIST_SCROLL_WIDTH		:uint			= 10;		// vertical scrollbar width
		static const PLAYLIST_ITEM_WIDTH		:uint			= 200;		// item width
		static const PLAYLIST_ITEM_HEIGHT		:uint			= 30;		// item height
		static const PLAYLIST_ITEM_VISIBLE		:uint			= 4;		// item to show with mask
		static const PLAYLIST_ITEM_GAP			:uint			= 1;		// vertical gap between item
		
		static const KNOB_SEEK_HEIGHT			:uint			= 12;		// seek knob height
		static const KNOB_VOLUME_WIDTH			:uint			= 80;		// volume knob width
		static const KNOB_VOLUME_HEIGHT			:uint			= 12;		// volume knob height
		
		static const TOOLBAR_HEIGHT				:uint			= 32;		// toolbar height
		static const TOOLBAR_ALPHA				:Number			= .9;		// alpha transparent
		static const PLAYLIST_TOOLBAR_GAP		:uint			= 4;		// gap between playlist and toolbar
		
		static const TOOLBAR_HIDE_DELAY			:Number			= 3000;		// in milliseconds
		
		// _______________________________________________________________ INTERNAL
		
		private var _playlist					:XMLList;					// see constructor
		private var _playlist_mc				:MovieClip;					// playlist container
		private var _toolbar_mc					:MovieClip;					// toolbar container
		private var _button_playlist			:SimpleButton;				// playlist button
		private var _button_play				:SimpleButton;				// play button
		private var _button_pause				:SimpleButton;				// pause button
		private var _button_saidmade			:SimpleButton;				// saidmade button
		private var _volume						:Knob;						// Volume (undolibrary) Knob
		private var _seek						:Knob;						// Seek (time) bar Knob
		
		private var _toolbar_visible			:Boolean		= true;		// flog for true show/hide toolbar
		private var _timer_toolbar				:Timer;						// check out of stage
		private var _xms						:Number;					// x mouse on stage
		private var	_yms						:Number;					// y mouse on stage
		
		private var _listVideos					:Array;						// item array list
		private var _index						:uint			= 0;		// index video selected
		
		// _______________________________________________________________ CONSTRUCTOR
		
		function VideoControl( playlist ) {
			_playlist	= playlist;
			addEventListener( Event.ADDED_TO_STAGE, main );
		}
		
		// _______________________________________________________________ MAIN
		
		/**
		 * init all
		 *
		 * @private
		 */
		private function main(e:Event = null):void {
			removeEventListener( Event.ADDED_TO_STAGE, main );

			initToolbar();
			initPlaylist();
			initTimerToolbar();
		}		
		
		// __________________________________________________________ PUBLIC METHODS
		
		/**
		 * Clear all item selected in Playlist: avoid ">" on item title
		 */
		public function clearSelectedPlaylist():void {
			for (var i:uint=0; i < _listVideos.length; i++) _listVideos[i].setPlaying( false );
		}
		
		/**
		 * Set an item in play mode
		 *
		 * @param		i	(uint)		Item's Index
		 * @param		v	(boolean)	TRUE for selected/play, FALSE for unselected
		 */
		public function setItemPlaying(i:uint, v:Boolean = true):void {
			clearSelectedPlaylist();
			_index = i;
			_listVideos[i].setSelected( v );
			_listVideos[i].setPlaying( v );
		}
		
		// _______________________________________________________________ FUNCTIONS
		
		/**
		 * Init the Timer for check out of stage
		 */
		private function initTimerToolbar():void {
			try { _timer_toolbar.stop(); } catch (error:TypeError) { }
			_timer_toolbar	= new Timer( TOOLBAR_HIDE_DELAY );
			_timer_toolbar.addEventListener( TimerEvent.TIMER,
				function(e:TimerEvent):void {
					if( stage.mouseX == _xms && stage.mouseY == _yms ) {
						set_toolbar(false);
						set_playlist(false);
					}
					_xms = stage.mouseX;
					_yms = stage.mouseY;
				}
			);
			_timer_toolbar.start();
		}
		
		/**
		 * Show/Hide Playlist
		 *
		 * @param	v	(boolen) true for show, false to hide
		 *
		 * @private
		 */
		private function set_playlist( v:Boolean ):void {
			if( v && !_playlist_mc.visible ) {
				try { _playlist_mc._tween.stop(); } catch (error:TypeError) { }
				_playlist_mc.visible = true;
				_playlist_mc._tween = new Tween(_playlist_mc, 'y', Strong.easeOut, _playlist_mc.y, ( Math.round( stage.stageHeight - (PLAYLIST_BORDER<<1) - PLAYLIST_TOOLBAR_GAP - TOOLBAR_HEIGHT - (PLAYLIST_ITEM_HEIGHT + PLAYLIST_ITEM_GAP) * PLAYLIST_ITEM_VISIBLE ) ), 1, true);
			}
			
			if( !v && _playlist_mc.visible ) {
				_toolbar_visible = false;
				try { _playlist_mc._tween.stop(); } catch (error:TypeError) { }
				_playlist_mc._tween = new Tween(_playlist_mc, 'y', Strong.easeOut, _playlist_mc.y, stage.stageHeight, 1, true);
				_playlist_mc._tween.addEventListener( TweenEvent.MOTION_FINISH,
					function( e:TweenEvent ):void {
						_playlist_mc.visible = false;
					}
				);
			}
		}
		
		/**
		 * Show/Hide Bottom toolbar
		 *
		 * @param	v	(boolean) true for visible, false for hide
		 *
		 * @private
		 */
		private function set_toolbar(v:Boolean):void {
			if( v && !_toolbar_visible ) {
				_toolbar_visible = _toolbar_mc.visible = true;
				try { _toolbar_mc._tween.stop(); } catch (error:TypeError) { }
				_toolbar_mc._tween = new Tween(_toolbar_mc, 'y', Strong.easeOut, _toolbar_mc.y, ( stage.stageHeight - TOOLBAR_HEIGHT ), 1, true);
			}
			
			if( !v && _toolbar_visible ) {
				_toolbar_visible = false;
				if( _playlist_mc.visible ) set_playlist(false);
				try { _toolbar_mc._tween.stop(); } catch (error:TypeError) { }
				_toolbar_mc._tween = new Tween(_toolbar_mc, 'y', Strong.easeOut, _toolbar_mc.y, stage.stageHeight, 1, true);
				_toolbar_mc._tween.addEventListener( TweenEvent.MOTION_FINISH,
					function( e:TweenEvent ):void {
						_toolbar_mc.visible = false;
					}
				);
			}
		}
		
		/**
		 * Create the toolbar container with all button
		 */
		private function initToolbar():void {
			/**
			 * Create the toolbar container
			 */
			_toolbar_mc 		= new MovieClip();
			_toolbar_mc.alpha	= TOOLBAR_ALPHA;
			_toolbar_mc.x 		= 0;
			_toolbar_mc.y		= stage.stageHeight - TOOLBAR_HEIGHT;
			_toolbar_mc.graphics.beginFill(0x000000);
			_toolbar_mc.graphics.drawRect(0, 0, stage.stageWidth, TOOLBAR_HEIGHT);
			_toolbar_mc.graphics.endFill();
			addChild( _toolbar_mc );
			
			/**
			 * Create Playlist, Pause and Play button
			 */
			_button_playlist	= new ButtonPlaylist();
			_button_playlist.x 		= 2;
			_button_playlist.y 		= 6;
			_toolbar_mc.addChild( _button_playlist );
			 
			_button_play		= new ButtonPlay();
			_button_play.x 		= _button_playlist.width+2;
			_button_play.y 		= _button_playlist.y
			_toolbar_mc.addChild( _button_play );
			
			_button_pause		= new ButtonPause();
			_button_pause.x 	= _button_play.x;
			_button_pause.y 	= _button_play.y;
			_button_pause.visible=false;
			_toolbar_mc.addChild( _button_pause );
			
			_button_saidmade	= new ButtonSaidmade();
			_button_saidmade.x 	= stage.stageWidth-_button_saidmade.width;
			_button_saidmade.y 	= 0;
			_toolbar_mc.addChild( _button_saidmade );			
			
			/**
			 * Init playlist/pause/play buttons events
			 */
			_button_playlist.addEventListener( MouseEvent.CLICK,
				function( e:MouseEvent ):void {
					set_playlist( !_playlist_mc.visible );
				}
			);
			_button_play.addEventListener( MouseEvent.CLICK,
				function( e:MouseEvent ):void {
					dispatchEvent( new VideoControlEvent( VideoControlEvent.PLAY_VIDEO ) );
				}
			);
			_button_pause.addEventListener( MouseEvent.CLICK,
				function( e:MouseEvent ):void {
					dispatchEvent( new VideoControlEvent( VideoControlEvent.PAUSE_VIDEO ) );
				}
			);
			_button_saidmade.addEventListener( MouseEvent.CLICK,
				function( e:MouseEvent ):void {
					navigateToURL ( new URLRequest("http://www.saidmade.com"), "_blank");
				}
			);
			
			/**
			 * Create Volume
			 */
			_volume				= new Knob();
			_volume.width		= KNOB_VOLUME_WIDTH;
			_volume.height		= KNOB_VOLUME_HEIGHT
			_volume.x 			= stage.stageWidth - _button_saidmade.width - _volume.width - 4;
			_volume.y 			= 12;
			_volume.min			= 0;
			_volume.max			= 1;
			_volume.knobColor	= 0xff9900;
			_volume.value		= 1;
			_volume.addEventListener( KnobEvent.CHANGE,
				function( e:KnobEvent ):void {
					dispatchEvent( new VideoControlEvent( VideoControlEvent.CHANGE_VOLUME, false, true, '', e.value ) )
				}
			);		
			_toolbar_mc.addChild( _volume );
			
			
			/**
			 * Create Seekbar Knob control (timing)
			 */
			_seek			= new Knob();
			_seek.x 		= _button_pause.x +_button_pause.width + 4;
			_seek.y 		= 12;
			_seek.width		= stage.stageWidth - _seek.x - KNOB_VOLUME_WIDTH - _button_saidmade.width - 8;
			_seek.height	= KNOB_SEEK_HEIGHT;
			_seek.min		= 0;
			_seek.max		= 1;
			_seek.knobColor	= 0x0096ff;
			_seek.addEventListener( KnobEvent.CHANGE,
				function( e:KnobEvent ):void {
					dispatchEvent( new VideoControlEvent( VideoControlEvent.CHANGE_SEEK, false, true, '', NaN, e.value ) )
				}
			);
			_seek.addEventListener( KnobEvent.START_DRAG,
				function( e:KnobEvent ):void {
					dispatchEvent( new VideoControlEvent( VideoControlEvent.START_CHANGE_SEEK, false, true ) )
				}
			);
			_seek.addEventListener( KnobEvent.STOP_DRAG,
				function( e:KnobEvent ):void {
					dispatchEvent( new VideoControlEvent( VideoControlEvent.END_CHANGE_SEEK, false, true ) )
				}
			);		
			_toolbar_mc.addChild( _seek );
		}
	
		/**
		 * Create PlayList MovieClip container, all item from XML list and
		 * apply the mask for scrolling
		 */
		private function initPlaylist():void {
			if( _playlist_mc != null ) removeChild( _playlist_mc );
			
			var dbb:Number			= PLAYLIST_BORDER*2;
			
			_playlist_mc			= new MovieClip();
			_playlist_mc.alpha		= TOOLBAR_ALPHA;
			_playlist_mc.graphics.beginFill(0x111111);
			_playlist_mc.graphics.drawRoundRect(0, 0, PLAYLIST_WIDTH, dbb+((PLAYLIST_ITEM_HEIGHT + PLAYLIST_ITEM_GAP) * PLAYLIST_ITEM_VISIBLE), PLAYLIST_BORDER_RADIUS, PLAYLIST_BORDER_RADIUS);
			_playlist_mc.graphics.endFill();
			_playlist_mc.x 			= Math.round( (stage.stageWidth - PLAYLIST_WIDTH) >> 1 );
			_playlist_mc.y			= Math.round( stage.stageHeight - (PLAYLIST_BORDER << 1) - PLAYLIST_TOOLBAR_GAP - TOOLBAR_HEIGHT - (PLAYLIST_ITEM_HEIGHT + PLAYLIST_ITEM_GAP) * PLAYLIST_ITEM_VISIBLE );
			
			addChild( _playlist_mc );
			
			/**
			 * scroll container
			 */
			var sc:MovieClip = new MovieClip();
			_playlist_mc.addChild( sc );
			
			/**
			 * Create all group/items
			 *
			*/
			_listVideos				= new Array();
			var index		:uint	= 0;
			var posy		:uint	= 0;
			for each( var g:XML in _playlist ) {
				var t_mc:MovieClip	= createTitle( g.@title );
				t_mc.x				= ( PLAYLIST_WIDTH - PLAYLIST_ITEM_WIDTH - PLAYLIST_SCROLL_WIDTH ) >> 1;
				t_mc.y 				= PLAYLIST_BORDER+(posy * (PLAYLIST_ITEM_HEIGHT + PLAYLIST_ITEM_GAP));
				sc.addChild( t_mc );
				posy++;
				for each( var v:XML in g.video ) {
					var i_mc:MovieClip	= createItem( v.@title, v.@url );
					i_mc.x 				= ( PLAYLIST_WIDTH - PLAYLIST_ITEM_WIDTH - PLAYLIST_SCROLL_WIDTH) >> 1 ;
					i_mc.y 				= PLAYLIST_BORDER+(posy * (PLAYLIST_ITEM_HEIGHT + PLAYLIST_ITEM_GAP));
					posy++;
					// set some custom properties
					i_mc.video_url 		= v.@url;
					i_mc.videoIndex		= index;
					_listVideos[index]	= i_mc;
					index++;
					i_mc.buttonMode		= true;
					i_mc.useHandCursor	= true;
					i_mc.addEventListener( MouseEvent.CLICK, onItemHandler );
					i_mc.addEventListener( MouseEvent.ROLL_OVER, onItemHandler );
					i_mc.addEventListener( MouseEvent.ROLL_OUT, onItemHandler );
					sc.addChild( i_mc ); 							
				}
			}
			
			/**
			 * Create the mask for playlist scroll
			 */
			var mask_mc:MovieClip = new MovieClip();
			mask_mc.graphics.beginFill(0xff0000);
			mask_mc.graphics.drawRoundRect(0, 0, PLAYLIST_ITEM_WIDTH, ((PLAYLIST_ITEM_HEIGHT + PLAYLIST_ITEM_GAP) * PLAYLIST_ITEM_VISIBLE), 14, 14);
			mask_mc.graphics.endFill();
			mask_mc.x = ( PLAYLIST_WIDTH - PLAYLIST_ITEM_WIDTH - PLAYLIST_SCROLL_WIDTH ) >> 1;
			mask_mc.y = PLAYLIST_BORDER;
			_playlist_mc.addChild( mask_mc );
			
			sc.mask = mask_mc;
			
			/**
			 * Create the knob for list item
			 */
			var h:Knob 	= new Knob();
			_playlist_mc.addChild( h );
			h.rotation	= 90;
			h.width		= (PLAYLIST_ITEM_HEIGHT + PLAYLIST_ITEM_GAP) * PLAYLIST_ITEM_VISIBLE;
			h.x 		= PLAYLIST_WIDTH-PLAYLIST_SCROLL_WIDTH;
			h.y 		= PLAYLIST_BORDER;
			h.knobColor	= 0x0096ff;
			h.max		= Math.abs(posy - PLAYLIST_ITEM_VISIBLE);
			h.addEventListener ( KnobEvent.CHANGE, 
				function( e:KnobEvent):void {
					var ny:Number		= -Math.round( e.value )*(PLAYLIST_ITEM_HEIGHT+PLAYLIST_ITEM_GAP);
					var sc:MovieClip	= MovieClip( _playlist_mc.getChildAt(0) );
					if( _playlist_mc.getChildAt(0).y != ny ) {
						try { sc._tween.stop(); } catch (error:TypeError) { }
						sc._tween = new Tween(sc,"y", Strong.easeOut, sc.y, ny, 1, true);
					}
				}
			);
			swapChildren( _toolbar_mc, _playlist_mc );
		}
		
		/**
		 * Create an item of playlist
		 *
		 * @private
		 */
		private function createItem( t:String, url:String, img:String = "" ):MovieClip {
			var tm:MovieClip		= new MovieClip();
			tm.itemType				= 'item';			
			var tx:ItemText			= new ItemText();
			var tf:TextFormat		= new TextFormat();
						
			tm.graphics.beginFill(0x333333);
			tm.graphics.drawRoundRect(0, 0, PLAYLIST_ITEM_WIDTH, PLAYLIST_ITEM_HEIGHT, 8, 8);
			tm.graphics.endFill();

			tx.bd.autoSize			= TextFieldAutoSize.LEFT;
			tx.x					= 8;
			tx.y					= 2;
			tx.bd.text				= t.toUpperCase();
			tx.bd.textColor			= 0xffffff;
			tx.mouseChildren		= false;
			
			tm.addChild( tx );
			
			tm.setSelected			= function( v:Boolean ):void {
				this.getChildAt(0).bd.textColor = v?0xff9900:0xffffff;
			};
			
			tm.setPlaying			= function( v:Boolean ):void {
				var str:String = this.getChildAt(0).bd.text;
				if( v && str.substr(0,1) != '>' ) this.getChildAt(0).bd.text = '> '+str;
				else if( !v && str.substr(0,1) == '>' ) this.getChildAt(0).bd.text = str.substr(2, str.length-2);
			};
			
			
			return( tm );
		}
		
		/**
		 * Create an title for group video
		 *
		 * @private
		 */
		private function createTitle( t:String ):MovieClip {
			var tm:MovieClip		= new MovieClip();
			tm.itemType				= 'title';
			var tx:TitleText		= new TitleText();
			var tf:TextFormat		= new TextFormat();
						
			tm.graphics.beginFill(0x000000);
			tm.graphics.drawRoundRect(0, 0, PLAYLIST_ITEM_WIDTH, PLAYLIST_ITEM_HEIGHT, 8, 8);
			tm.graphics.endFill();

			tx.bd.autoSize			= TextFieldAutoSize.LEFT;
			tx.x					= 4;
			tx.y					= 2;		
			tx.bd.text				= t.toUpperCase();
			tx.bd.textColor			= 0x0096ff;
			tx.mouseChildren		= false;
			
			tm.addChild( tx );
			
			return( tm );
		}		
		
		// ______________________________________________________________ PROPERTIES

		/**
		 * Get/Set Playlist visible state
		 *
		 * @param	v	(boolean)	true for show, false for hide
		 */
		public function get playlist():Boolean {	return _playlist_mc.visible }
		public function set playlist(v:Boolean):void {
			set_playlist( v );
		}	
		
		/**
		 * Get/Set Toolbar visible state
		 *
		 * @param	v	(boolean)	true for show, false for hide
		 */
		public function get toolbar():Boolean {	return _toolbar_mc.visible }
		public function set toolbar(v:Boolean):void {
			set_toolbar( v );
		}	

		/**
		 * Get/set the Play/pause state button.
		 *
		 * @param	s		(string) "pause" show pause, "play" show play
		 */
		public function get state():String { return _button_play.visible?'play':'pause'; }
		public function set state( s:String ):void {
			_button_play.visible = (s=="play");
			_button_pause.visible = (s=="pause");
		}
		
		/**
		 * Get/Set the seek position knob. You havr to set progressMax
		 * property before use this one.
		 *
		 * @param	t		(number) Knob position
		 */
		public function get progress():Number 			{ return _seek.value; } 
		public function set progress( t:Number ):void 	{ _seek.value = t; }

		/**
		 * Get/Set the max value of progress seek knob
		 *
		 * @param	v		(number) Set max position seek knob
		 */
		public function get progressMax():Number { return _seek.max; }	 
		public function set progressMax( v:Number ):void { _seek.max = v; }
		
		public function get listVideos():Array { return _listVideos; }
		public function get videoIndex():uint { return _index; }
		
		// _______________________________________________________________ EVENTS
		
		private function onItemHandler( e:MouseEvent ):void {
			switch( e.type ) {
				case MouseEvent.CLICK:
					clearSelectedPlaylist();
					setItemPlaying( e.currentTarget.videoIndex );
					dispatchEvent( new VideoControlEvent( VideoControlEvent.PLAYLIST_ITEM_CLICK, false, true, e.currentTarget.video_url ) );
					break;
				case MouseEvent.ROLL_OUT:
					e.target.graphics.beginFill(0x333333);
					e.target.graphics.drawRoundRect(0, 0, PLAYLIST_ITEM_WIDTH, PLAYLIST_ITEM_HEIGHT, 8, 8);
					e.target.graphics.endFill();
					break;
				case MouseEvent.ROLL_OVER:
					e.target.graphics.beginFill(0x555555);
					e.target.graphics.drawRoundRect(0, 0, PLAYLIST_ITEM_WIDTH, PLAYLIST_ITEM_HEIGHT, 8, 8);
					e.target.graphics.endFill();
					break;
			}
		}
	}
}