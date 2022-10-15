package org.invested.accountservice.respository;

import org.invested.accountservice.models.application.Account;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountJPARepo extends JpaRepository<Account, String> {
    Account getAccountByUsername(String username);
    Account getAccountByEmail(String email);
}
