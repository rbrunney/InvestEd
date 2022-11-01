package com.invested.checkportfoliostocks.repositories;

import com.invested.checkportfoliostocks.models.PortfolioStock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface PortfolioStockJPARepository extends JpaRepository<PortfolioStock, String> {

    List<PortfolioStock> getPortfolioStocksByPortfolioId(String portfolioId);

    @Query(value = "SELECT portfolio_id FROM portfolio_stock GROUP BY(portfolio_id)", nativeQuery = true)
    List<String> getPortfolioIds();

    @Query(value = "SELECT ticker FROM portfolio_stock GROUP BY(ticker)", nativeQuery = true)
    List<String> getCurrentStocksInPortfolios();

    @Transactional
    @Modifying
    @Query(value = "UPDATE portfolio_stock SET total_equity= ?1 * total_share_quantity WHERE ticker = ?2", nativeQuery = true)
    void updateTickerTotalEquity(double currentPrice, String ticker);
}
