package com {
	/**
	 * oPlayer
	 *
	 * oPlayer is a open source Flash Video Player. You can set some options from object data 
	 * value or from MIME GET in the swf.
	 *
	 * OPTIONS
	 *
	 * @param		playlist		XML Playlist URL
	 * @param		autoplay		true: play first video in playlist
	 *
	 * SAMPLE
	 *
	 * <object data="oplayer.swf?playlist=myplaylist.xml" type="application/x-shockwave-flash" 
	 * height="200" width="200"></object>
	 *
	 * <object data="oplayer.swf" type="application/x-shockwave-flash" height="200" width="200">
	 * 		<param name="playlist" value="myplaylist.xml"  />
	 * </object>
	 *
	 *
	 * oPlayer is released under version 3.0 of the Creative Commons 
	 * Attribution-Noncommercial-Share Alike license. This means that it is 
	 * absolutely free for personal, noncommercial use provided that you 1)
	 * make attribution to the author and 2) release any derivative work under
	 * the same or a similar license.
	 *
	 * This program is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	 *
	 * If you wish to use oPlayer for commercial purposes, licensing information
	 * can be found at http://www.saidmade.com
	 *
	 * @author		Giovambattista Fazioli
	 * @email		g.fazioli@saidmade.com
	 * @web			http://www.saidmade.com
	 * @rel			http://www.undolog.com
	 *
	 * CHANGELOG
	 *	0.5b		First beta 1 release with minimal interface
	 *
	 */	
	import flash.display.*;
	import flash.media.*;
	import flash.events.*;
	import flash.text.*;
	import flash.system.System;
	import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.ui.ContextMenuBuiltInItems;
	import flash.utils.Timer;
	import flash.net.*;		
	
	public class oPlayer extends MovieClip {
		// _______________________________________________________________ STATIC

		static public const NAME				:String			= "oPlayer";
		static public const VERSION				:String 		= "0.1";
		static public const AUTHOR				:String 		= "Giovambattista Fazioli <g.fazioli@saidmade.com>";
		
		private const PLAYHEAD_UPDATE_INTERVAL	:uint 			= 10;
		
		// _______________________________________________________________ INTERNAL
		
		private var _params						:Object;				// pointer to MIME params
		private var _nc							:NetConnection;			// video connection
		private var _ns							:NetStream;				// video streaming
		private var _xmlLoader					:URLLoader;				// loader xml playlist
		private var _soundTransform				:SoundTransform;		// object used to set the volume for the NetStream
		private var _playlist					:XML;					// xml return object
		private var _videosXML					:XMLList;				// xml list of video
		
		private var _videoControl				:VideoControl;			// video control MovieClip
		private var _client						:Object;				// object to use for the NetStream object
		
		private var _t							:Timer;
		private var _meta						:Object;
				
		// _______________________________________________________________ CONSTRUCTOR
		
		function oPlayer() {
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
			//
			stage.scaleMode 	= StageScaleMode.NO_SCALE;				// no-size
			stage.align			= StageAlign.TOP_LEFT;					// align to top left
			//
			initMask();
			initParams();												// init default params
			initVideo();												// init net connection and streaming
			loadPlaylist();												// loading playlist
		}
		
		// _______________________________________________________________ INIT FUNCTION
		
		/**
		 * Create a Mask for contect Menu Event
		 */
		private function initMask():void {
			var mk:Sprite	= new Sprite();
			with( mk.graphics ) {
				clear();
				beginFill( 0x000000, 0 );
				drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
				endFill();
			}
			addChild( mk );
		}
				
		/**
		 * Init all player events
		 *
		 * @private
		 */
		private function initEvents():void {
			/**
			 * Trap Mouse Y pos for show Video Controls
			 */
			stage.addEventListener( MouseEvent.MOUSE_MOVE,
				function( e:MouseEvent ):void {
					_videoControl.toolbar = ( e.stageY > (stage.stageHeight-200) );
				}
			);
		
			/**
			 * Timer
			 */
			_t	= new Timer( PLAYHEAD_UPDATE_INTERVAL );
			_t.addEventListener(TimerEvent.TIMER, timerHandler);
			
			/**
			 * Autoplay
			 */
			if( _params.autoplay ) {
				_videoControl.toolbar = false;
				playVideoIndex(0);
			}
		}
		
		/**
		 * Create the VideoControl MovieClip
		 *
		 * @private
		 */
		private function initControls():void {
			_videoControl					= new VideoControl( _videosXML );
			_videoControl.addEventListener( VideoControlEvent.PLAYLIST_ITEM_CLICK, onPlaylistItemClick );
			_videoControl.addEventListener( VideoControlEvent.PLAY_VIDEO, onToolbarHandler );
			_videoControl.addEventListener( VideoControlEvent.PAUSE_VIDEO, onToolbarHandler );
			_videoControl.addEventListener( VideoControlEvent.CHANGE_VOLUME, onToolbarHandler );
			_videoControl.addEventListener( VideoControlEvent.START_CHANGE_SEEK, onToolbarHandler );
			_videoControl.addEventListener( VideoControlEvent.CHANGE_SEEK, onToolbarHandler );
			_videoControl.addEventListener( VideoControlEvent.END_CHANGE_SEEK, onToolbarHandler );
			addChild( _videoControl );
			
			initContextMenu();									// init context menu
		}
		
		/**
		 * Init net connection and streaming object
		 *
		 * @private
		 */
		private function initVideo():void {
			/**
			 * Volume control of video
			 */
			_soundTransform		= new SoundTransform();
			
			_client 			= new Object();
			_client.onMetaData 	= onMetadataHandler;
			//
			_nc 				= new NetConnection();
			_nc.connect(null);
			//
			_ns 				= new NetStream( _nc );
			_ns.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			_ns.client 			= _client;
			//
			i_video.attachNetStream( _ns );
			
			i_video.width		= stage.stageWidth;
			i_video.height		= stage.stageHeight;
			i_video.smoothing	= true;
		}
		
		
		/**
		 * init the params 
		 *
		 * @private
		 */
		private function initParams():void {
			_params				= loaderInfo.parameters;		// get params
			
			/**
			 * set default params
			 */
			_params.playlist 	= _params.playlist || 'playlist.xml';
			_params.autoplay 	= _params.autoplay || true;
		}
		
		/**
		 * init the context menu items
		 *
		 * @private
		 */
		private function initContextMenu():void {
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems ();
			
			/**
			 * set some usefull command in context menu
			 */
			var cplaypause	:ContextMenuItem 	= new ContextMenuItem("Play Video", false, true);
			var cplaynext	:ContextMenuItem 	= new ContextMenuItem("Play Next Video", false, true);
			var cplaylist	:ContextMenuItem 	= new ContextMenuItem("Toggle Playlist", false, true);
			// var cfullscreen:ContextMenuItem = new ContextMenuItem("Fullscreen", false, true);
			
			var devby:ContextMenuItem = new ContextMenuItem("Developed by Saidmade Srl - Ver. " + VERSION, true, true);
			var ginfo:ContextMenuItem = new ContextMenuItem("Author info...", false, true);
			
			/**
			 * callback command
			*/ 
			cplaypause.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
				function(e:ContextMenuEvent):void {
					if( _videoControl.state == 'play') {
						contextMenu.customItems[0].caption = "Pause Video";
						_ns.resume();
						_videoControl.state = 'pause';
					} else {
						contextMenu.customItems[0].caption = "Play Video";
						_videoControl.state = 'play';
						_ns.pause();
					}
				}
			);
			
			cplaynext.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, playNextVideo );			
			
			cplaylist.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
				function(e:ContextMenuEvent):void {
					_videoControl.playlist = !_videoControl.playlist;
				}
			);
						 
			devby.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
				function(e:ContextMenuEvent):void {
					var rq:URLRequest = new URLRequest("http://www.saidmade.com");
					navigateToURL (rq, "_blank");
				}
			);
			
			ginfo.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT,
				function(e:ContextMenuEvent):void {
					var rq:URLRequest = new URLRequest("http://www.undolog.com/");
					navigateToURL (rq, "_blank");
				}
			);
			//
			cm.customItems = [ cplaypause, cplaynext, cplaylist, devby, ginfo ];
			this.contextMenu = cm;
			
			initEvents();
		}

		// _______________________________________________________________ METHODS
		
		/**
		 * Play next video on array list
		 *
		 * @param	e	(ContextMenuEvent) Can be null (default)
		 *
		 * @private
		 */
		private function playNextVideo( e:ContextMenuEvent = null ):void {
			var _index:uint	= _videoControl.videoIndex;
			if( ++_index > (_videoControl.listVideos.length-1) ) _index = 0;
			playVideoIndex( _index );	
		}
		
		
		/**
		 * Play a video from index
		 *
		 * @param	index	(uint) Index of video
		 *
		 * @private
		 */
		private function playVideoIndex( index:uint ):void {
			playVideo( _videoControl.listVideos[ index ].video_url );
			_videoControl.setItemPlaying( index );
		}
		
		/**
		 * Play a video (url)
		 *
		 * @param	url		(string) Video URL address 
		 *
		 * @private
		 */
		private function playVideo( url:String ):void {
			_ns.play( url );
		}
		
		/**
		 * Load the playlist xml file and set internal variable to
		 * XML return pointer: _playlist and _videosXML
		 *
		 * @private
		 */
		private function loadPlaylist():void {
			_xmlLoader = new URLLoader();
			_xmlLoader.addEventListener( Event.COMPLETE, 
				function(e:Event):void {
					_playlist 	= XML( e.target.data );
					_videosXML	= _playlist.group;
					initControls();
				}
			);
			_xmlLoader.load( new URLRequest( _params.playlist ) );
		}
		
		// _______________________________________________________________ EVENTS
		
		/**
		 * Trigged when an item is clicked
		 *
		 * @event
		 */
		private function onPlaylistItemClick( e:VideoControlEvent ):void {
			playVideo( e.urlVideo );
		}
		
		/**
		 * Common toolbar handler
		 *
		 * @event
		 */
		private function onToolbarHandler( e:VideoControlEvent ):void {
			switch( e.type ) {
				case VideoControlEvent.PLAY_VIDEO:
					_t.start();
					_ns.resume();
					_videoControl.state="pause";
					contextMenu.customItems[0].caption = "Pause Video"
					break;
				case VideoControlEvent.PAUSE_VIDEO:
					_t.stop();
					_ns.pause();
					_videoControl.state="play";
					contextMenu.customItems[0].caption = "Play Video"
					break;
				case VideoControlEvent.CHANGE_VOLUME:
					_soundTransform.volume = e.volume;
					_ns.soundTransform = _soundTransform;
					break;
				case VideoControlEvent.START_CHANGE_SEEK:
					_t.stop();
					_ns.pause();
					break;
				case VideoControlEvent.CHANGE_SEEK:
					_ns.seek( e.seek );
					break;
				case VideoControlEvent.END_CHANGE_SEEK:
					if( _videoControl.state == 'pause' ) {
						_t.start();
						_ns.resume();
					}
					break;	
			}
		}
		
		/**
		 * Event listener for the ns object's client property. This method is called 
		 * when the net stream object receives metadata information for a video.
		 */
		private function onMetadataHandler( metadataObj:Object ):void {
			// Store the metadata information in the meta object.
			_meta = metadataObj;
			_videoControl.progressMax = _meta.duration;
//			// Resize the Video instance on the display list with the video's width 
//			// and height from the metadata object.
//			vid.width = meta.width;
//			vid.height = meta.height;
//			// Reposition and resize the positionBar progress bar based on the 
//			// current video's dimensions.
//			positionBar.move(vid.x, vid.y + vid.height);
//			positionBar.width = vid.width;
		}		
		
		/**
		 * Net streaming status handler on video flow control and video events
		 *
		 * @event
		 */
		private function netStatusHandler( e:NetStatusEvent ):void {
			try {
				switch ( e.info.code ) {
					case "NetStream.Play.Start":
						_videoControl.state="pause";
						contextMenu.customItems[0].caption = "Pause Video";
						_t.start();
						break;
//					case "NetStream.Pause.Notify":
//						_videoControl.state="play";
//						break;
					case "NetStream.Play.StreamNotFound" :
					case "NetStream.Play.Stop" :
						_videoControl.state="play";
						contextMenu.customItems[0].caption = "Play Video"
						_videoControl.progress = 0;
						i_video.clear();
						_t.stop();
						_ns.pause();
						playNextVideo();
						break;
				}
			} catch (error:TypeError) {
				// Ignore any errors.
			}
		}

		/**
		 * Event handler for the timer object. This method is called every 
		 * PLAYHEAD_UPDATE_INTERVAL milliseconds as long as the timer is running.
		 */
		private function timerHandler(event:TimerEvent):void {
			try {
				// Update the progress bar and label based on the amount of video
				// that has played back.
				_videoControl.progressMax 	= _meta.duration;
				_videoControl.progress 		= _ns.time;
				//positionLabel.text = ns.time.toFixed(1) + " of " + meta.duration.toFixed(1) + " seconds";
			} catch (error:Error) {
				// Ignore this error.
			}
		}
		
	}
}