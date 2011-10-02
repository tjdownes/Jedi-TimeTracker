package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.ProjectEvent;
	import com.norcalflash.jeditimetracker.model.presentation.ProjectsPM;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class SaveProjectCommand implements IEventAwareCommand
	{
		private var evt:ProjectEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var model:ProjectsPM;
		
		public function SaveProjectCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as ProjectEvent;
		}
		
		public function execute():void
		{
			saveProject();
		}

		public function saveProject():void 
		{
			model.currentProject.save();
			model.currentClient = model.currentProject.client;
			dispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.GET_PROJECTS_BY_CLIENT));
			dispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.SAVE_PROJECT_COMPLETED));
		}
	}
}