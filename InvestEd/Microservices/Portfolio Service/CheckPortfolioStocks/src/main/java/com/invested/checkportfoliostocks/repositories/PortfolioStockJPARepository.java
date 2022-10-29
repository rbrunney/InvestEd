package com.invested.checkportfoliostocks.repositories;

import com.invested.checkportfoliostocks.models.PortfolioStock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PortfolioStockJPARepository extends JpaRepository<PortfolioStock, String> {
    List<PortfolioStock> findPortfolioStocksByPortfolioId(String portfolioId);

    @Query(value = "SELECT ticker FROM portfolio_stock GROUP BY(ticker)", nativeQuery = true)
    List<String> getCurrentStocksInPortfolios();
}
