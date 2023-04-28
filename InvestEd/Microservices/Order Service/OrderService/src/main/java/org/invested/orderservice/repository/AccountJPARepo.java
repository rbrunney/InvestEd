package org.invested.orderservice.repository;

import org.invested.orderservice.model.application.account.Account;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountJPARepo extends JpaRepository<Account, String> {
    Account getAccountByEmail(String email);
}
