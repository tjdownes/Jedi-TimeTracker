package com.norcalflash.jeditimetracker.model.to
{
	import info.noirbizarre.airorm.ActiveRecord;
	
	[Bindable]
	[HasMany("projects", className="Project")]
	public dynamic class Client extends ActiveRecord
	{
		public var name:String;
		public var description:String;
		
		public function Client()
		{
			super();
		}
	}
}