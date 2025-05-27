package model;

import lombok.Builder;
import lombok.Data;
@Data
@Builder
public class GoogleAccount {
    private String id;
    private String email;
    private String name;
    private String given_name;
    private String family_name;
    private String picture;
    private boolean verified_email;
}
