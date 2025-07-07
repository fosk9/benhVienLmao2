package model;

import java.sql.Timestamp;

public class Treatment {
    private int treatmentId;
    private int appointmentId;
    private String treatmentType;
    private String treatmentNotes;
    private Timestamp createdAt;

    public Treatment() {}

    public Treatment(int treatmentId, int appointmentId, String treatmentType, String treatmentNotes, Timestamp createdAt) {
        this.treatmentId = treatmentId;
        this.appointmentId = appointmentId;
        this.treatmentType = treatmentType;
        this.treatmentNotes = treatmentNotes;
        this.createdAt = createdAt;
    }

    public int getTreatmentId() {
        return treatmentId;
    }

    public void setTreatmentId(int treatmentId) {
        this.treatmentId = treatmentId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public String getTreatmentType() {
        return treatmentType;
    }

    public void setTreatmentType(String treatmentType) {
        this.treatmentType = treatmentType;
    }

    public String getTreatmentNotes() {
        return treatmentNotes;
    }

    public void setTreatmentNotes(String treatmentNotes) {
        this.treatmentNotes = treatmentNotes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
