package model;

import lombok.*;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorShiftView {
    // Thông tin cơ bản
    private int doctorId;
    private String doctorName;
    private String doctorEmail;

    // Tổng số ngày làm việc trong tháng
    private int workingDaysThisMonth;

    // Trạng thái của từng ca trực hôm nay (Morning, Afternoon, Evening, Night)
    private Map<String, String> statusPerSlotToday;

    // ⬇️ Các trường dưới đây chỉ dùng khi xem chi tiết ca trực cụ thể
    private int shiftId;
    private Date shiftDate;
    private String timeSlot;
    private String status;

    private Integer managerId;
    private Timestamp requestedAt;
    private Timestamp approvedAt;
}
