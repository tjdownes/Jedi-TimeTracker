package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.ClientEvent;
	import com.norcalflash.jeditimetracker.model.AppModel;
	import com.norcalflash.jeditimetracker.model.to.Client;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class LoadClientsCommand implements IEventAwareCommand
	{
		private var evt:ClientEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var appModel:AppModel;
		
		public function LoadClientsCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as ClientEvent;
		}
		
		public function execute():void
		{
			getAllClients();
		}

		public function getAllClients():void 
		{
			var tmpClient:Client = new Client();
			appModel.clients = new ArrayCollection(tmpClient.findAll());
			dispatcher.dispatchEvent(new ClientEvent(ClientEvent.GET_ALL_CLIENTS_COMPLETE));
		}
	}
}