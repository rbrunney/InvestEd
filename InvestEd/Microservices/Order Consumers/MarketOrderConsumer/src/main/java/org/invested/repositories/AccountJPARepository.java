package org.invested.repositories;

import org.invested.models.application.account.Account;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountJPARepository extends JpaRepository<Account, String> {

    Account getAccountById(String id);
}
