package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.TimeEntryEvent;
	import com.norcalflash.jeditimetracker.model.AppModel;
	import com.norcalflash.jeditimetracker.model.presentation.TimeEntryPM;
	import com.norcalflash.jeditimetracker.model.to.Project;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class LoadActiveProjectsByClientCommand implements IEventAwareCommand
	{
		private var evt:TimeEntryEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var model:TimeEntryPM;
		
		[Inject]
		public var appModel:AppModel;
		
		public function LoadActiveProjectsByClientCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as TimeEntryEvent;
		}
		
		public function execute():void
		{
			getProjects();
		}

		protected function getProjects():void 
		{
			var tmpProject:Project = new Project();
			model.projects = new ArrayCollection(tmpProject.findAll('client_id=@CLIENTID AND active=1', [model.currentClient.id]));
			dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.GET_ACTIVE_PROJECTS_COMPLETED));
		}
	}
}