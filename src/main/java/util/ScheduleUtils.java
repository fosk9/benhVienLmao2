package util;

import java.sql.Date;
import java.time.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleUtils {

    public static List<Date[]> generateWeekRangesOfYear(int year) {
        List<Date[]> weeks = new ArrayList<>();
        LocalDate date = LocalDate.of(year, 1, 1).with(DayOfWeek.MONDAY);

        while (date.getYear() <= year) {
            LocalDate start = date;
            LocalDate end = start.plusDays(6);
            weeks.add(new Date[]{Date.valueOf(start), Date.valueOf(end)});
            date = date.plusWeeks(1);
        }

        return weeks;
    }

    public static List<Integer> generateYearList() {
        int currentYear = Year.now().getValue();
        List<Integer> years = new ArrayList<>();
        for (int y = currentYear - 2; y <= currentYear + 2; y++) {
            years.add(y);
        }
        return years;
    }
}
