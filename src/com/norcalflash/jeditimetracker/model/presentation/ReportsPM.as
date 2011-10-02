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

	[Bindable]
	public class ReportsPM extends EventDispatcher
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public var projects:ArrayCollection;
		public var timeEntries:ArrayCollection;
		public var isDisabled:Boolean;
		public var startDate:Date = new Date();
		public var endDate:Date = new Date();
		public var currentProjects:ArrayCollection;
		
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
			setSelectedProject();
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
			setSelectedClient();
			dispatchEvent(new Event("currentTimeEntryChange"));
		}
		
		[Inject("appModel.clients",bind="true",twoWay="true")]
		public var clients:ArrayCollection;
		
		[EventHandler("TimeEntryEvent.GET_REPORT_BY_RANGE_COMPLETED")]
		public function onProjectsLoaded():void
		{
			setFilters();
		}
		
		public function getTimeEntries():void
		{
			dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.GET_REPORT_BY_RANGE));
		}
		
		public function getProjectsByClient():void
		{
			currentProject = new Project();
			currentProjects = new ArrayCollection(currentClient.projects);
			setFilters();
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
		
		public function setFilters():void
		{
			if(timeEntries != null)
			{
				if(currentProject.id > 0 || currentClient.id > 0)
				{
					timeEntries.filterFunction = filterTimeEntries;
				}
				else
				{
					timeEntries.filterFunction = null;
				}
				
				timeEntries.refresh();
			}
		}
		
		public function filterTimeEntries(item:Object):Boolean
		{
			var itemMatchesCriteria:Boolean;
			
			if(currentClient.id == item.client_id)
			{
				itemMatchesCriteria = true;
			}
			else
			{
				itemMatchesCriteria = false;
			}
			
			if(itemMatchesCriteria && (currentProject.id == item.project_id || currentProject.id == 0))
			{
				itemMatchesCriteria = true;
			}
			else
			{
				itemMatchesCriteria = false;
			}
			
			return itemMatchesCriteria;
		}
		
		public function resetReport():void
		{
			currentClient = new Client();
			currentProject = new Project();
			setFilters();
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