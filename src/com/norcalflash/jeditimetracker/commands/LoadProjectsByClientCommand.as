package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.ProjectEvent;
	import com.norcalflash.jeditimetracker.model.AppModel;
	import com.norcalflash.jeditimetracker.model.presentation.ProjectsPM;
	import com.norcalflash.jeditimetracker.model.to.Project;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class LoadProjectsByClientCommand implements IEventAwareCommand
	{
		private var evt:ProjectEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var model:ProjectsPM;
		
		[Inject]
		public var appModel:AppModel;
		
		public function LoadProjectsByClientCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as ProjectEvent;
		}
		
		public function execute():void
		{
			getProjects();
		}

		protected function getProjects():void 
		{
			var tmpProject:Project = new Project();
			model.currentProjects = new ArrayCollection(tmpProject.findAll('client_id=@CLIENTID', [model.currentClient.id]));
			dispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.GET_PROJECTS_BY_CLIENT_COMPLETED));
		}
	}
}