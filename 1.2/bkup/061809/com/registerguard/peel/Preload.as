﻿/*#	Multiple file preloader: Preloader class	#	Preloads multiple swfs and/or images#	Accepts an array with strings containing the files to be loaded#	Dispatches a progress event when loading is in progress#	Returns the total precentage loaded with getter method 'Preloader.percLoaded'#	Dispatches a complete event when total loading is complete#	Returns an array with objects with the loaded files	get the array through getter method 'Preloader.objects'	#	instantiate like this:#	var pre:Preload = new Preload(["1.jpg","2.jpg","3.jpg"]);#	pre.addEventListener("preloadProgress", onPreloadProgress);#	pre.addEventListener("preloadComplete", onPreloadComplete);*/package com.registerguard.peel {		import flash.display.Sprite;	import flash.display.Loader;	import flash.events.Event;	import flash.events.ProgressEvent;	import flash.net.URLRequest;		public class Preload extends Sprite	{		public var objectsArray:Array = new Array();		// holds the the loaded files		public var pLoaded:int = 0;							// defaults the loaded percentage to 0		private var itemsArray:Array = new Array();			// holds all the items to be loaded		private var totalItems:int;							// holds the total items to be preloaded		private var currItem:int = 1;						// defaults the current preloaded item to 1				public function Preload(_itemsArray:Array)		{			itemsArray = _itemsArray;			totalItems = _itemsArray.length;			loadOne(currItem - 1, itemsArray);		// load the first item		}				private function loadOne(what:int, _itemsArray:Array):void		{			var ldr:Loader = new Loader();			ldr.load(new URLRequest(_itemsArray[what].toString()));			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onInternalProgress);			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onInternalComplete);		}			private function onInternalProgress(e:Event):void		{			var temp:int = Math.ceil((((e.target.bytesLoaded / e.target.bytesTotal)*100 * currItem) / totalItems));			if (temp > pLoaded) {				pLoaded = temp;		// avoid the precentage to drop			}			trace(pLoaded);			dispatchEvent(new Event("preloadProgress")); // call the parent class with a progress update		}				private function onInternalComplete(e:Event):void		{			objectsArray.push(e.target.content);	// add a loaded object to the objects array			currItem += 1;							// increment the current item to be loaded			if (objectsArray.length == totalItems) {				e.target.removeEventListener(ProgressEvent.PROGRESS, onInternalProgress);	// garbage collect				e.target.removeEventListener(Event.COMPLETE, onInternalComplete);				dispatchEvent(new Event("preloadComplete"));	// when all objects are loaded, call the parent class			} else {				loadOne(currItem - 1, itemsArray);	// load the next one			}			trace("complete");		}				public function get percLoaded():int		{			return pLoaded;			// returns the loaded percentage of all files to be preloaded		}				public function get objects():Array		{			return objectsArray;	// returns the loaded files as an array		}			}	}