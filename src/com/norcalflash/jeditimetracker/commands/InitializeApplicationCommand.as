package com.norcalflash.jeditimetracker.commands
{
	import com.norcalflash.jeditimetracker.events.ApplicationEvent;
	import com.norcalflash.jeditimetracker.model.to.Client;
	import com.norcalflash.jeditimetracker.model.to.Project;
	import com.norcalflash.jeditimetracker.model.to.TimeEntry;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTransactionLockType;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	import info.noirbizarre.airorm.ORM;
	import info.noirbizarre.airorm.utils.DB;
	
	import org.swizframework.utils.commands.IEventAwareCommand;
	
	public class InitializeApplicationCommand implements IEventAwareCommand
	{
		private var evt:ApplicationEvent;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public function InitializeApplicationCommand()
		{
		}
		
		public function set event(value:Event):void
		{
			evt = value as ApplicationEvent;
		}
		
		public function execute():void
		{
			// checkDBNeedsUpgrade is really only needed for the move to ORM and can probably be removed in future versions
			// a better way is needed to handle db upgrades, as in my experience, this can happen frequently
			checkDBNeedsUpgrade();
			setupDatabase();
		}
		
		public function checkDBNeedsUpgrade():void
		{
			var conn:SQLConnection = new SQLConnection();
			var dbFile:File = File.applicationStorageDirectory.resolvePath("data.db");
			
			var setupConn:SQLConnection = new SQLConnection;
			setupConn.open(dbFile, SQLMode.CREATE, true);
			
			try
			{
				setupConn.loadSchema(null, null, "main", false);
			
				var schema:SQLSchemaResult = setupConn.getSchemaResult();
				
				setupConn.close();
			}
			catch(err:Error)
			{
				// no schema defined, we can safely exit upgrade
				setupConn.close();
				return;
			}
			
			var tstmt:SQLStatement = new SQLStatement();
			
			setupConn.open(dbFile);
			tstmt.sqlConnection = setupConn;
			setupConn.begin(SQLTransactionLockType.IMMEDIATE);
			
			var tsql:String;
			
			try 
			{
				for(var i:Number=0; i<schema.tables.length; i++)
				{
					if(schema.tables[i].name == "clients")
					{
						tsql = "CREATE TEMPORARY TABLE clients_backup(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT);"
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "INSERT INTO clients_backup SELECT id,name,description FROM clients;"	
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "DROP TABLE clients;";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "CREATE TABLE Clients(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT);";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "INSERT INTO Clients SELECT id,name,description FROM clients_backup;";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "DROP TABLE clients_backup;";	
						tstmt.text = tsql;
						tstmt.execute();
					}
					
					if(schema.tables[i].name == "projects")
					{
						tsql = "CREATE TEMPORARY TABLE projects_backup(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, clientidfk INTEGER, active INTEGER);";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "INSERT INTO projects_backup SELECT id, name, description, clientidfk, active FROM projects;";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "DROP TABLE projects;";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "CREATE TABLE Projects(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, client_id INTEGER, active INTEGER);";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "INSERT INTO Projects SELECT id, name, description, clientidfk, active FROM projects_backup;";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "DROP TABLE projects_backup;";
						tstmt.text = tsql;
						tstmt.execute();
					}
					
					if(schema.tables[i].name == "hours")
					{
						tsql = "CREATE TEMPORARY TABLE hours_backup(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, projectidfk INTEGER, hours NUMERIC, date DATE);";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "INSERT INTO hours_backup SELECT id, description, projectidfk, hours, date FROM hours;";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "DROP TABLE hours;";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "CREATE TABLE TimeEntries(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, project_id INTEGER, hours NUMERIC, date DATE);";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "INSERT INTO TimeEntries SELECT id, description, projectidfk, hours, date FROM hours_backup;";
						tstmt.text = tsql;
						tstmt.execute();
						
						tsql = "DROP TABLE hours_backup;";
						tstmt.text = tsql;
						tstmt.execute();
					}
				}
				// all changes will now be committed 
				setupConn.commit();
			}
			catch(err:Error)
			{
				setupConn.rollback();
			}
			finally
			{
				setupConn.close();
			}
		}

		public function setupDatabase():void 
		{
			DB.registerConnectionAlias("data.db", "main");
			ORM.registerClass(Client);
			ORM.registerClass(Project);
			ORM.registerClass(TimeEntry);
			ORM.updateDB();
			dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.INITALIZED));
		}
	}
}