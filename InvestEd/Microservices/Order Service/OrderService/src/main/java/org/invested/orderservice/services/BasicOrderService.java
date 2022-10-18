package org.invested.orderservice.services;

import org.invested.orderservice.model.application.order_types.BasicOrder;
import org.invested.orderservice.repository.BasicOrderJPARepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BasicOrderService {

    @Autowired
    private BasicOrderJPARepo basicOrderRepo;

    public String createBasicOrder(BasicOrder basicOrder) {
        basicOrderRepo.save(basicOrder);

        return basicOrder.getId();
    }
}
