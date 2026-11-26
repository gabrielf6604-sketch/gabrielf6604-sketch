package br.com.restaurante.mesa;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/mesas")
@CrossOrigin(origins = "http://localhost:5173")
public class MesaController {
    private final MesaRepository repository;

    public MesaController(MesaRepository repository) {
        this.repository = repository;
    }

    public record CriarMesaRequest(
        @NotBlank String identificacao,
        @Min(1) Integer capacidade,
        String zona
    ) {}

    public record AtualizarStatusRequest(MesaStatus status) {}

    @GetMapping
    public List<Mesa> listar() {
        return repository.findAll();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mesa criar(@Valid @RequestBody CriarMesaRequest request) {
        if (repository.existsByIdentificacao(request.identificacao())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Identificação de mesa já cadastrada");
        }
        return repository.save(new Mesa(
            request.identificacao(), request.capacidade(), request.zona()
        ));
    }

    @PatchMapping("/{id}/status")
    public Mesa atualizarStatus(@PathVariable Long id, @RequestBody AtualizarStatusRequest request) {
        if (request.status() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Informe o novo status");
        }
        Mesa mesa = repository.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Mesa não encontrada"));
        mesa.atualizarStatus(request.status());
        return repository.save(mesa);
    }
}
