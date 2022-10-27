package com.invested.portfolioservice.reposititories;

import com.invested.portfolioservice.models.PortfolioStock;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.ArrayList;

public interface PortfolioStockJPARepository extends JpaRepository<PortfolioStock, String> {
    ArrayList<PortfolioStock> getPortfolioStocksByPortfolioId(String portfolioId);

    PortfolioStock getPortfolioStockByPortfolioIdAndTicker(String portfolioId, String ticker);

    void deletePortfolioStockByPortfolioIdAndTicker(String portfolioId, String ticker);
}
