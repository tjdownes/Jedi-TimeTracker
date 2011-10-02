package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.TimeEntryEvent;
	import com.norcalflash.jeditimetracker.model.AppModel;
	import com.norcalflash.jeditimetracker.model.presentation.TimeEntryPM;
	import com.norcalflash.jeditimetracker.model.to.TimeEntry;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class LoadTimeEntriesByDateRangeCommand implements IEventAwareCommand
	{
		private var evt:TimeEntryEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var model:TimeEntryPM;
		
		[Inject]
		public var appModel:AppModel;
		
		public function LoadTimeEntriesByDateRangeCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as TimeEntryEvent;
		}
		
		public function execute():void
		{
			getTimeEntries();
		}

		protected function getTimeEntries():void 
		{
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYYY-MM-DD";
			
			var tmpTimeEntry:TimeEntry = new TimeEntry();
			
			var criteria:String = "julianday(date) >= julianday('" + df.format(model.startDate) + "') AND julianday(date) <= julianday('" + df.format(model.endDate) + "')"
				
			model.todaysHours = new ArrayCollection(tmpTimeEntry.findAll(criteria, null, "date DESC"));
			calculateSumOfEntries();
			dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.GET_TIME_ENTRIES_BY_RANGE_COMPLETED));
		}
		
		public function calculateSumOfEntries():void
		{
			var totalHours:Number = 0;
			
			for each(var item:Object in model.todaysHours)
			{
				totalHours += item.hours;
			}
			
			model.sumOfHours = totalHours;
		}
	}
}