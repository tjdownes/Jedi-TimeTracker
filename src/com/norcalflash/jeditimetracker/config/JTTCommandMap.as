package com.norcalflash.jeditimetracker.config
{
	import com.norcalflash.jeditimetracker.commands.DeleteClientCommand;
	import com.norcalflash.jeditimetracker.commands.DeleteProjectCommand;
	import com.norcalflash.jeditimetracker.commands.DeleteTimeEntryCommand;
	import com.norcalflash.jeditimetracker.commands.InitializeApplicationCommand;
	import com.norcalflash.jeditimetracker.commands.LoadActiveProjectsByClientCommand;
	import com.norcalflash.jeditimetracker.commands.LoadClientsCommand;
	import com.norcalflash.jeditimetracker.commands.LoadProjectsByClientCommand;
	import com.norcalflash.jeditimetracker.commands.LoadReportsByDateRangeCommand;
	import com.norcalflash.jeditimetracker.commands.LoadTimeEntriesByDateRangeCommand;
	import com.norcalflash.jeditimetracker.commands.SaveClientCommand;
	import com.norcalflash.jeditimetracker.commands.SaveProjectCommand;
	import com.norcalflash.jeditimetracker.commands.SaveTimeEntryCommand;
	import com.norcalflash.jeditimetracker.events.ApplicationEvent;
	import com.norcalflash.jeditimetracker.events.ClientEvent;
	import com.norcalflash.jeditimetracker.events.ProjectEvent;
	import com.norcalflash.jeditimetracker.events.TimeEntryEvent;
	
	import org.swizframework.utils.commands.CommandMap;
	
	public class JTTCommandMap extends CommandMap
	{
		public function JTTCommandMap()
		{
			super();
		}
		
		override protected function mapCommands():void
		{
			if(!_swiz)
			{
				return;
			}
		
			mapCommand(ApplicationEvent.INITALIZE, InitializeApplicationCommand, ApplicationEvent, true);
			
			// client commands
			mapCommand(ClientEvent.GET_ALL_CLIENTS, LoadClientsCommand, ClientEvent);
			mapCommand(ClientEvent.SAVE_CLIENT, SaveClientCommand, ClientEvent);
			mapCommand(ClientEvent.DELETE_CLIENT, DeleteClientCommand, ClientEvent);
			
			//project commands
			mapCommand(ProjectEvent.GET_PROJECTS_BY_CLIENT, LoadProjectsByClientCommand, ProjectEvent);
			mapCommand(ProjectEvent.SAVE_PROJECT, SaveProjectCommand, ProjectEvent);
			mapCommand(ProjectEvent.DELETE_PROJECT, DeleteProjectCommand, ProjectEvent);
			
			// time entry commands
			mapCommand(TimeEntryEvent.GET_ACTIVE_PROJECTS, LoadActiveProjectsByClientCommand, TimeEntryEvent);
			mapCommand(TimeEntryEvent.GET_TIME_ENTRIES_BY_RANGE, LoadTimeEntriesByDateRangeCommand, TimeEntryEvent);
			mapCommand(TimeEntryEvent.SAVE_TIME_ENTRY, SaveTimeEntryCommand, TimeEntryEvent);
			mapCommand(TimeEntryEvent.DELETE_TIME_ENTRY, DeleteTimeEntryCommand, TimeEntryEvent);
			
			// reports commands
			mapCommand(TimeEntryEvent.GET_REPORT_BY_RANGE, LoadReportsByDateRangeCommand, TimeEntryEvent);
		}
	}
}