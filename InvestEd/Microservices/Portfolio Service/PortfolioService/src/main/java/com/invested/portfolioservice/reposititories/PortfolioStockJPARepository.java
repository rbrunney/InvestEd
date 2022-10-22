package com.invested.portfolioservice.reposititories;

import com.invested.portfolioservice.models.PortfolioStock;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PortfolioStockJPARepository extends JpaRepository<PortfolioStock, String> {
}
