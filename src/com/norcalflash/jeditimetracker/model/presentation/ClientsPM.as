package com.norcalflash.jeditimetracker.model.presentation
{
	import com.norcalflash.jeditimetracker.events.ClientEvent;
	import com.norcalflash.jeditimetracker.model.to.Client;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;

	[Bindable]
	public class ClientsPM
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject("appModel.clients",bind="true",twoWay="true")]
		public var clients:ArrayCollection;
		
		public var currentClient:Client;
		public var isEntryValid:Boolean = false;
		
		public function ClientsPM()
		{
		}
		
		[EventHandler("ClientEvent.SAVE_CLIENT_COMPLETE")]
		public function onClientSaved():void
		{
			resetCurrentClient();
		}
		
		[EventHandler("ClientEvent.DELETE_CLIENT_COMPLETE")]
		public function onClientDeleted():void
		{
			resetCurrentClient();
		}
		
		public function deleteCurrentClient():void
		{
			dispatcher.dispatchEvent(new ClientEvent(ClientEvent.DELETE_CLIENT));
		}
		
		public function saveCurrentClient():void
		{
			dispatcher.dispatchEvent(new ClientEvent(ClientEvent.SAVE_CLIENT));
		}
		
		public function resetCurrentClient():void
		{
			this.currentClient = new Client();
			validateEntry();
		}
		
		public function verifyCurrentClient():void
		{
			if(currentClient == null)
				currentClient = new Client();
		}
		
		public function validateEntry():void
		{
			if(currentClient == null || StringUtil.trim(currentClient.name).length == 0)
			{
				isEntryValid = false;
				return;
			}
			
			if(StringUtil.trim(currentClient.description).length == 0)
			{
				isEntryValid = false;
				return;
			}
			isEntryValid = true;
		}
	}
}