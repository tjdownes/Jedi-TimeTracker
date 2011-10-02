package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.ProjectEvent;
	import com.norcalflash.jeditimetracker.model.presentation.ProjectsPM;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class DeleteProjectCommand implements IEventAwareCommand
	{
		private var evt:ProjectEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var model:ProjectsPM;
		
		public function DeleteProjectCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as ProjectEvent;
		}
		
		public function execute():void
		{
			deleteProject();
		}

		public function deleteProject():void 
		{
			model.currentProject.deleteById(model.currentProject.id);
			dispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.GET_PROJECTS_BY_CLIENT));
			dispatcher.dispatchEvent(new ProjectEvent(ProjectEvent.DELETE_PROJECT_COMPLETED));
		}
	}
}