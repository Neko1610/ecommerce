package com.example.ecommerce.services;

import com.example.ecommerce.model.PaymentMethodEntity;
import com.example.ecommerce.model.User;
import com.example.ecommerce.repository.PaymentMethodRepository;
import com.example.ecommerce.repository.UserRepository;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PaymentMethodService {

    private final PaymentMethodRepository repository;

    private final UserRepository userRepository;

    public PaymentMethodService(
            PaymentMethodRepository repository,
            UserRepository userRepository
    ) {
        this.repository = repository;
        this.userRepository = userRepository;
    }

    public List<PaymentMethodEntity> getAllByUser(
            String email
    ) {

        User user =
                userRepository
                        .findByEmail(email)
                        .orElseThrow();

        return repository
                .findByUserIdAndIsLinkedTrue(
                        user.getId()
                );
    }

    public PaymentMethodEntity addMethod(
            PaymentMethodEntity payment,
            String email
    ) {

        User user =
                userRepository
                        .findByEmail(email)
                        .orElseThrow();

        payment.setId(null);

        payment.setUserId(user.getId());

        payment.setLinked(true);

        if (payment.isDefault()) {

            List<PaymentMethodEntity> methods =
                    repository.findByUserId(
                            user.getId()
                    );

            for (PaymentMethodEntity item : methods) {
                item.setDefault(false);
            }

            repository.saveAll(methods);
        }

        return repository.save(payment);
    }

    public PaymentMethodEntity updateMethod(
            Long id,
            PaymentMethodEntity payment
    ) {

        PaymentMethodEntity current =
                repository.findById(id)
                        .orElseThrow();

        current.setType(payment.getType());

        current.setTitle(payment.getTitle());

        current.setSubtitle(payment.getSubtitle());

        current.setExpiry(payment.getExpiry());

        current.setLinked(true);

        if (payment.isDefault()) {

            List<PaymentMethodEntity> methods =
                    repository.findByUserId(
                            current.getUserId()
                    );

            for (PaymentMethodEntity item : methods) {

                item.setDefault(
                        item.getId().equals(id)
                );
            }

            repository.saveAll(methods);

        } else {

            current.setDefault(false);
        }

        return repository.save(current);
    }

    public void deleteMethod(Long id) {

        repository.deleteById(id);
    }

    public void setDefault(Long id) {

        PaymentMethodEntity method =
                repository.findById(id)
                        .orElseThrow();

        List<PaymentMethodEntity> methods =
                repository.findByUserId(
                        method.getUserId()
                );

        for (PaymentMethodEntity item : methods) {

            item.setDefault(
                    item.isLinked() &&
                    item.getId().equals(id)
            );
        }

        repository.saveAll(methods);

        repository.flush();
    }

    public void unlinkMethod(Long id) {

        PaymentMethodEntity method =
                repository.findById(id)
                        .orElseThrow();

        method.setLinked(false);

        method.setDefault(false);

        repository.save(method);
    }
}