package com.norcalflash.jeditimetracker.model.to
{
	import info.noirbizarre.airorm.ActiveRecord;
	
	[Bindable]
	[BelongsTo("client", className="Client")]
	[HasMany("timeEntries", className="TimeEntry")]
	public dynamic class Project extends ActiveRecord
	{
		public var name:String;
		public var description:String;
		private var _active:Number = 1;
		
		public function get active():Number
		{
			return _active;
		}
		
		public function set active(value:Number):void
		{
			_active = value;
			
			if(Boolean(value) != projectActive)
			{
				projectActive = value as Boolean;
			}
		}
		
		[NotPersisted]
		public function get projectActive():Boolean
		{
			return _projectActive;
		}
		public function set projectActive(value:Boolean):void
		{
			_projectActive = value;
			
			if(value != Boolean(active))
			{
				if(value)
					active = 1;
				else
					active = 0;
			}
		}
		private var _projectActive:Boolean = true;
		
		public function Project()
		{
			super();
		}
	}
}