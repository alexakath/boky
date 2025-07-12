package com.example.biblio.repository;

import com.example.biblio.model.Adherant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AdherantRepository extends JpaRepository<Adherant, Integer> {
    Optional<Adherant> findByEmail(String email);
}