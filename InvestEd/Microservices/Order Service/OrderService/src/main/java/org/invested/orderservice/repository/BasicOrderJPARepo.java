package org.invested.orderservice.repository;

import org.invested.orderservice.model.application.order_types.BasicOrder;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BasicOrderJPARepo extends JpaRepository<BasicOrder, String> {
    BasicOrder getBasicOrderById(String id);
}
