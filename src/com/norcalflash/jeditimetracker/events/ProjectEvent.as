package com.norcalflash.jeditimetracker.events
{
	import flash.events.Event;
	
	public class ProjectEvent extends Event
	{
		public static const GET_PROJECTS_BY_CLIENT:String = "ProjectEvent.GET_PROJECTS_BY_CLIENT";
		public static const GET_PROJECTS_BY_CLIENT_COMPLETED:String = "ProjectEvent.GET_PROJECTS_BY_CLIENT_COMPLETED";
		public static const SAVE_PROJECT:String = "ProjectEvent.SAVE_PROJECT";
		public static const SAVE_PROJECT_COMPLETED:String = "ProjectEvent.SAVE_PROJECT_COMPLETED";
		public static const DELETE_PROJECT:String = "ProjectEvent.DELETE_PROJECT";
		public static const DELETE_PROJECT_COMPLETED:String = "ProjectEvent.DELETE_PROJECT_COMPLETED";
		
		public function ProjectEvent(type:String)
		{
			super(type, true, true);
		}
		
		override public function clone():Event
		{
			return new ProjectEvent(this.type);
		}
	}
}