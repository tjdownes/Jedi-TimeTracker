package com.norcalflash.jeditimetracker.model.presentation
{
	import com.norcalflash.jeditimetracker.events.ApplicationEvent;
	import com.norcalflash.jeditimetracker.events.ClientEvent;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class MainViewPM
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public var viewState:String = "login";
		public var selectedViewIndex:Number = 0;
		
		public function MainViewPM()
		{
		}
		[Inject("appModel.clients",bind="true",twoWay="true")]
		public var clients:ArrayCollection;
		
		[EventHandler("ApplicationEvent.INITALIZED")]
		public function onAppInitialized():void
		{
			this.viewState = "main";
		}
		
		[EventHandler("ClientEvent.GET_ALL_CLIENTS_COMPLETE")]
		public function onClientResults():void
		{
			trace(this.clients.length);
		}
		
		public function getClients():void
		{
			dispatcher.dispatchEvent(new ClientEvent(ClientEvent.GET_ALL_CLIENTS));
		}
		
		public function initializeApp():void
		{
			dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.INITALIZE));
		}
		
		public function checkClients():void
		{
			if(clients == null || clients.length == 0)
			{
				selectedViewIndex = 1;
			}
		}
	}
}