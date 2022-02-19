global class HBBatchSch implements Schedulable{
    global void execute(SchedulableContext ctx) {
        HBBatch myHappyBirthdayBatch = new HBBatch();
        database.executebatch(myHappyBirthdayBatch);
    }

}