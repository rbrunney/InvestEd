package org.invested.repositories;

import org.invested.models.application.order_types.BasicOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderJPARepository extends JpaRepository<BasicOrder, String> {
    BasicOrder getBasicOrderById(String orderId);
}
