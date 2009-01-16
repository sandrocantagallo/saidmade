package com {
	/**
	 * VideoControlEvent is the Class Event for VideoControl Class
	 *
	 * @author			Giovambattista Fazioli <g.fazioli@undolog.com>
	 * @web				http://www.undolog.com
	 * @version			1.0.1
	 */	
	import flash.events.*;

	public class VideoControlEvent extends Event {
		
		// _______________________________________________________________ STATIC
		
		public static const CHANGE_VOLUME		:String 			= 'change_volume';			// Trigged when the volume (knob) is changed	
		public static const START_CHANGE_SEEK	:String 			= 'start_change_seek';		// Trigged when start seek	
		public static const CHANGE_SEEK			:String 			= 'change_seek';			// Trigged when the seek (knob) is changed
		public static const END_CHANGE_SEEK		:String 			= 'end_change_seek';		// Trigged when seek is over
		public static const PLAYLIST_ITEM_CLICK	:String 			= 'playlist_item_click';	// Trigged when click an item on playlist
		public static const PLAY_VIDEO			:String 			= 'play_video';				// Trigged when click on play button
		public static const PAUSE_VIDEO			:String 			= 'pause_video';			// Trigged when click on pause button
		public static const REDRAW				:String				= 'redraw';					// not use yet
		
		// _______________________________________________________________ INTERNAL
		
		protected var _volume					:Number				= NaN;
		protected var _seek						:Number				= NaN;
		protected var _urlVideo					:String				= "";
		
		/**
		 * Constructor function for a VideoControlEvent object.
		 *
		 * @param type 			- The event type; indicates the action that caused the event.
		 * @param bubbles 		- Specifies whether the event can bubble up the display list hierarchy.
		 * @param cancelable	- Specifies whether the behavior associated with the event can be prevented.
		 * @param urlVideo		- The URL of video clicked on playlist
		 * @param volume		- The value of volume knob
		 * @param seek			- The value of seek knob
		 *
		 */
		public function VideoControlEvent( type:String, bubbles:Boolean=false, cancelable:Boolean=false, urlVideo:String='', volume:Number=NaN, seek:Number=NaN ):void {
			super(type, bubbles, cancelable);
			_urlVideo	= urlVideo;
			_volume		= volume;
			_seek		= seek;
		}
		
		/**
		 *  Gets the url video
		 */
		public function get urlVideo():String {
			return _urlVideo;
		}
		
		/**
		 *  Gets the volume
		 */
		public function get volume():Number {
			return _volume;
		}

		/**
		 *  Gets the seek
		 */
		public function get seek():Number {
			return _seek;
		}
				
		/**
		 * Returns a string that contains all the properties of the VideoControlEvent
		 * object.
		 *
		 * @override
		 */
		override public function toString():String {
			return formatToString("VideoControlEvent", "type", "bubbles", "urlVideo", "volume", "seek");
		}

		
		/**
		 * Creates a copy of the VideoControlEvent object and sets the value of each
		 * parameter to match the original.
		 *
		 * @override
		 */
		override public function clone():Event	{
			return new VideoControlEvent(type, bubbles, cancelable, _urlVideo, _volume, _seek);
		} 
	}
}