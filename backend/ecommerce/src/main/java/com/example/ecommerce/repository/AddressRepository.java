package com.example.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.ecommerce.model.Address;
import java.util.*;

@Repository
public interface AddressRepository extends JpaRepository<Address, Long> {

    List<Address> findByEmail(String email);

    Optional<Address> findByIdAndEmail(Long id, String email);
       Optional<Address> findByEmailAndIsDefaultTrue(String email);
}
