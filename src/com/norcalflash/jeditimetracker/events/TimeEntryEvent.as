package com.norcalflash.jeditimetracker.events
{
	import flash.events.Event;
	
	public class TimeEntryEvent extends Event
	{
		public static const GET_ACTIVE_PROJECTS:String = "TimeEntryEvent.GET_ACTIVE_PROJECTS";
		public static const GET_ACTIVE_PROJECTS_COMPLETED:String = "TimeEntryEvent.GET_ACTIVE_PROJECTS_COMPLETED";
		public static const GET_TIME_ENTRIES_BY_RANGE:String = "TimeEntryEvent.GET_TIME_ENTRIES_BY_RANGE";
		public static const GET_TIME_ENTRIES_BY_RANGE_COMPLETED:String = "TimeEntryEvent.GET_TIME_ENTRIES_BY_RANGE_COMPLETED";
		public static const GET_REPORT_BY_RANGE:String = "TimeEntryEvent.GET_REPORT_BY_RANGE";
		public static const GET_REPORT_BY_RANGE_COMPLETED:String = "TimeEntryEvent.GET_REPORT_BY_RANGE_COMPLETED";
		public static const SAVE_TIME_ENTRY:String = "TimeEntryEvent.SAVE_TIME_ENTRY";
		public static const SAVE_TIME_ENTRY_COMPLETED:String = "TimeEntryEvent.SAVE_TIME_ENTRY_COMPLETED";
		public static const DELETE_TIME_ENTRY:String = "TimeEntryEvent.DELETE_TIME_ENTRY";
		public static const DELETE_TIME_ENTRY_COMPLETED:String = "TimeEntryEvent.DELETE_TIME_ENTRY_COMPLETED";
		
		public function TimeEntryEvent(type:String)
		{
			super(type, true, true);
		}
		
		override public function clone():Event
		{
			return new TimeEntryEvent(this.type);
		}
	}
}