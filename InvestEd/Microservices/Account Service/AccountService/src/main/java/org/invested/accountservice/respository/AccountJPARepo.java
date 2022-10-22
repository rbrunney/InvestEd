package org.invested.accountservice.respository;

import org.invested.accountservice.models.application.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface AccountJPARepo extends JpaRepository<Account, String> {
    @Query(value = "SELECT id FROM account WHERE username = ?1", nativeQuery = true)
    String getIdByUsername(String username);

    @Query(value = "SELECT email FROM account WHERE username = ?1", nativeQuery = true)
    String getEmailByUsername(String username);

    @Query(value = "SELECT buying_power FROM account WHERE username = ?1", nativeQuery = true)
    double getBuyingPowerByUsername(String username);

    Account getAccountByUsername(String username);
    Account getAccountByEmail(String email);

    Account getAccountById(String id);
}
