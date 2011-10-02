package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.TimeEntryEvent;
	import com.norcalflash.jeditimetracker.model.AppModel;
	import com.norcalflash.jeditimetracker.model.presentation.ReportsPM;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class LoadReportsByDateRangeCommand implements IEventAwareCommand
	{
		private var evt:TimeEntryEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		public var model:ReportsPM;
		
		[Inject]
		public var appModel:AppModel;
		
		public function LoadReportsByDateRangeCommand()
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
			var connection:SQLConnection = new SQLConnection();
			var dbFile:File = File.applicationStorageDirectory.resolvePath("data.db");
			connection.open(dbFile);
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connection;
			
			var df:DateFormatter = new DateFormatter();
			df.formatString = "YYYY-MM-DD";
			
			var sql:String = "SELECT sum(TimeEntries.hours) AS total, " +
								"Projects.name AS project, " +
								"Projects.id AS project_id, " +
								"Clients.id AS client_id, " +
								"Clients.name AS client " +
								"FROM TimeEntries " +
								"JOIN Projects on TimeEntries.project_id = Projects.id " +
								"JOIN Clients on Projects.client_id = Clients.id " +
								"WHERE TimeEntries.project_id = Projects.id " +
								"AND Projects.client_id = Clients.id " +
								"AND julianday(date) >= julianday('" + df.format(model.startDate) + "') " +
								"AND julianday(date) <= julianday('" + df.format(model.endDate) + "') " +
								"GROUP BY Projects.client_id;";
			
			statement.text = sql;
			statement.execute();
			model.timeEntries = new ArrayCollection(statement.getResult().data);
			
			connection.close();
			
			dispatcher.dispatchEvent(new TimeEntryEvent(TimeEntryEvent.GET_REPORT_BY_RANGE_COMPLETED));
		}
	}
}