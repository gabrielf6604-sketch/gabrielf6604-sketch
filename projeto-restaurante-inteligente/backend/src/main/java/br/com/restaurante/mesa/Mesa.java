package br.com.restaurante.mesa;

import jakarta.persistence.*;

@Entity
@Table(name = "mesas")
public class Mesa {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 30)
    private String identificacao;

    @Column(nullable = false)
    private Integer capacidade;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private MesaStatus status = MesaStatus.DISPONIVEL;

    private String zona;

    protected Mesa() {}

    public Mesa(String identificacao, Integer capacidade, String zona) {
        this.identificacao = identificacao;
        this.capacidade = capacidade;
        this.zona = zona;
    }

    public Long getId() { return id; }
    public String getIdentificacao() { return identificacao; }
    public Integer getCapacidade() { return capacidade; }
    public MesaStatus getStatus() { return status; }
    public String getZona() { return zona; }

    public void atualizarStatus(MesaStatus status) {
        this.status = status;
    }
}
