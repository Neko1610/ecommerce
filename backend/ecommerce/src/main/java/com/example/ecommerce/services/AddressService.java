package com.example.ecommerce.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.example.ecommerce.repository.*;

import lombok.RequiredArgsConstructor;

import com.example.ecommerce.dto.AddressRequest;
import com.example.ecommerce.model.Address;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AddressService {

    private final AddressRepository repo;

    // ✅ GET ALL
    public List<Address> getMyAddress(String email) {
        return repo.findByEmail(email);
    }

    // ✅ GET DEFAULT
    public Address getDefault(String email) {
        return repo.findByEmailAndIsDefaultTrue(email)
                .orElseThrow(() -> new RuntimeException("No default address"));
    }

    // ✅ CREATE
    public Address create(AddressRequest req, String email) {
        List<Address> list = repo.findByEmail(email);

        Address address = new Address();
        address.setFullAddress(req.getFullAddress());
        address.setLatitude(req.getLatitude());
        address.setLongitude(req.getLongitude());
        address.setLabel(req.getLabel());
        address.setEmail(email);

        // 🔥 LOGIC QUAN TRỌNG
        if (list.isEmpty()) {
            address.setDefault(true); // address đầu tiên
        } else if (req.isDefault()) {
            resetAllDefault(email);
            address.setDefault(true);
        } else {
            address.setDefault(false);
        }

        return repo.save(address);
    }

    // ✅ UPDATE
    public Address update(Long id, AddressRequest req, String email) {
        Address address = repo.findByIdAndEmail(id, email)
                .orElseThrow(() -> new RuntimeException("Address not found"));

        if (req.isDefault()) {
            resetAllDefault(email);
            address.setDefault(true);
        }

        address.setFullAddress(req.getFullAddress());
        address.setLatitude(req.getLatitude());
        address.setLongitude(req.getLongitude());
        address.setLabel(req.getLabel());

        return repo.save(address);
    }

    // ✅ DELETE
    public void delete(Long id, String email) {
        Address address = repo.findByIdAndEmail(id, email)
                .orElseThrow(() -> new RuntimeException("Address not found"));

        boolean wasDefault = address.isDefault();

        repo.delete(address);

        // 🔥 nếu xoá default → gán cái khác
        if (wasDefault) {
            List<Address> list = repo.findByEmail(email);
            if (!list.isEmpty()) {
                Address first = list.get(0);
                first.setDefault(true);
                repo.save(first);
            }
        }
    }

    // ✅ SET DEFAULT (OPTIONAL nếu bạn vẫn muốn API riêng)
    public void setDefault(Long id, String email) {
        resetAllDefault(email);

        Address address = repo.findByIdAndEmail(id, email)
                .orElseThrow(() -> new RuntimeException("Address not found"));

        address.setDefault(true);
        repo.save(address);
    }

    // 🔥 CORE FUNCTION
    private void resetAllDefault(String email) {
        List<Address> list = repo.findByEmail(email);

        for (Address a : list) {
            a.setDefault(false);
        }

        repo.saveAll(list);
    }
}