package org.invested.orderservice.repository;

import org.invested.orderservice.model.application.order_types.StopLossOrder;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StopLossOrderJPARepo extends JpaRepository<StopLossOrder, String> {
}
