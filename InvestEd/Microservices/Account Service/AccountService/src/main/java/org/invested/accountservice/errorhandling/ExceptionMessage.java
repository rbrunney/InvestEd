package org.invested.accountservice.errorhandling;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ExceptionMessage {
    private final String message;
    private final int httpStatus;

    public ExceptionMessage(String message, Integer httpStatus) {
        this.message = message;
        this.httpStatus = httpStatus;
    }
}
