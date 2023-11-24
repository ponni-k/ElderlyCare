public class ScheduleRecurringTask {
	public static void executeSchedule(){
        ElderlyCareRecurrenceTask tasks = new ElderlyCareRecurrenceTask();
        //system.schedule('Create Attendence Record',  '0 0 6 1 * ? *', atd);
        system.schedule('Create Task Record', '0 20 18 * * ?', tasks);
    }
}