package org.invested.accountservice.models.application;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.Date;
import java.util.UUID;

@Entity
@Getter
@Setter
public class Account {

    @Id
    private String id;

    private String username;
    private String password;
    private String firstName;
    private String lastName;
    private String birthdate;
    private String email;

    private double buyingPower;


    // /////////////////////////////////////////////////////////////////
    // Constructors
    // /////////////////////////////////////////////////////////////////
    public Account() {

    }

    public Account(String username, String password, String firstName, String lastName, String birthdate, String email, double buyingPower) {
        this.id = UUID.randomUUID().toString();
        this.buyingPower = buyingPower;
        this.username = username;
        this.password = password;
        this.firstName = firstName;
        this.lastName = lastName;
        this.birthdate = birthdate;
        this.email = email;
    }
}
