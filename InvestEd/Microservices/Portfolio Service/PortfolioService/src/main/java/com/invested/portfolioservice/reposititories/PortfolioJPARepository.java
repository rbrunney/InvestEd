package com.invested.portfolioservice.reposititories;

import com.invested.portfolioservice.models.Portfolio;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PortfolioJPARepository extends JpaRepository<Portfolio, String> {
}
