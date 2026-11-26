import { useEffect, useState } from "react";

type Mesa = {
  id: number;
  identificacao: string;
  capacidade: number;
  status: "DISPONIVEL" | "OCUPADA" | "EM_LIMPEZA" | "INDISPONIVEL";
  zona?: string;
};

const API = import.meta.env.VITE_API_URL ?? "http://localhost:8080";

const nomes: Record<Mesa["status"], string> = {
  DISPONIVEL: "Disponível",
  OCUPADA: "Ocupada",
  EM_LIMPEZA: "Em limpeza",
  INDISPONIVEL: "Indisponível"
};

export default function App() {
  const [mesas, setMesas] = useState<Mesa[]>([]);
  const [erro, setErro] = useState("");

  async function carregarMesas() {
    try {
      const resposta = await fetch(`${API}/api/mesas`);
      if (!resposta.ok) throw new Error("Não foi possível consultar as mesas.");
      setMesas(await resposta.json());
      setErro("");
    } catch {
      setErro("API indisponível. Inicie o backend e confira a conexão com o MySQL.");
    }
  }

  async function alterarStatus(mesa: Mesa, status: Mesa["status"]) {
    try {
      const resposta = await fetch(`${API}/api/mesas/${mesa.id}/status`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status })
      });
      if (!resposta.ok) throw new Error();
      await carregarMesas();
    } catch {
      setErro("Não foi possível atualizar a mesa.");
    }
  }

  useEffect(() => { void carregarMesas(); }, []);

  return (
    <main className="container">
      <header>
        <div><span className="eyebrow">GESTÃO OPERACIONAL</span><h1>Restaurante Inteligente</h1>
          <p>Visão geral das mesas do salão</p></div>
        <button onClick={() => void carregarMesas()}>Atualizar</button>
      </header>
      <section className="summary">
        <article><span>Total de mesas</span><strong>{mesas.length}</strong></article>
        <article><span>Disponíveis</span><strong>{mesas.filter(m => m.status === "DISPONIVEL").length}</strong></article>
        <article><span>Ocupadas</span><strong>{mesas.filter(m => m.status === "OCUPADA").length}</strong></article>
        <article><span>Em limpeza</span><strong>{mesas.filter(m => m.status === "EM_LIMPEZA").length}</strong></article>
      </section>
      {erro && <p className="error">{erro}</p>}
      <section className="section-heading"><div><h2>Mapa de mesas</h2><p>Estado operacional atualizado pela equipe</p></div></section>
      <section className="tables">
        {mesas.map(mesa => <article className={`table-card ${mesa.status.toLowerCase()}`} key={mesa.id}>
          <div className="table-top"><strong>{mesa.identificacao}</strong><span>{nomes[mesa.status]}</span></div>
          <p>Capacidade: {mesa.capacidade} pessoas</p><small>{mesa.zona ?? "Salão"}</small>
          <label htmlFor={`status-${mesa.id}`}>Alterar estado</label>
          <select id={`status-${mesa.id}`} value={mesa.status}
            onChange={e => void alterarStatus(mesa, e.target.value as Mesa["status"])}>
            {Object.entries(nomes).map(([value, label]) =>
              <option key={value} value={value}>{label}</option>)}
          </select>
        </article>)}
        {mesas.length === 0 && !erro && <p>Nenhuma mesa cadastrada. Cadastre mesas pela API para visualizar aqui.</p>}
      </section>
      <footer>Protótipo acadêmico · Os estados exibidos dependem da API e do banco configurados.</footer>
    </main>
  );
}
