﻿package com.registerguard.peel {		import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.events.Event;	import flash.events.EventDispatcher;		public class Timing extends EventDispatcher {				// Constant:		public static const TIMING_COMPLETE:String = 'timing_completed';				// Private:		private var _period:uint;		private var _timer:Timer;				/**		* Timing()		*        About: Class constructor.		*      Returns: Nothing.		*/		public function Timing(t:uint = 10000) {						// http://snipurl.com/k0gbr						trace('Timing() instantiated...');						_period = t;						init();					};				/**		* init()		*        About: Initialize.		*      Returns: Nothing.		*/		private function init():void {						_timer = new Timer(_period);						_timer.addEventListener(TimerEvent.TIMER, onTime, false, 0, true);						_timer.start()					};				/**		* onTime()		*        About: Removes TimerEvent.TIMER event listener and dispatches custom Timing.TIMING_COMPLETE event.		*      Returns: Nothing.		*/		private function onTime(e:TimerEvent):void {						_timer.removeEventListener(TimerEvent.TIMER, onTime);						this.dispatchEvent(new Event(Timing.TIMING_COMPLETE));					};			};	};