package com.norcalflash.jeditimetracker.model.presentation
{
	import com.norcalflash.jeditimetracker.events.TimeEntryEvent;
	import com.norcalflash.jeditimetracker.model.to.Client;
	import com.norcalflash.jeditimetracker.model.to.Project;
	import com.norcalflash.jeditimetracker.model.to.TimeEntry;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.utils.StringUtil;

	[Bindable]
	public class TimeEntryPM extends EventDispatcher
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public var projects:ArrayCollection;
		public var todaysHours:ArrayCollection;
		public var isDisabled:Boolean;
		public var isEntryValid:Boolean = false;
		public var startDate:Date = new Date();
		public var endDate:Date = new Date();
		public var sumOfHours:Number = 0;
		
		private var _currentProject:Project = new Project();
		
		[Bindable(event="currentProjectChange")]
		public function get currentProject():Project
		{
			return _currentProject;
		}
		
		public function set currentProject(value:Project):void
		{
			_currentProject = value;
			dispatchEvent(new Event("currentProjectChange"));
		}
		
		private var _currentClient:Client = new Client();
		

		[Bindable(event="currentClientChange")]
		public function get currentClient():Client
		{
			return _currentClient;
		}
		
		public function set currentClient(value:Client):void
		{
			_currentClient = value;
			
			if(value != null && value.id != 0)
			{
				setSelectedProject();
			}
			
			dispatchEvent(new Event("currentClientChange"));
		}
		
		private var _currentTimeEntry:TimeEntry = new TimeEntry();
		
		public function get currentTimeEntry():TimeEntry
		{
			return _currentTimeEntry;
		}
		
		public function set currentTimeEntry(value:TimeEntry):void
		{
			_currentTimeEntry = value;
			
			if(value != null && value.id != 0)
			{
				setSelectedClient();
			}
			
			dispatchEvent(new Event("currentTimeEntryChange"));
		}
		
		[Inject("appModel.clients",bind="true",twoWay="true")]
		public var clients:ArrayCollection;
		
		[EventHandler("TimeEntryEvent.SAVE_TIME_ENTRY_COMPLETED")]
		public function onTimeEntrySaved():void
		{
			resetTimeEntry();
		}
		
		[EventHandler("TimeEntryEvent.DELETE_TIME_ENTRY_COMPLETED")]
		public function onTimeEntryDeleted():void
		{
			resetTimeEntry();
		}
		
		public function getClientProjects():void
		{
			dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.GET_ACTIVE_PROJECTS));
		}
		
		public function getTimeEntries():void
		{
			dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.GET_TIME_ENTRIES_BY_RANGE));
		}
		
		public function saveHours():void
		{
			dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.SAVE_TIME_ENTRY));
		}
		
		public function deleteHours():void
		{
			var confirm:Alert = Alert.show("You are about to delete a time entry. Confirm to proceed.", "Warning", Alert.OK|Alert.CANCEL, null, onConfirmDelete)
		}
		
		protected function onConfirmDelete(evt:CloseEvent):void
		{
			if(evt.detail == 1)
				dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.DELETE_TIME_ENTRY));
		}
		
		public function resetTimeEntry():void
		{
			currentTimeEntry = new TimeEntry();
			currentProject = new Project();
			currentClient = new Client();
			validateTimeEntry();
		}
		
		public function setSelectedProject():void
		{
			if(currentTimeEntry.id != 0)
			{
				for each(var project:Project in currentClient.projects)
				{
					if(project.id == currentTimeEntry.project.id)
					{
						currentProject = project;
						dispatchEvent(new Event("currentProjectChange"));
					}
				}
			}
		}
		
		public function setSelectedClient():void
		{
			if(currentTimeEntry.id != 0)
			{
				for each(var client:Client in clients)
				{
					if(client.id == currentTimeEntry.project.client.id)
					{
						currentClient = client;
						dispatchEvent(new Event("currentClientChange"));
					}
				}
			}
		}
		
		public function validateTimeEntry():void
		{
			if(currentTimeEntry == null)
			{
				isEntryValid = false;
				return;
			}
			
			if(currentTimeEntry.date == null)
			{
				isEntryValid = false;
				return;
			}
			
			if(currentTimeEntry.hours == 0)
			{
				isEntryValid = false;
				return;
			}
			
			if(StringUtil.trim(currentTimeEntry.description).length == 0)
			{
				isEntryValid = false;
				return;
			}
			
			if(currentProject == null || currentProject.id == 0)
			{
				isEntryValid = false;
				return;
			}
			
			if(currentClient == null || currentClient.id == 0)
			{
				isEntryValid = false;
				return;
			}
			
			isEntryValid = true;
		}
		
		public function checkClients():void
		{
			if(clients == null || clients.length == 0)
			{
				isDisabled = true;
				Alert.show("You need to add clients before you can use this module");
			}
			else
			{
				isDisabled = false;
			}
		}
	}
}