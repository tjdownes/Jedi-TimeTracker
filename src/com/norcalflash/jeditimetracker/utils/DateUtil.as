package com.norcalflash.jeditimetracker.utils
{
	public class DateUtil
	{
		public function DateUtil()
		{
		}
		
		public static function UTCToJulianDay(newDate:Date):Number
		{
			return ( (newDate.time - (newDate.getTimezoneOffset()*60000)  / 86400000) + 2440587.5);
		}
	}
}