package com.norcalflash.jeditimetracker.model.to
{
	import info.noirbizarre.airorm.ActiveRecord;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[BelongsTo("project", className="Project")]
	public dynamic class TimeEntry extends ActiveRecord
	{
		public var description:String;
		public var hours:Number = 0.25;
		
		public var date:Date = new Date();
		
		public function TimeEntry()
		{
			super();
		}
	}
}