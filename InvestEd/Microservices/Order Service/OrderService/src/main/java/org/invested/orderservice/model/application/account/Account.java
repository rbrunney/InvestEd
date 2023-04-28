package org.invested.orderservice.model.application.account;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Getter
@Setter
public class Account {

    @Id
    private String id;
    private String email;
    private double buyingPower;

    public Account() {

    }
}
