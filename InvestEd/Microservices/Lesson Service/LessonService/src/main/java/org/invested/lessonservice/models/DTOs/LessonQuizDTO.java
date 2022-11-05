package org.invested.lessonservice.models.DTOs;

public class LessonQuizDTO {
    private double investmentReward;
    private String lessonName;

    // /////////////////////////////////////////////////
    // Constructors

    public LessonQuizDTO() {}

    public LessonQuizDTO(double investmentReward, String lessonName) {
        this.investmentReward = investmentReward;
        this.lessonName = lessonName;
    }


    // /////////////////////////////////////////////////
    // Getters and Setters

    public double getInvestmentReward() {
        return investmentReward;
    }

    public void setInvestmentReward(double investmentReward) {
        this.investmentReward = investmentReward;
    }

    public String getLessonName() {
        return lessonName;
    }

    public void setLessonName(String lessonName) {
        this.lessonName = lessonName;
    }
}
