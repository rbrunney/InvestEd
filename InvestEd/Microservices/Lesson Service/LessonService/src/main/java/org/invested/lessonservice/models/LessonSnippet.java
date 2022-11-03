package org.invested.lessonservice.models;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.UUID;

@Entity
public class LessonSnippet {
    @Id
    private String id;
    private String infoSnippet;
    // ///////////////////////////////////////////////////
    // Constructors

    public LessonSnippet() {}

    public LessonSnippet(String infoSnippet) {
        this.id = UUID.randomUUID().toString();
        this.infoSnippet = infoSnippet;
    }

    // ///////////////////////////////////////////////////
    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getInfoSnippet() {
        return infoSnippet;
    }

    public void setInfoSnippet(String infoSnippet) {
        this.infoSnippet = infoSnippet;
    }
}
