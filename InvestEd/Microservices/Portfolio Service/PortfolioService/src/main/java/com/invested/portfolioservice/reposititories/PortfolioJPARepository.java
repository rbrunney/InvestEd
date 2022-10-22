package com.invested.portfolioservice.reposititories;

import com.invested.portfolioservice.models.Portfolio;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.ArrayList;

public interface PortfolioJPARepository extends JpaRepository<Portfolio, String> {
    ArrayList<Portfolio> getPortfoliosByUserId(String userId);
}
