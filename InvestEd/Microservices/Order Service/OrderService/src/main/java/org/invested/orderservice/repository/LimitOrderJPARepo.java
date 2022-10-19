package org.invested.orderservice.repository;

import org.invested.orderservice.model.application.order_types.LimitOrder;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LimitOrderJPARepo extends JpaRepository<LimitOrder, String> {
}
