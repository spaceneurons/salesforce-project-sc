global class HBBatchSch implements Schedulable{
    //Предст тип параметра метода в классе, кот реализ интерфейс Scheduled и сод идентиф запланир задания.
    global void execute(SchedulableContext ctx) {
        HBBatch myHappyBirthdayBatch = new HBBatch();
        database.executebatch(myHappyBirthdayBatch);
    }

}