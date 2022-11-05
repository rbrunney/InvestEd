package org.invested.lessonservice.models.DTOs;

public class LessonSnippetDTO {
    private String infoSnippet;
    private String lessonName;

    // ////////////////////////////////////////////////////
    // Constructors
    public LessonSnippetDTO() {}

    public LessonSnippetDTO(String infoSnippet, String lessonName) {
        this.infoSnippet = infoSnippet;
        this.lessonName = lessonName;
    }

    // ////////////////////////////////////////////////////
    // Getters and Setters
    public String getInfoSnippet() {
        return infoSnippet;
    }

    public void setInfoSnippet(String infoSnippet) {
        this.infoSnippet = infoSnippet;
    }

    public String getLessonName() {
        return lessonName;
    }

    public void setLessonName(String lessonName) {
        this.lessonName = lessonName;
    }
}
