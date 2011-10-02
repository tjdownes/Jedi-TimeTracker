package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.ClientEvent;
	import com.norcalflash.jeditimetracker.model.presentation.ClientsPM;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class SaveClientCommand implements IEventAwareCommand
	{
		private var evt:ClientEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var model:ClientsPM;
		
		public function SaveClientCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as ClientEvent;
		}
		
		public function execute():void
		{
			saveClient();
		}

		public function saveClient():void 
		{
			model.currentClient.save();
			dispatcher.dispatchEvent(new ClientEvent(ClientEvent.GET_ALL_CLIENTS));
			dispatcher.dispatchEvent(new ClientEvent(ClientEvent.SAVE_CLIENT_COMPLETE));
		}
	}
}