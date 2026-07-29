import { useState, useEffect, useCallback } from "react";
import Sidebar from "./Sidebar";
import Dashboard from "../pages/dashboard";
import Constats from "../pages/constats";

const DEFAULT_API_URL = "http://localhost:3000/api";

export default function AppLayout() {
  const [page, setPage] = useState("dashboard");
  const [apiUrl, setApiUrl] = useState(DEFAULT_API_URL);
  const [constats, setConstats] = useState([]);
  const [error, setError] = useState(null);

  const fetchConstats = useCallback(async () => {
    try {
      const res = await fetch(`${apiUrl}/constats`);
      if (!res.ok){
        throw new Error("Erreur serveur");
      }  
      const data = await res.json();
      setConstats(data);
      setError(null);
    } catch (err) {
      console.error(err);
      setConstats([]);
      setError("Impossible de récupérer les constats depuis le serveur");
    }
  }, [apiUrl]);

  useEffect(() => {
    fetchConstats();
  }, []); 

  return (  
    <div className="flex" style={{ background: "var(--fond2)", minHeight: "100vh", fontFamily: "'Times New Roman', Times, serif"}}>
      <Sidebar
        page={page}
        setPage={setPage}
        apiUrl={apiUrl}
        setApiUrl={setApiUrl}
        onRefresh={fetchConstats}
      />

      <main className="flex-1 p-10 overflow-y-auto" style={{ maxHeight: "100vh", margin: "15px"}}>
        {page === "dashboard" && <Dashboard constats={constats} />}
        {page === "constats" && <Constats 
          constats={constats} 
          apiUrl={apiUrl}
          onRefresh={fetchConstats}
        />}
        {error && (
          <div
            className="mb-6 px-5 py-4 rounded-lg text-sm"
            style={{ background: "#FDF6E3", color: "#8a6d1d", border: "1px solid #f0e0a0", margin: "12px", padding: "12px" }}
          >
            ⚠ {error}
          </div>
        )}
      </main>
    </div>
  );
}