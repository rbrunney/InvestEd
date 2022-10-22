package org.invested.accountservice.errorhandling;

import org.invested.accountservice.models.application.Response;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.security.InvalidKeyException;

@ControllerAdvice
public class InternalExceptionOverride extends ResponseEntityExceptionHandler {

    @ExceptionHandler(InvalidKeyException.class)
    public final ResponseEntity<ExceptionMessage> invalidKey(InvalidKeyException ike) {
        return new ResponseEntity<>(new ExceptionMessage(ike.getMessage(), 400), HttpStatus.BAD_REQUEST);
    }
}
