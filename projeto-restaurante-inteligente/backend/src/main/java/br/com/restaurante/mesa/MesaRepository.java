package br.com.restaurante.mesa;

import org.springframework.data.jpa.repository.JpaRepository;

public interface MesaRepository extends JpaRepository<Mesa, Long> {
    boolean existsByIdentificacao(String identificacao);
}
