﻿package {	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.ProgressEvent;	public class Main extends MovieClip {		public function Main():void {			loaderInfo.addEventListener(ProgressEvent.PROGRESS , onLoadProgress);			loaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);		}		private function onLoadProgress(event:ProgressEvent):void {			var bl:uint = event.bytesLoaded;			var bt:uint = event.bytesTotal;			var percentLoaded:int = Math.floor((bl / bt) * 100);			trace(percentLoaded);		}		private function onLoadComplete(event:Event):void {			gotoAndStop("loaded");		}	}}