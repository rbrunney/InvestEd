package org.invested.accountservice.respository;

import org.invested.accountservice.models.application.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

public interface AccountJPARepo extends JpaRepository<Account, UUID> {
    Account getAccountByUsername(String username);
    Account getAccountByEmail(String email);

    @Transactional
    void deleteAccountByUsername(String username);
}
