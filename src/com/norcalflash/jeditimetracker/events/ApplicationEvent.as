package com.norcalflash.jeditimetracker.events
{
	import flash.events.Event;
	
	public class ApplicationEvent extends Event
	{
		public static const INITALIZE:String = "ApplicationEvent.INITALIZE";
		public static const INITALIZED:String = "ApplicationEvent.INITALIZED";
		
		public function ApplicationEvent(type:String)
		{
			super(type, true, true);
		}
		
		override public function clone():Event
		{
			return new ApplicationEvent(this.type);
		}
	}
}