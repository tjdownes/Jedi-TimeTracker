package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.ClientEvent;
	import com.norcalflash.jeditimetracker.model.presentation.ClientsPM;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class DeleteClientCommand implements IEventAwareCommand
	{
		private var evt:ClientEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var model:ClientsPM;
		
		public function DeleteClientCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as ClientEvent;
		}
		
		public function execute():void
		{
			deleteClient();
		}

		public function deleteClient():void 
		{
			model.currentClient.deleteById(model.currentClient.id);
			dispatcher.dispatchEvent(new ClientEvent(ClientEvent.GET_ALL_CLIENTS));
			dispatcher.dispatchEvent(new ClientEvent(ClientEvent.DELETE_CLIENT_COMPLETE));
		}
	}
}