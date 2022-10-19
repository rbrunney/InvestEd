package org.invested.orderservice.repository;

import org.invested.orderservice.model.application.order_types.StopPriceOrder;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StopPriceOrderJPARepo extends JpaRepository<StopPriceOrder, String> {
}
