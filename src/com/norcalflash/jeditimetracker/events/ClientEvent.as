package com.norcalflash.jeditimetracker.events
{
	import flash.events.Event;
	
	public class ClientEvent extends Event
	{
		public static const GET_ALL_CLIENTS:String = "ClientEvent.GET_ALL_CLIENTS";
		public static const GET_ALL_CLIENTS_COMPLETE:String = "ClientEvent.GET_ALL_CLIENTS_COMPLETE";
		public static const SAVE_CLIENT:String = "ClientEvent.SAVE_CLIENT";
		public static const SAVE_CLIENT_COMPLETE:String = "ClientEvent.SAVE_CLIENT_COMPLETE";
		public static const DELETE_CLIENT:String = "ClientEvent.DELETE_CLIENT";
		public static const DELETE_CLIENT_COMPLETE:String = "ClientEvent.DELETE_CLIENT_COMPLETE";
		
		public function ClientEvent(type:String)
		{
			super(type, true, true);
		}
		
		override public function clone():Event
		{
			return new ClientEvent(this.type);
		}
	}
}