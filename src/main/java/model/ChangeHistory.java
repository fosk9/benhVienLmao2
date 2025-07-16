package model;

import lombok.*;

import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChangeHistory {
    private int changeId;
    private int managerId;
    private String managerName;
    private int targetUserId;
    private String targetUserName;
    private String targetSource;
    private String action;
    private Date changeTime;

    // Optional: more display fields if needed in future
}
