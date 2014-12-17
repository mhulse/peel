﻿package {		// Imports:	import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.display.DisplayObject;	import flash.filters.GlowFilter;	import flash.filters.BitmapFilterQuality;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.MouseEvent;	import flash.external.ExternalInterface;	import flash.system.Security;		// Custom classes:	import gs.TweenLite;	import me.hulse.util.FireTrace;	import me.hulse.util.Params;	import me.hulse.util.Stager;	import me.hulse.util.LoadAds;	import me.hulse.util.HttpCookie;	import me.hulse.util.Timing;	import me.hulse.util.ClickTag;	import me.hulse.util.LockDown;		/**	* Main	*        About: Document class.	*/	public class Main extends MovieClip {				// Meta:		private static const APP_NAME:String = 'Peel';		private static const APP_VERSION:String = '1.5';		private static const APP_MODIFIED:String = '10/13/09';		private static const APP_AUTHOR:String = 'Micky Hulse <micky@hulse.me>';				// Private:		private var _ft:FireTrace;		private var _lockDown:LockDown;		private var _stager:Stager;		private var _loadAds:LoadAds;		private var _cookie:HttpCookie;		private var _timing:Timing;		private var _clickTag:ClickTag;		private var _mainMc:MainMc; // Library linkage, no physical class file exists.		private var _cookieName:String;		private var _cookieAllowed:Boolean;		private var _cookieChecker:Boolean		private var _clickMc:MovieClip;		private var _peelMc:MovieClip;		private var _maskMc:MovieClip;		private var _contentMc:MovieClip;		private var _adMc:MovieClip;		private var _adMcLoad:MovieClip;		private var _teaseMc:MovieClip;		private var _teaseMcLoad:MovieClip;		private var _closeBtn:SimpleButton;		private var _rewind:Boolean;		private var _flag:Boolean;		private var _timeOpen:Number;				// Private constants:		private static const ALLOWED_DOMAINS:String = 'registerguard.com, hulse.me, guardnet.com';				/**		* Main()		*        About: Class constructor.		*      Returns: Nothing.		*/		public function Main() {						_ft = new FireTrace();						_ft.log('Main() instantiated...');						// Meta:			_ft.log('Name: ' + APP_NAME + '; Version: ' + APP_VERSION + '; Modified: ' + APP_MODIFIED + '; Author: ' + APP_AUTHOR);						/*			** 			** Docs: 			**       In addition to protecting SWF files from cross-domain scripting originated by other SWF files, 			**       Flash Player protects SWF files from cross-domain scripting originated by HTML files.			**       HTML-to-SWF scripting can occur with older Flash browser functions such as SetVariable or callbacks established through ExternalInterface.addCallback().			**       When HTML-to-SWF scripting crosses domains, the SWF file being accessed must call allowDomain(), 			**       just as when the accessing party is a SWF file, or the operation will fail.			**       -- http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/system/Security.html#allowDomain%28%29			** 			*/			Security.allowDomain(ALLOWED_DOMAINS); // I should probably combine the below domain list						// Basic securtiy checks:			_lockDown = new LockDown(ALLOWED_DOMAINS.split(','));			if (_lockDown.unlocked) { init(); }			//init();					};				/**		* init()		*        About: Load external assets and then continue program.		*      Returns: Nothing.		*/		private function init():void {						// Load():			_loadAds = new LoadAds(this);			_loadAds.addEventListener(LoadAds.LOAD_COMPLETE, onLoadComplete, false, 0, true); // Wait for loading to complete.					};				/**		* onLoadComplete()		*        About: Event listener, called when loading completed.		*      Returns: Nothing.		*/		private function onLoadComplete(e:Event):void {						_ft.log('Load complete...');						_loadAds.removeEventListener(LoadAds.LOAD_COMPLETE, onLoadComplete); // GC.						// Get embed parameters/flashvars:			getParams();						// Instantiate custom classes:			_stager = new Stager(this, "NO_SCALE", "TOP_RIGHT"); // Setup stage.			_cookie = new HttpCookie('peel'); // Target HTML object.			_clickTag = new ClickTag(this); // Clicktag.						// Initialize:			_flag = false;			_cookieName = _cookie.name;			_ft.log('Cookie name: "' + _cookieName + '"');			_cookieChecker = _cookie.checkCookie(_cookieName);			_cookieAllowed = _cookie.allowed;						// Setup our primary movieclip:			_mainMc = new MainMc(); // Create new instance.						// Object lookups:			_clickMc = _mainMc.click_mc;			_peelMc = _mainMc.peel_mc;			_maskMc = _mainMc.mask_mc;			_contentMc = _mainMc.content_mc;			_teaseMc = _contentMc.tease_mc;			_adMc = _contentMc.ad_mc;			_closeBtn = _peelMc.close_btn;						// Other setup:			_mainMc.x = 600; // Position.			_mainMc.y = 0; // IBID.			glow(_mainMc); // Apply glow.						_clickMc.addEventListener(MouseEvent.CLICK, onClick, false, 0, true); // http://www.kirupa.com/forum/showthread.php?t=260312			_clickMc.buttonMode = true; // Button mode.			_clickMc.useHandCursor = true;						// http://livedocs.adobe.com/flash/9.0/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000216.html			_adMcLoad = MovieClip(_loadAds.pre.objects[0]); // Cast 'DisplayObject' to 'MovieClip'.			_adMcLoad.stop(); // Stop until told to play.			_adMc.addChild(_adMcLoad); // Add to movieclip stage.						// IBID			_teaseMcLoad = MovieClip(_loadAds.pre.objects[1]);			_teaseMc.addChild(_teaseMcLoad);						this.addChild(_mainMc); // Add to display list.						// Begin program:			startPeel();					};						/**		* startPeel()		*        About: Starts program, checks for cookie.		*      Returns: Nothing.		*/		private function startPeel():void {						_ft.log('startPeel()...');						// Can we use cookies?			if (_cookieAllowed) {								// If cookie does exist:				if (_cookieChecker) {										_ft.log('Cookie already set...');										// Setup event listeners:					peeler();									} else {										_ft.log('First time visit...');										// Event listeners:					_mainMc.addEventListener(Event.ENTER_FRAME, onEnter, false, 0, true);										// Boolean:					_flag = true;										// Set cookie:					_cookie.setCookie(_cookieName, _cookieName);										// Open the HTML container:					ExternalInterface.call("peelControl", "open");										// Hide:					TweenLite.to(_teaseMc, .5, { autoAlpha: 0 });										// First time visit, open the peel:					_clickMc.play();					_peelMc.play();					_maskMc.play();					_adMcLoad.gotoAndPlay(1);									}							}					};				/**		* getParams()		*        About: Gets these flashvars from embed:		*               1. seconds, default: 10.		*      Returns: Nothing.		*/		private function getParams():void {						_ft.log('getParams()...');						// Instantiate params class:			var p:Params = new Params(this);			 			 // Get params:			_timeOpen = Number(p.getParam("seconds", '10')) * 1000; // Time, in milliseconds, open.					};				/**		* peeler()		*        About: Launching pad for the differnt events.		*      Returns: Nothing.		*/		private function peeler():void {						_ft.log('peeler()...');						// Event listeners:			_mainMc.addEventListener(Event.ENTER_FRAME, onEnter, false, 0, true);			_mainMc.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);			_mainMc.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);					};				/**		* peelOpened()		*        About: Fired when peel is fully opened.		*      Returns: Nothing.		*/		private function peelOpened():void {						_ft.log('peelOpened()...');						// GC:			_mainMc.removeEventListener(Event.ENTER_FRAME, onEnter);			_mainMc.removeEventListener(MouseEvent.ROLL_OVER, onOver);			_mainMc.removeEventListener(MouseEvent.ROLL_OUT, onOut);						// Setup the close button:			_closeBtn.addEventListener(MouseEvent.MOUSE_UP, onPeelClosed, false, 0, true);						// Put tease back on frame #1:			_teaseMcLoad.gotoAndStop(1);						// Timer:			_timing = new Timing(_timeOpen); // 10 seconds === 10,000 miliseconds.			_timing.addEventListener(Timing.TIMING_COMPLETE, onPeelClosed, false, 0, true);					};				private function glow(o:Object):void {						_ft.log('glow()...');						var glow:GlowFilter = new GlowFilter();						glow.color = 0x000000;			glow.alpha = 1;			glow.blurX = 25;			glow.blurY = 25;			glow.strength = 0.5;			glow.inner = false;			glow.knockout = false;			glow.quality = BitmapFilterQuality.LOW;						o.filters = new Array(glow);					};				/**		* onEnter()		*        About: Handles Event.ENTER_FRAME event.		*      Returns: Nothing.		*/		private function onEnter(e:Event):void {						if (_peelMc.currentFrame == 1) {								// Bools:				_flag = false;				_rewind = false;								// Play:				_clickMc.play();				_peelMc.play();				_maskMc.play();							} else if (!_flag && (_peelMc.currentLabel != 'loop')) {								// Loop:				_clickMc.gotoAndPlay('loop');				_peelMc.gotoAndPlay('loop');				_maskMc.gotoAndPlay('loop');							} else if (_rewind == true) {								// Rewind:				_clickMc.prevFrame();				_peelMc.prevFrame();				_maskMc.prevFrame();							} else {								// If peel is opened, call onPeelOpened(), otherwise trace current frame number:				(_peelMc.currentLabel == "finish") ? peelOpened() : trace(_peelMc.currentFrame);							}					};				/**		* onOver()		*        About: Handles MouseEvent.ROLL_OVER event.		*      Returns: Nothing.		*/		private function onOver(e:Event):void {						_ft.log('onOver()...');						// Bools:			_flag = true;			_rewind = false;						// Open the HTML container:			ExternalInterface.call("peelControl", "open");						// Hide:			TweenLite.to(_teaseMc, .5, { autoAlpha: 0 });						// Play:			_clickMc.play();			_peelMc.play();			_maskMc.play();						_adMcLoad.play();					};				/**		* onOut()		*        About: Handles MouseEvent.ROLL_OVER event.		*      Returns: Nothing.		*/		private function onOut(e:Event):void {						_ft.log('onOut()...');						// Bools:			_flag = true;			_rewind = true;						// Listen for first frame:			_peelMc.addEventListener(Event.ENTER_FRAME, onFirstFrame, false, 0, true);					};				/**		* onUp()		*        About: Handles MouseEvent.MOUSE_UP event for peel close button.		*      Returns: Nothing.		*/		private function onPeelClosed(e:Event):void {						_ft.log('onPeelClosed()...');						// GC:			_closeBtn.removeEventListener(MouseEvent.MOUSE_UP, onPeelClosed);			_timing.removeEventListener(Timing.TIMING_COMPLETE, onPeelClosed);						// Bools:			_rewind = true;						// Listen for first frame:			_peelMc.addEventListener(Event.ENTER_FRAME, onFirstFrame, false, 0, true);						// Launching pad:			peeler();					};				/**		* onFirstFrame()		*        About: Event listener method to check for first frame.		*      Returns: Nothing.		*/		private function onFirstFrame(e:Event):void {						// First frame?			if (e.target.currentFrame == 1) {								// GC:				e.target.removeEventListener(Event.ENTER_FRAME, onFirstFrame);								// Open the HTML container:				ExternalInterface.call("peelControl", "close");								// Show our tease movie:				TweenLite.to(_teaseMc, 1, { autoAlpha: 1, onComplete:onFinishTween });							}					};				/**		* onFinishTween()		*        About: Callback method for TweenLite first frame check.		*      Returns: Nothing.		*/		private function onFinishTween():void {						_ft.log('onFinishTween()...');						// Play the tease ad:			_teaseMcLoad.play();						// Reset the loaded ad:			_adMcLoad.gotoAndStop(1);					};				private function onClick(e:MouseEvent):void {						_ft.log('clicked');						_clickTag.getURL();					};			};	};