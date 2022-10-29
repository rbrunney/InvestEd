package com.invested.checkportfoliostocks.repositories;


import com.invested.checkportfoliostocks.models.Portfolio;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PortfolioJPARepository extends JpaRepository<Portfolio, String> {
}
