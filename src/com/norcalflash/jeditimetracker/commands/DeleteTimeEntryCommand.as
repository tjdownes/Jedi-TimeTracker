package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.TimeEntryEvent;
	import com.norcalflash.jeditimetracker.model.presentation.TimeEntryPM;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class DeleteTimeEntryCommand implements IEventAwareCommand
	{
		private var evt:TimeEntryEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var model:TimeEntryPM;
		
		public function DeleteTimeEntryCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as TimeEntryEvent;
		}
		
		public function execute():void
		{
			deleteTimeEntry();
		}

		public function deleteTimeEntry():void 
		{
			model.currentTimeEntry.deleteById(model.currentTimeEntry.id);
			dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.GET_TIME_ENTRIES_BY_RANGE));
			dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.DELETE_TIME_ENTRY_COMPLETED));
		}
	}
}