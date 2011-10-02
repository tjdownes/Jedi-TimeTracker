package com.norcalflash.jeditimetracker.model.presentation
{
	import com.norcalflash.jeditimetracker.events.ProjectEvent;
	import com.norcalflash.jeditimetracker.model.to.Client;
	import com.norcalflash.jeditimetracker.model.to.Project;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.utils.StringUtil;

	[Bindable]
	public class ProjectsPM
	{
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject("appModel.clients",bind="true",twoWay="true")]
		public var clients:ArrayCollection;
		
		public var currentProjects:ArrayCollection;
		public var currentClient:Client;
		public var selectedProjectClient:Client;
		public var showOnlyActiveProjects:Boolean;
		public var isDisabled:Boolean;
		public var isEntryValid:Boolean = false;

		private var _currentProject:Project = new Project();
		
		public function get currentProject():Project
		{
			return _currentProject;
		}

		public function set currentProject(value:Project):void
		{
			_currentProject = value;
			
			if(_currentProject != null && currentProject.id != 0)
			{
				setSelectedProjectClient();
			}
			else
			{
				selectedProjectClient = new Client();
			}
		}
		
		public function ProjectsPM()
		{
		}
		
		public function getProjectsByClient():void
		{
			dispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.GET_PROJECTS_BY_CLIENT));
		}
		
		public function checkClients():void
		{
			if(clients == null || clients.length == 0)
			{
				isDisabled = true;
				Alert.show("You need to add clients before you can use this module");
			}
		}
		
		public function setSelectedProjectClient():void
		{
			for each(var client:Client in clients)
			{
				if(client.id == currentProject.client.id)
				{
					selectedProjectClient = client;
				}
			}
		}
		
		public function filterProjects():void
		{
			if(showOnlyActiveProjects)
			{
				currentProjects.filterFunction = isProjectActive;
			}
			else
			{
				currentProjects.filterFunction = null;
			}
			
			currentProjects.refresh();
		}
		
		public function isProjectActive(project:Project):Boolean
		{
			return project.projectActive;
		}
		
		[EventHandler("ProjectEvent.GET_PROJECTS_BY_CLIENT_COMPLETED")]
		public function onProjectsLoaded():void
		{
			filterProjects();
		}
		
		[EventHandler("ProjectEvent.SAVE_PROJECT_COMPLETED")]
		public function onProjectSaved():void
		{
			resetCurrentProject();
		}
		
		[EventHandler("ProjectEvent.DELETE_PROJECT_COMPLETED")]
		public function onProjectDeleted():void
		{
			resetCurrentProject();
		}
		
		public function saveProject():void
		{
			dispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.SAVE_PROJECT));
		}
		
		public function deleteProject():void
		{
			dispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.DELETE_PROJECT));
		}
		
		public function resetCurrentProject():void
		{
			this.currentProject = new Project();
			validateEntry();
		}
		
		public function validateEntry():void
		{
			if(selectedProjectClient == null || selectedProjectClient.id == 0)
			{
				isEntryValid = false;
				return;
			}
			
			if(currentProject == null || StringUtil.trim(currentProject.name).length == 0)
			{
				isEntryValid = false;
				return;
			}
			
			if(StringUtil.trim(currentProject.name).length == 0)
			{
				isEntryValid = false;
				return;
			}
			
			if(StringUtil.trim(currentProject.description).length == 0)
			{
				isEntryValid = false;
				return;
			}
			
			isEntryValid = true;
		}
	}
}