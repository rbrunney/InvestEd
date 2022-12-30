package com.invested.portfolioservice.reposititories;

import com.invested.portfolioservice.models.application.Portfolio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.ArrayList;

public interface PortfolioJPARepository extends JpaRepository<Portfolio, String> {
    ArrayList<Portfolio> getPortfoliosByUserId(String userId);

    Portfolio getPortfolioById(String portfolioId);

    @Query(value = "SELECT id FROM portfolio WHERE user_id = ?1", nativeQuery = true)
    String getPortfolioIdByUsername(String user_id);
}
