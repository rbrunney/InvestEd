package com.invested.checkportfoliostocks.repositories;

import com.invested.checkportfoliostocks.models.PortfolioSnapshot;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PortfolioSnapshotJPARepository extends JpaRepository<PortfolioSnapshot, String> {
}
